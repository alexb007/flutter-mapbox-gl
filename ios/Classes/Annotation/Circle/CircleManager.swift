import Mapbox

class CircleManager: AnnotationManager<PointGeometry> {
    
    private let ID_GEOJSON_SOURCE = "mapbox-ios-circle-source"
    private let ID_GEOJSON_LAYER = "mapbox-ios-circle-layer"
    var layer: MGLCircleStyleLayer?
    
    init() {
        super.init(sourceId: ID_GEOJSON_SOURCE)

        layer = MGLCircleStyleLayer(identifier: ID_GEOJSON_LAYER, source: source)
        setDataDrivenLayerProperties()
    }
    
    func setDataDrivenLayerProperties() {
        if let layer = layer {
            layer.circleRadius = NSExpression(forKeyPath: CircleOptions.KEY_CIRCLE_RADIUS)
            layer.circleColor = NSExpression(forKeyPath: CircleOptions.KEY_CIRCLE_COLOR)
            layer.circleBlur = NSExpression(forKeyPath: CircleOptions.KEY_CIRCLE_BLUR)
            layer.circleOpacity = NSExpression(forKeyPath: CircleOptions.KEY_CIRCLE_OPACITY)
            layer.circleStrokeWidth = NSExpression(forKeyPath: CircleOptions.KEY_CIRCLE_STROKE_WIDTH)
            layer.circleStrokeColor = NSExpression(forKeyPath: CircleOptions.KEY_CIRCLE_STROKE_COLOR)
            layer.circleStrokeOpacity = NSExpression(forKeyPath: CircleOptions.KEY_CIRCLE_STROKE_OPACITY)
        }
    }
}
