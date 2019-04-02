
class CircleBuilder: CircleOptionsSink {
    
    private var circleOptions: CircleOptions
    private var circleManager: CircleManager
    
    
    init(circleManager: CircleManager) {
        self.circleManager = circleManager
        circleOptions = CircleOptions()
    }
    
    func build() -> Circle? {
        do {
            return try circleManager.create(options: circleOptions)
        } catch {
            return nil
        }
    }
    
    func setGeometry(geometry: [Double]) {
        circleOptions.setGeometry(geometry: geometry)
    }
    
    func setDraggable(draggable: Bool) {
        circleOptions.setDraggable(draggable: draggable)
    }

    func setCircleRadius(circleRadius: Float) {
        circleOptions.setCircleRadius(circleRadius: circleRadius)
    }
    
    func setCircleColor(circleColor: String) {
        circleOptions.setCircleColor(circleColor: circleColor)
    }
    
    func setCircleBlur(circleBlur: Float) {
        circleOptions.setCircleBlur(circleBlur: circleBlur)
    }
    
    func setCircleOpacity(circleOpacity: Float) {
        circleOptions.setCircleOpacity(circleOpacity: circleOpacity)
    }
    
    func setCircleStrokeWidth(circleStrokeWidth: Float) {
        circleOptions.setCircleStrokeWidth(circleStrokeWidth: circleStrokeWidth)
    }
    
    func setCircleStrokeColor(circleStrokeColor: String) {
        circleOptions.setCircleStrokeColor(circleStrokeColor: circleStrokeColor)
    }
    
    func setCircleStrokeOpacity(circleStrokeOpacity: Float) {
        circleOptions.setCircleStrokeOpacity(circleStrokeOpacity: circleStrokeOpacity)
    }
}
