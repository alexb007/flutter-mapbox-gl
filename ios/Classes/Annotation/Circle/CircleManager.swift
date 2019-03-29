import Mapbox

class CircleManager {
    
    private let ID_GEOJSON_SOURCE = "mapbox-ios-circle-source"
    private let ID_GEOJSON_LAYER = "mapbox-ios-circle-layer"
    
    private(set) var source: MGLShapeSource
    private(set) var layer: MGLCircleStyleLayer
    
    var circles: [Float: Circle]
    private var currentId: Float = 0
    
    init() {
        source = MGLShapeSource(identifier: ID_GEOJSON_SOURCE, shape: nil, options: nil)
        layer = MGLCircleStyleLayer(identifier: ID_GEOJSON_LAYER, source: source)
        circles = [Float: Circle]()
        
        layer.circleRadius = NSExpression(forKeyPath: CircleOptions.KEY_CIRCLE_RADIUS)
        layer.circleColor = NSExpression(forKeyPath: CircleOptions.KEY_CIRCLE_COLOR)
        layer.circleBlur = NSExpression(forKeyPath: CircleOptions.KEY_CIRCLE_BLUR)
        layer.circleOpacity = NSExpression(forKeyPath: CircleOptions.KEY_CIRCLE_OPACITY)
        layer.circleStrokeWidth = NSExpression(forKeyPath: CircleOptions.KEY_CIRCLE_STROKE_WIDTH)
        layer.circleStrokeColor = NSExpression(forKeyPath: CircleOptions.KEY_CIRCLE_STROKE_COLOR)
        layer.circleStrokeOpacity = NSExpression(forKeyPath: CircleOptions.KEY_CIRCLE_STROKE_OPACITY)
    }
    
    func create(options: CircleOptions) -> Circle {
        let circle = options.build(id: currentId)
        circles[currentId] = circle
        currentId += 1
        updateSource()
        return circle
    }
    
    func delete(circle: Circle) {
        delete(id: circle.id)
    }
    
    func delete(id: Float) {
        circles.removeValue(forKey: id)
    }
    
    func updateSource() {
        let fc = FeatureCollection<PointGeometry>(features: Array(circles.values))
        let data = try! JSONEncoder().encode(fc)
        let shape = try! MGLShape(data: data, encoding: String.Encoding.utf8.rawValue) as? MGLShapeCollectionFeature
        source.shape = shape
    }
}
