import SwiftUI

let delta: CGFloat = 1.2
public typealias ViewIdentifiable = View & Identifiable & Equatable

public struct OnBoardingInviteView<Content, Content2> : View where Content : ViewIdentifiable, Content2 : View {
    var cards: [Content]
    var subview: Content2
    var spacing: CGFloat
    var relativeFrame: CGFloat
    var cardWidth: CGFloat
    @State private var activeCard: Content
    @State private var scrollPosition: ScrollPosition = .init()
    @State private var currentScrollOffset: CGFloat = 0
    @State private var timer = Timer.publish(every: 0.01, on: .current, in: .default).autoconnect()
    
    public init(cards: [Content], subview: Content2, spacing: CGFloat = 35, relativeFrame: CGFloat = 0.55, cardWidth: CGFloat = 0) {
        guard let first = cards.first else {
            fatalError("No cards")
        }
        self.cards = cards
        self.activeCard = first
        self.subview = subview
        self.spacing = spacing
        self.relativeFrame = relativeFrame
        self.cardWidth = cardWidth
    }

    public var body: some View {
        ZStack {
            AmbiantBck()
                .animation(.easeInOut(duration: 1))
            
            VStack(spacing: spacing) {
                InfiniteScrollView {
                    ForEach(cards) { card in
                        GeometryReader { proxy in
                            let _ = print("proxy.size: \(proxy.size)")
                            card
                                .scrollTransition(.interactive.threshold(.centered), axis: .horizontal) { content, phase in
                                    content
                                        .offset(y: phase == .identity ? -10 : 0)
                                        .rotationEffect(.degrees(phase.value * 5), anchor: .bottom)
                                }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .scrollPosition($scrollPosition)
                .containerRelativeFrame(.vertical) { value, _ in
                    value * self.relativeFrame
                }
                .onScrollGeometryChange(for: CGFloat.self) { scrollGeometry in
                    let retour = scrollGeometry.contentOffset.x + scrollGeometry.contentInsets.leading
                    return retour
                } action: { oldValue, newValue in
                    currentScrollOffset = newValue
                    if cardWidth != 0 {
                        let activeIndex = Int((currentScrollOffset / cardWidth).rounded()) % cards.count
                        if activeCard != cards[activeIndex] {
                            activeCard = cards[activeIndex]
                            let _ = print("activeCard: \(activeCard)")
                        }
                    }
                }

                subview
            }
            .safeAreaPadding(15)
        }
        .onReceive(timer) { _ in
            currentScrollOffset += 0.3
            scrollPosition.scrollTo(x: currentScrollOffset)
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
                        card
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
}
