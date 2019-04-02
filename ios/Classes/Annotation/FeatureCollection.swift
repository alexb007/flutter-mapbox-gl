
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

// See: https://medium.com/@sergey.gavrilyuk/dynamic-encodable-with-type-erasure-1875722b3171
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
