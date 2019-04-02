import Mapbox

class AnnotationManager<G: Geometry>  {
    private(set) var source: MGLShapeSource
//    internal var layer: MGLVectorStyleLayer?
    
    internal var annotations: [Float: Annotation<G>]
    private var currentId: Float = 0
    
    init(sourceId: String) {
        source = MGLShapeSource(identifier: sourceId, shape: nil, options: nil)
        annotations = [Float: Annotation<G>]()
    }
    
    func create(options: Options<G>) throws -> Annotation<G> {
        let annotation = try options.build(id: currentId)
        annotations[currentId] = annotation
        currentId += 1
        updateSource()
        return annotation
    }
    
    func update(annotation: Annotation<G>) {
        if let _ = annotations[annotation.id] {
            annotations[annotation.id] = annotation
            updateSource()
        }
    }
    
    func delete(id: Float) {
        annotations.removeValue(forKey: id)
        updateSource()
    }
    
    func deleteAll() {
        annotations.removeAll()
        updateSource()
    }
    
    func updateSource() {
        let features = Array(annotations.values)
        let featureCollection = FeatureCollection<G>(features: features)
        let data = try! JSONEncoder().encode(featureCollection)
        let shape = try! MGLShape(data: data, encoding: String.Encoding.utf8.rawValue) as? MGLShapeCollectionFeature
        source.shape = shape
    }
}
