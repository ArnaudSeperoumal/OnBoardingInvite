import SwiftUI

let delta: CGFloat = 1.5

public struct OnBoardingInviteView: View {
    var cards: [Card]
    @State private var activeCard: Card
    
    public init(cards: [Card]) {
        guard let first = cards.first else {
            fatalError("No cards")
        }
        self.cards = cards
        self.activeCard = first
    }

    public var body: some View {
        ZStack {
            AmbiantBck()
            
            VStack(spacing: 35) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(cards) { card in
                            CardView(card: card)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .containerRelativeFrame(.vertical) { value, _ in
                    value * 0.55
                }
            }
            .safeAreaPadding(15)
        }
    }
    
    @ViewBuilder
    private func AmbiantBck() -> some View {
        GeometryReader {
            let size = $0.size
            let width = size.width * delta
            let height = size.height * delta
            ZStack {
                ForEach(cards) { card in
                    Image(card.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea()
                        .frame(width: width, height: height)
                        .offset(x: -(width - size.width) / 2, y: -(height - size.height) / 2)
                        .opacity(activeCard == card ? 1 : 0)
                }
                
                Rectangle()
                    .fill(.black.opacity(0.45))
                    .ignoresSafeArea()
                    
            }
            .compositingGroup()
            .blur(radius: 80, opaque: true)
            .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    private func CardView(card: Card) -> some View {
        GeometryReader {
            let size = $0.size
            
            Image(card.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width, height: size.height)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 1)
        }
        .frame(width: 220)
        .scrollTransition(.interactive.threshold(.centered), axis: .horizontal) { content, phase in
            content
                .offset(y: phase == .identity ? -10 : 0)
                .rotationEffect(.degrees(phase.value * 5), anchor: .bottom)
        }
    }
}
