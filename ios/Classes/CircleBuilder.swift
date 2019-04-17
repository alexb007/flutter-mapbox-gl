class CircleBuilder: CircleOptionsSink {
    private var circleOptions: CircleOptions
    private var circleManager: CircleManager
    
    init(circleManager: CircleManager, options: CircleOptions) {
        self.circleManager = circleManager
        self.circleOptions = options
    }
    
    convenience init(circleManager: CircleManager) {
        self.init(circleManager: circleManager, options: CircleOptions())
    }
    
    convenience init(circleManager: CircleManager, circle: Circle) {
        let circleOptions = CircleOptions(properties: circle.properties)
        circleOptions.setGeometry(geometry: circle.geometry.coordinates)
        self.init(circleManager: circleManager, options: circleOptions)
    }
    
    func setGeometry(geometry: [Double]) {
        circleOptions.setGeometry(geometry: [geometry[1], geometry[0]])
    }
    
    func setCircleRadius(circleRadius: Double) {
        circleOptions.circleRadius = circleRadius
    }
    
    func setCircleColor(circleColor: String) {
        circleOptions.circleColor = circleColor
    }
    
    func setCircleBlur(circleBlur: Double) {
        circleOptions.circleBlur = circleBlur
    }
    
    func setCircleOpacity(circleOpacity: Double) {
        circleOptions.circleOpacity = circleOpacity
    }
    
    func setCircleStrokeWidth(circleStrokeWidth: Double) {
        circleOptions.circleStrokeWidth = circleStrokeWidth
    }
    
    func setCircleStrokeColor(circleStrokeColor: String) {
        circleOptions.circleStrokeColor = circleStrokeColor
    }
    
    func setCircleStrokeOpacity(circleStrokeOpacity: Double) {
        circleOptions.circleStrokeOpacity = circleStrokeOpacity
    }
    
    func build() -> Circle? {
        return circleManager.create(options: circleOptions)
    }

    func update(id: UInt64) {
        circleManager.update(id: id, options: circleOptions)
    }
}
