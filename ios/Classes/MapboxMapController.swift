import Flutter
import UIKit
import Mapbox

class MapboxMapController: NSObject, FlutterPlatformView, MGLMapViewDelegate, MapboxMapOptionsSink {
    
    private var registrar: FlutterPluginRegistrar
    
    private var mapView: MGLMapView
    private var isMapReady = false
    private var mapReadyResult: FlutterResult?
    
    private var initialTilt: CGFloat?
    private var cameraTargetBounds: MGLCoordinateBounds?
    private var trackCameraPosition = false
    private var myLocationEnabled = false

    private var circleManager: CircleManager?
    private var lineManager: LineManager?
    
    func view() -> UIView {
        return mapView
    }
    
    init(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, registrar: FlutterPluginRegistrar) {
        mapView = MGLMapView(frame: frame)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.registrar = registrar

        super.init()
        
        let channel = FlutterMethodChannel(name: "plugins.flutter.io/mapbox_maps_\(viewId)", binaryMessenger: registrar.messenger())
        channel.setMethodCallHandler(onMethodCall)
        
        mapView.delegate = self
        
        if let args = args as? [String: Any] {
            Convert.interpretMapboxMapOptions(options: args["options"], delegate: self)
            if let initialCameraPosition = args["initialCameraPosition"] as? [String: Any],
                let camera = MGLMapCamera.fromDict(initialCameraPosition, mapView: mapView),
                let zoom = initialCameraPosition["zoom"] as? Double {
                mapView.setCenter(camera.centerCoordinate, zoomLevel: zoom, direction: camera.heading, animated: false)
                initialTilt = camera.pitch
            }
        }
    }
    
    func onMethodCall(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch(methodCall.method) {
        case "map#waitForMap":
            if isMapReady {
                result(nil)
            } else {
                mapReadyResult = result
            }
        case "map#update":
            guard let arguments = methodCall.arguments as? [String: Any] else { return }
            Convert.interpretMapboxMapOptions(options: arguments["options"], delegate: self)
            if let camera = getCamera() {
                result(camera.toDict(mapView: mapView))
            } else {
                result(nil)
            }
        case "camera#move":
            guard let arguments = methodCall.arguments as? [String: Any] else { return }
            guard let cameraUpdate = arguments["cameraUpdate"] as? [Any] else { return }
            if let camera = Convert.parseCameraUpdate(cameraUpdate: cameraUpdate, mapView: mapView) {
                mapView.setCamera(camera, animated: false)
            }
        case "camera#animate":
            guard let arguments = methodCall.arguments as? [String: Any] else { return }
            guard let cameraUpdate = arguments["cameraUpdate"] as? [Any] else { return }
            if let camera = Convert.parseCameraUpdate(cameraUpdate: cameraUpdate, mapView: mapView) {
                mapView.setCamera(camera, animated: true)
            }
        case "symbol#add":
            guard let arguments = methodCall.arguments as? [String: Any] else { return }
            
            // Create a symbol and populate it.
            let symbol = Symbol()
            Convert.interpretSymbolOptions(options: arguments["options"], delegate: symbol)
            if CLLocationCoordinate2DIsValid(symbol.geometry) {
                mapView.addAnnotation(symbol)
                result(symbol.id)
            } else {
                result(nil)
            }
        case "line#add":
            guard let lineManager = lineManager else { return }
            guard let arguments = methodCall.arguments as? [String: Any] else { return }
            
            // Create a line and populate it.
            let lineBuilder = LineBuilder(lineManager: lineManager)
            Convert.interpretLineOptions(options: arguments["options"], delegate: lineBuilder)
            if let line = lineBuilder.build() {
//                result(line.id)
                let data = try! JSONEncoder().encode(line)
                result(String(bytes: data, encoding: .utf8))
            } else {
                result(nil)
            }
        case "circle#add":
            guard let circleManager = circleManager else { return }
            guard let arguments = methodCall.arguments as? [String: Any] else { return }

            // Create a circle and populate it.
            let circleBuilder = CircleBuilder(circleManager: circleManager)
            Convert.interpretCircleOptions(options: arguments["options"], delegate: circleBuilder)
            let circle = circleBuilder.build()
//            result(circle.id)
            
//            let features = circleManager.source.features(matching: nil)
//            result(features.description)
            
//            let circles = Array(circleManager.circles.values)
//            let fc = FeatureCollection<PointGeometry>(features: circles)
//            let data = try! JSONEncoder().encode(fc)
//            result(String(bytes: data, encoding: .utf8))
        case "circle#remove":
            guard let circleManager = circleManager else { return }
            guard let arguments = methodCall.arguments as? [String: Any] else { return }
            guard let circleId = arguments["circle"] as? Float else { return }
            
            circleManager.delete(id: circleId)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func updateMyLocationEnabled() {
        //TODO
    }
    
    private func getCamera() -> MGLMapCamera? {
        return trackCameraPosition ? mapView.camera : nil
    }
    
    /*
     *  MGLMapViewDelegate
     */
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        isMapReady = true
        updateMyLocationEnabled()
        
        if let initialTilt = initialTilt {
            let camera = mapView.camera
            camera.pitch = initialTilt
            mapView.setCamera(camera, animated: false)
        }
        
        circleManager = CircleManager()
        if let circleManager = circleManager {
            style.addSource(circleManager.source)
            style.addLayer(circleManager.layer!)
        }
        
        lineManager = LineManager(identifier: "lines")
        if let lineManager = lineManager {
            style.addSource(lineManager.source)
            style.addLayer(lineManager.layer!)
        }
        mapReadyResult?(nil)
    }
    
    func mapView(_ mapView: MGLMapView, shouldChangeFrom oldCamera: MGLMapCamera, to newCamera: MGLMapCamera) -> Bool {
        guard let bbox = cameraTargetBounds else { return true }
        // Get the current camera to restore it after.
        let currentCamera = mapView.camera
        
        // From the new camera obtain the center to test if it’s inside the boundaries.
        let newCameraCenter = newCamera.centerCoordinate
        
        // Set the map’s visible bounds to newCamera.
        mapView.camera = newCamera
        let newVisibleCoordinates = mapView.visibleCoordinateBounds
        
        // Revert the camera.
        mapView.camera = currentCamera
        
        // Test if the newCameraCenter and newVisibleCoordinates are inside bbox.
        let inside = MGLCoordinateInCoordinateBounds(newCameraCenter, bbox)
        let intersects = MGLCoordinateInCoordinateBounds(newVisibleCoordinates.ne, bbox) && MGLCoordinateInCoordinateBounds(newVisibleCoordinates.sw, bbox)
        
        return inside && intersects
    }

    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        // Only for Symbols images are loaded.
        guard let symbol = annotation as? Symbol,
            let iconImage = symbol.iconImage else {
                return nil
        }
        // Reuse existing annotations for better performance.
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: iconImage)
        
        if annotationImage == nil {
            // TODO: remove this hardcoded asset identifier.
            let assetPath = registrar.lookupKey(forAsset: "assets/symbols/")
            let image = UIImage.loadFromFile(imagePath: assetPath, imageName: iconImage)
            // Initialize the annotation image with the UIImage we just loaded (if present).
            if let image = image {
                annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: iconImage)
            }
        }
        return annotationImage
    }

    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    /*
     *  MapboxMapOptionsSink
     */
    func setCameraTargetBounds(bounds: MGLCoordinateBounds?) {
        cameraTargetBounds = bounds
    }
    func setCompassEnabled(compassEnabled: Bool) {
        mapView.compassView.isHidden = compassEnabled
    }
    func setMinMaxZoomPreference(min: Double, max: Double) {
        mapView.minimumZoomLevel = min
        mapView.maximumZoomLevel = max
    }
    func setStyleString(styleString: String) {
        // Check if json, url or plain string:
        if styleString.isEmpty {
            NSLog("setStyleString - string empty")
        } else if (styleString.hasPrefix("{") || styleString.hasPrefix("[")) {
            // Currently the iOS Mapbox SDK does not have a builder for json.
            NSLog("setStyleString - JSON style currently not supported")
        } else {
            mapView.styleURL = NSURL(string: styleString) as! URL
        }
    }
    func setRotateGesturesEnabled(rotateGesturesEnabled: Bool) {
        mapView.allowsRotating = rotateGesturesEnabled
    }
    func setScrollGesturesEnabled(scrollGesturesEnabled: Bool) {
        mapView.allowsScrolling = scrollGesturesEnabled
    }
    func setTiltGesturesEnabled(tiltGesturesEnabled: Bool) {
        mapView.allowsTilting = tiltGesturesEnabled
    }
    func setTrackCameraPosition(trackCameraPosition: Bool) {
        self.trackCameraPosition = trackCameraPosition
    }
    func setZoomGesturesEnabled(zoomGesturesEnabled: Bool) {
        mapView.allowsZooming = zoomGesturesEnabled
    }
    func setMyLocationEnabled(myLocationEnabled: Bool) {
        if (self.myLocationEnabled == myLocationEnabled) {
            return
        }
        self.myLocationEnabled = myLocationEnabled
        updateMyLocationEnabled()
    }
}
