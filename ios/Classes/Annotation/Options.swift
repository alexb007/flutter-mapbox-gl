
class Options<G: Geometry> {
    
    func build(id: Float) throws -> Feature<G> {
        assert(false, "This method must be overriden by the subclass")
    }
}
