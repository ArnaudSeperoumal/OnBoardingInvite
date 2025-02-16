import SwiftUI
import OnBoardingInvite

struct ContentView: View {
    var subview: some View {
        VStack(spacing: 10) {
            Text("Welcome to")
                .font(.headline)
                .foregroundStyle(.gray)
            
            Text("OnBoarding Invite")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            Text("Create beautiful onboarding screens with ease with OnBoarding Invite Package. Anyone can use it, from beginners to experts.\n it's customizable and easy to use.")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
        }
    }
    
    var body: some View {
        OnBoardingInviteView(cards: [
            Carte("card1"),
            Carte("card2"),
            Carte("card3"),
            Carte("card4")
        ], subview: subview)
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
