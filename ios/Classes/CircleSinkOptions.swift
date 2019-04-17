import Mapbox

protocol CircleOptionsSink {
    func setGeometry(geometry: [Double])
    
    func setCircleRadius(circleRadius: Double)
    func setCircleColor(circleColor: String)
    func setCircleBlur(circleBlur: Double)
    func setCircleOpacity(circleOpacity: Double)
    func setCircleStrokeWidth(circleStrokeWidth: Double)
    func setCircleStrokeColor(circleStrokeColor: String)
    func setCircleStrokeOpacity(circleStrokeOpacity: Double)
}
