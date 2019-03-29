import Mapbox

class Line : MGLPolyline, LineOptionsSink {
    var id: String {
        get { return "TODO:SOME_ID" }
    }
    
    func setGeometry(geometry: [[Double]]) {
        var coordinates: [CLLocationCoordinate2D] = []
        for point in geometry {
            coordinates.append(CLLocationCoordinate2D.fromArray(point))
        }
//        self.coordinate = coordinates
    }
    
    func setLineColor(lineColor: String) {
        //TODO:
    }

}
