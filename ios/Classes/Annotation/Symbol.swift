import Mapbox

class Symbol : MGLPointAnnotation, SymbolOptionsSink {
    var id: String {
        get { return "TODO:SOME_ID" }
    }
    var geometry: CLLocationCoordinate2D {
        get{ return coordinate }
    }
    private var _iconImage: String?
    var iconImage: String? {
        get { return _iconImage }
    }
    var textField: String? {
        get { return title }
    }
    
    // MARK: Setters
    
    func setGeometry(geometry: [Double]) {
        if geometry.count == 2, -90...90 ~= geometry[0], -180...180 ~= geometry[1] {
            coordinate = CLLocationCoordinate2D(latitude: geometry[0], longitude: geometry[1])
        } else {
            NSLog("Invalid geometry")
        }
    }
    
    func setIconImage(iconImage: String) {
        _iconImage = iconImage
    }
    func setTextField(textField: String) {
        title = textField
    }
}
