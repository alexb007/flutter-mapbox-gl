import Mapbox

class LineManager {

    static let ID_GEOJSON_SOURCE = "mapbox-ios-line-source";
    static let ID_GEOJSON_LAYER = "mapbox-ios-line-layer";
    
    private var source: MGLShapeSource
    private var layer: MGLLineStyleLayer
    
    init(identifier: String) {
        source = MGLShapeSource(identifier: identifier, shape: nil, options: nil)
        layer = MGLLineStyleLayer(identifier: identifier, source: source)
    }
    
    func setProp() {
        // From the docs: https://docs.mapbox.com/mapbox-gl-js/style-spec/#layers
//        layer.lineCap
//        layer.lineMiterLimit
//        layer.lineRoundLimit
//        layer.lineTranslation
//        layer.lineTranslationAnchor
//        layer.lineDashPattern
//        layer.lineGradient

        
        layer.lineJoin = NSExpression(forConstantValue: "round")
        layer.lineOpacity = NSExpression(forConstantValue: 1.0)
        layer.lineColor = NSExpression(forConstantValue: UIColor.red)
        layer.lineWidth = nil
        layer.lineGapWidth = nil
        layer.lineOffset = nil
        layer.lineBlur = nil
        layer.linePattern = nil
//        layer.geometry = nil;
//        layer.draggable = true;
    }
    func addLine() {
        var mutableCoordinates: [CLLocationCoordinate2D] = []
        
        let polyline = MGLPolylineFeature(coordinates: &mutableCoordinates, count: UInt(mutableCoordinates.count))
        
        source.shape = polyline
    }
    
}
