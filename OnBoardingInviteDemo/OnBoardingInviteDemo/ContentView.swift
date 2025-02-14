import SwiftUI
import OnBoardingInvite

struct ContentView: View {
    var body: some View {
        OnBoardingInviteView(cards: [
            Carte("card1"),
            Carte("card2"),
            Carte("card3"),
            Carte("card4")
        ])
    }
}

struct Carte: View {
    var img: String
    
    init(_ img: String) {
        self.img = img
    }
    
    var body: some View {
        Image(img)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

extension Carte: Identifiable {
    var id: String {
        UUID().uuidString
    }
}

extension Carte: Equatable { }

#Preview {
    ContentView()
}
