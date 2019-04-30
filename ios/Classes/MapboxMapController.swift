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

    private var channel: FlutterMethodChannel?
    private var lineManager: LineManager?
    private var circleManager: CircleManager?
    
    func view() -> UIView {
        return mapView
    }
    
    init(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, registrar: FlutterPluginRegistrar) {
        mapView = MGLMapView(frame: frame)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.registrar = registrar

        super.init()
        
        channel = FlutterMethodChannel(name: "plugins.flutter.io/mapbox_maps_\(viewId)", binaryMessenger: registrar.messenger())
        channel!.setMethodCallHandler(onMethodCall)
        
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
        
        // Add a single tap gesture recognizer. This gesture requires the built-in MGLMapView tap gestures (such as those for zoom and annotation selection) to fail.
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(sender:)))
        for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
            singleTap.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(singleTap)
    }
    
    @objc @IBAction func handleMapTap(sender: UITapGestureRecognizer) {
        // Get the CGPoint where the user tapped.
        let spot = sender.location(in: mapView)
        
        // Access the features at that point within the state layer.
        let layerIds = Set([lineManager!.ID_GEOJSON_LAYER, circleManager!.ID_GEOJSON_LAYER])
        let features = mapView.visibleFeatures(at: spot, styleLayerIdentifiers: layerIds)
        if let feature = features.first, let channel = channel {
            if(feature is MGLPolylineFeature) {
                var arguments: [String: Any] = [:]
                if let id = feature.identifier {
                    arguments["line"] = "\(id)"
                }
                channel.invokeMethod("line#onTap", arguments: arguments)
            }
            if(feature is MGLPointFeature) {
                var arguments: [String: Any] = [:]
                if let id = feature.identifier {
                    arguments["circle"] = "\(id)"
                }
                channel.invokeMethod("circle#onTap", arguments: arguments)
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
                result("\(line.id)")
            } else {
                result(nil)
            }
        case "line#update":
            guard let lineManager = lineManager else { return }
            guard let arguments = methodCall.arguments as? [String: Any] else { return }
            guard let lineIdString = arguments["line"] as? String else { return }
            guard let lineId = UInt64(lineIdString) else { return }
            guard let line = lineManager.getAnnotation(id: lineId) else { return }
            
            // Create a line and update it.
            let lineBuilder = LineBuilder(lineManager: lineManager, line: line)
            Convert.interpretLineOptions(options: arguments["options"], delegate: lineBuilder)
            lineBuilder.update(id: lineId)
            result(nil)
        case "line#remove":
            guard let lineManager = lineManager else { return }
            guard let arguments = methodCall.arguments as? [String: Any] else { return }
            guard let lineIdString = arguments["line"] as? String else { return }
            guard let lineId = UInt64(lineIdString) else { return }
            guard let line = lineManager.getAnnotation(id: lineId) else { return }
            
            lineManager.delete(annotation: line)
            result(nil)
        case "circle#add":
            guard let circleManager = circleManager else { return }
            guard let arguments = methodCall.arguments as? [String: Any] else { return }
            
            // Create a circle and populate it.
            let circleBuilder = CircleBuilder(circleManager: circleManager)
            Convert.interpretCircleOptions(options: arguments["options"], delegate: circleBuilder)
            if let circle = circleBuilder.build() {
                result("\(circle.id)")
            } else {
                result(nil)
            }
        case "circle#update":
            guard let circleManager = circleManager else { return }
            guard let arguments = methodCall.arguments as? [String: Any] else { return }
            guard let circleIdString = arguments["circle"] as? String else { return }
            guard let circleId = UInt64(circleIdString) else { return }
            guard let circle = circleManager.getAnnotation(id: circleId) else { return }
            
            // Create a circle and populate it.
            let circleBuilder = CircleBuilder(circleManager: circleManager, circle: circle)
            Convert.interpretCircleOptions(options: arguments["options"], delegate: circleBuilder)
            circleBuilder.update(id: circleId)
            result(nil)
        case "circle#remove":
            guard let circleManager = circleManager else { return }
            guard let arguments = methodCall.arguments as? [String: Any] else { return }
            guard let circleIdString = arguments["circle"] as? String else { return }
            guard let circleId = UInt64(circleIdString) else { return }
            guard let circle = circleManager.getAnnotation(id: circleId) else { return }
            
            circleManager.delete(annotation: circle)
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
        
        lineManager = LineManager()
        if let lineManager = lineManager {
            style.addSource(lineManager.source)
            style.addLayer(lineManager.layer!)
        }
        
        circleManager = CircleManager()
        if let circleManager = circleManager {
            style.addSource(circleManager.source)
            style.addLayer(circleManager.layer!)
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
        mapView.compassView.isHidden = !compassEnabled
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
            mapView.styleURL = URL(string: styleString)
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
    func setMyLocationTrackingMode(myLocationTrackingMode: MGLUserTrackingMode) {
        mapView.userTrackingMode = myLocationTrackingMode
    }
}
