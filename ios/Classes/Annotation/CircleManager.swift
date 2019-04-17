import Mapbox

class CircleManager: AnnotationManager<CircleGeometry> {
    private let ID_GEOJSON_SOURCE = "mapbox-ios-circle-source"
    let ID_GEOJSON_LAYER = "mapbox-ios-circle-layer"
    var layer: MGLCircleStyleLayer?
    
    init() {
        super.init(sourceId: ID_GEOJSON_SOURCE)
        layer = MGLCircleStyleLayer(identifier: ID_GEOJSON_LAYER, source: source)
    }
    
    func create(options: CircleOptions) -> Circle? {
        setDataDrivenLayerProperties(options: options)
        return super.create(options: options)
    }
    
    func update(id: UInt64, options: CircleOptions) {
        setDataDrivenLayerProperties(options: options)
        super.update(id:id, options: options)
    }
    
    func setDataDrivenLayerProperties(options: CircleOptions) {
        guard let layer = layer else { return }

        if let _ = options.circleRadius {
            layer.circleRadius = NSExpression(forKeyPath: CircleOptions.KEY_CIRCLE_RADIUS)
        }
        if let _ = options.circleColor {
            layer.circleColor = NSExpression(forKeyPath: CircleOptions.KEY_CIRCLE_COLOR)
        }
        if let _ = options.circleBlur {
            layer.circleBlur = NSExpression(forKeyPath: CircleOptions.KEY_CIRCLE_BLUR)
        }
        if let _ = options.circleOpacity {
            layer.circleOpacity = NSExpression(forKeyPath: CircleOptions.KEY_CIRCLE_OPACITY)
        }
        if let _ = options.circleStrokeWidth {
            layer.circleStrokeWidth = NSExpression(forKeyPath: CircleOptions.KEY_CIRCLE_STROKE_WIDTH)
        }
        if let _ = options.circleStrokeColor {
            layer.circleStrokeColor = NSExpression(forKeyPath: CircleOptions.KEY_CIRCLE_STROKE_COLOR)
        }
        if let _ = options.circleStrokeOpacity {
            layer.circleStrokeOpacity = NSExpression(forKeyPath: CircleOptions.KEY_CIRCLE_STROKE_OPACITY)
        }
    }
}
