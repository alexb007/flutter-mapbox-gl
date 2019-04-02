
class LineBuilder: LineOptionsSink {
    private var lineOptions: LineOptions
    private var lineManager: LineManager
    
    
    init(lineManager: LineManager) {
        self.lineManager = lineManager
        lineOptions = LineOptions()
    }
    
    func build() -> Line? {
        do {
            return try lineManager.create(options: lineOptions)
        } catch {
            return nil
        }
    }
    
    func setGeometry(geometry: [[Double]]) {
        var geojsonGeometry: [[Double]] = [[Double]]()
        for geo in geometry {
            geojsonGeometry.append([geo[1], geo[0]])
        }
        lineOptions.setGeometry(geometry: geojsonGeometry)
    }
    
    func setLineColor(lineColor: String) {
        lineOptions.lineColor = lineColor
    }
    
    func setLineWidth(lineWidth: Double) {
        lineOptions.lineWidth = lineWidth
    }
    
}
