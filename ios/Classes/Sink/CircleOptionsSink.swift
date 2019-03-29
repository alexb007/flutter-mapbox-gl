
protocol CircleOptionsSink {
    func setCircleRadius(circleRadius: Float)
    func setCircleColor(circleColor: String)
    func setCircleBlur(circleBlur: Float)
    func setCircleOpacity(circleOpacity: Float)
    func setCircleStrokeWidth(circleStrokeWidth: Float)
    func setCircleStrokeColor(circleStrokeColor: String)
    func setCircleStrokeOpacity(circleStrokeOpacity: Float)
    // Not part of MGLCircleStyleLayer
    func setGeometry(geometry: [Double])
    func setDraggable(draggable: Bool)
}
