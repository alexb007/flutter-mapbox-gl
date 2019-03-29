import Mapbox

struct FeatureCollection<G: Geometry>: Encodable {
    let type = "FeatureCollection"
    var features: [Feature<G>]
}

struct Feature<G: Geometry>: Encodable {
    var id: Float
    let type: String = "Feature"
    var geometry: G
    var properties: [String : AnyEncodable]
}

struct PointGeometry: Point {
    let type = "Point"
    var coordinates: [Double]
}

//See: https://medium.com/@sergey.gavrilyuk/dynamic-encodable-with-type-erasure-1875722b3171
struct AnyEncodable: Encodable {
    var _encodeFunc: (Encoder) throws -> Void
    
    init(_ encodable: Encodable) {
        func _encode(to encoder: Encoder) throws {
            try encodable.encode(to: encoder)
        }
        self._encodeFunc = _encode
    }
    func encode(to encoder: Encoder) throws {
        try _encodeFunc(encoder)
    }
}

protocol Geometry: Encodable {
    var type: String { get }
}

protocol Point: Geometry {
    var coordinates: [Double] { get set }
}

protocol MultiPoint: Geometry {
    var coordinates: [[Double]] { get set }
}

protocol LineString: Geometry {
    var coordinates: [[Double]] { get set }
}

protocol MultiLineString: Geometry {
    var coordinates: [[[Double]]] { get set }
}

protocol Polygon: Geometry {
    var coordinates: [[[Double]]] { get set }
}

protocol MultiPolygon: Geometry {
    var coordinates: [[[Double]]] { get set }
}

