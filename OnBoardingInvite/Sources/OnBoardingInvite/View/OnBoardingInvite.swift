import SwiftUI

let delta: CGFloat = 1.2
public typealias ViewIdentifiable = View & Identifiable & Equatable

public struct OnBoardingInviteView<Content> : View where Content : ViewIdentifiable {
//public struct OnBoardingInviteView: View {
    var cards: [Content]
    @State private var activeCard: Content
    
    public init(cards: [Content]) {
        guard let first = cards.first else {
            fatalError("No cards")
        }
        self.cards = cards
        self.activeCard = first // as! ObjectIdentifier
    }

    public var body: some View {
        ZStack {
            AmbiantBck()
            
            VStack(spacing: 35) {
                InfiniteScrollView {
                    ForEach(cards) { card in
//                            CardView(card: card)
                        card
                            .scrollTransition(.interactive.threshold(.centered), axis: .horizontal) { content, phase in
                                        content
                                            .offset(y: phase == .identity ? -10 : 0)
                                            .rotationEffect(.degrees(phase.value * 5), anchor: .bottom)
                                    }
                    }
                }
                .scrollIndicators(.hidden)
                .containerRelativeFrame(.vertical) { value, _ in
                    value * 0.65
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
        let _ = print("size: \(size)")
            ZStack {
                ForEach(cards) { card in
//////                    Image(card.image)
//////                        .resizable()
//////                        .aspectRatio(contentMode: .fill)
//                    if activeCard == card {
                        
                        card
                            .ignoresSafeArea()
                            .frame(width: width, height: height)
                            .offset(x: -(width - size.width) / 2, y: -(height - size.height) / 2)
                            .opacity(activeCard == card ? 1 : 0)
//                    }
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
    
//    @ViewBuilder
//    private func CardView(card: Card) -> some View {
//        GeometryReader {
//            let size = $0.size
//            
//            Image(card.image)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: size.width, height: size.height)
//                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 1)
//        }
//        .frame(width: 220)
//        .scrollTransition(.interactive.threshold(.centered), axis: .horizontal) { content, phase in
//            content
//                .offset(y: phase == .identity ? -10 : 0)
//                .rotationEffect(.degrees(phase.value * 5), anchor: .bottom)
//        }
//    }
}
