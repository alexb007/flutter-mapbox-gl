
import Mapbox

protocol LineOptionsSink {
    func setGeometry(geometry: [[Double]])
    func setLineColor(lineColor: String)
}
