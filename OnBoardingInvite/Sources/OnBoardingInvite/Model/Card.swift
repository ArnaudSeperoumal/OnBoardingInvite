import Foundation
import SwiftUI

public struct Card<Content: View>: Identifiable {
    public static func == (lhs: Card, rhs: Card) -> Bool {
        lhs.id == rhs.id
    }
    
    public var id: String = UUID().uuidString
    public var image: String
    public var view: Content
    
    public init(image: String, view: Content) {
        self.image = image
        self.view = view
    }
}
