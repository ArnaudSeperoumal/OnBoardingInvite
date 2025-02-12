import SwiftUI
import OnBoardingInvite

struct ContentView: View {
    var body: some View {
        OnBoardingInviteView(cards: [
            Card(image: "Card1"),
            Card(image: "Card2"),
            Card(image: "Card3"),
            Card(image: "Card4")
        ])
    }
}

#Preview {
    ContentView()
}
