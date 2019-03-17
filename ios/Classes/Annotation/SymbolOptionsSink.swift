
import Mapbox

protocol SymbolOptionsSink {    
    func setGeometry(geometry: [Double])
    func setIconImage(iconImage: String)
    func setTextField(textField: String)
}
