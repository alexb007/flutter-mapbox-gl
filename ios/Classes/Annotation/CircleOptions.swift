import Mapbox

class CircleOptions: Options<CircleGeometry> {
    static let KEY_CIRCLE_RADIUS = "circle-radius"
    static let KEY_CIRCLE_COLOR = "circle-color"
    static let KEY_CIRCLE_BLUR = "circle-blur"
    static let KEY_CIRCLE_OPACITY = "circle-opacity"
    static let KEY_CIRCLE_STROKE_WIDTH = "circle-stroke-width"
    static let KEY_CIRCLE_STROKE_COLOR = "circle-stroke-color"
    static let KEY_CIRCLE_STROKE_OPACITY = "circle-stroke-opacity"

    private var properties: [String: AnyEncodable]
    
    init(properties: [String: AnyEncodable]) {
        self.properties = properties
    }
    
    convenience override init() {
        self.init(properties: [String: AnyEncodable]())
    }
    
    private(set) var geometry: CircleGeometry?
    func setGeometry(geometry: [Double]) {
        self.geometry = CircleGeometry(coordinates: geometry)
    }
    
    var circleRadius: Double? {
        get {
            if let value = properties[CircleOptions.KEY_CIRCLE_RADIUS] {
                return value.encodable as? Double
            }
            return nil
        }
        set(newValue) {
            properties[CircleOptions.KEY_CIRCLE_RADIUS] = AnyEncodable(newValue)
        }
    }
    
    var circleColor: String? {
        get {
            if let value = properties[CircleOptions.KEY_CIRCLE_COLOR] {
                return value.encodable as? String
            }
            return nil
        }
        set(newValue) {
            properties[CircleOptions.KEY_CIRCLE_COLOR] = AnyEncodable(newValue)
        }
    }
    
    var circleBlur: Double? {
        get {
            if let value = properties[CircleOptions.KEY_CIRCLE_BLUR] {
                return value.encodable as? Double
            }
            return nil
        }
        set(newValue) {
            properties[CircleOptions.KEY_CIRCLE_BLUR] = AnyEncodable(newValue)
        }
    }
    
    var circleOpacity: Double? {
        get {
            if let value = properties[CircleOptions.KEY_CIRCLE_OPACITY] {
                return value.encodable as? Double
            }
            return nil
        }
        set(newValue) {
            properties[CircleOptions.KEY_CIRCLE_OPACITY] = AnyEncodable(newValue)
        }
    }
    
    var circleStrokeWidth: Double? {
        get {
            if let value = properties[CircleOptions.KEY_CIRCLE_STROKE_WIDTH] {
                return value.encodable as? Double
            }
            return nil
        }
        set(newValue) {
            properties[CircleOptions.KEY_CIRCLE_STROKE_WIDTH] = AnyEncodable(newValue)
        }
    }
    
    var circleStrokeColor: String? {
        get {
            if let value = properties[CircleOptions.KEY_CIRCLE_STROKE_COLOR] {
                return value.encodable as? String
            }
            return nil
        }
        set(newValue) {
            properties[CircleOptions.KEY_CIRCLE_STROKE_COLOR] = AnyEncodable(newValue)
        }
    }
    
    var circleStrokeOpacity: Double? {
        get {
            if let value = properties[CircleOptions.KEY_CIRCLE_STROKE_OPACITY] {
                return value.encodable as? Double
            }
            return nil
        }
        set(newValue) {
            properties[CircleOptions.KEY_CIRCLE_STROKE_OPACITY] = AnyEncodable(newValue)
        }
    }
    
    override func build(id: UInt64) -> Feature<CircleGeometry>? {
        if let geometry = geometry  {
            return Circle(id: id, geometry: geometry, properties: properties)
        }
        return nil
    }
}
