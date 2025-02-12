import Foundation

public struct Card: Identifiable, Hashable {
    public var id: String = UUID().uuidString
    public var image: String
    
    public init(image: String) {
        self.image = image
    }
}
