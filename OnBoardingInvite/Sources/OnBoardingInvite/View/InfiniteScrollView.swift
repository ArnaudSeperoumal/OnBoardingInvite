import SwiftUI
import UIKit

struct InfiniteScrollView<Content: View>: View {
    @ViewBuilder var content: Content
    let spacing: CGFloat = 10
    @State private var contentSize: CGSize = .zero
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: spacing) {
                Group(subviews: content) { collection in
                    HStack(spacing: spacing) {
                        ForEach(collection) { view in
                            view
                        }
                    }
                    .onGeometryChange(for: CGSize.self) {
                        $0.size
                    } action: { newValue in
                        contentSize = .init(width: newValue.width + spacing, height: newValue.height)
                    }
                    
                    HStack(spacing: spacing) {
                        ForEach(0..<collection.count, id: \.self) { index in
                            let view = Array(collection)[index % collection.count]
                            
                            view
                        }
                    }
                }
            }
            .background(InfiniteHelper(contentSize: $contentSize, rate: .constant(.fast)))
        }
    }
    
}

fileprivate struct InfiniteHelper: UIViewRepresentable {
    @Binding var contentSize: CGSize
    @Binding var rate: UIScrollView.DecelerationRate
    
    func makeCoordinator() -> Coordinator {
        Coordinator(contentSize: contentSize, rate: rate)
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        DispatchQueue.main.async {
            if let scrollView = view.scrollView {
                context.coordinator.defaultDelegate = scrollView.delegate
                scrollView.delegate = context.coordinator
                scrollView.decelerationRate = rate
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.contentSize = contentSize
        context.coordinator.rate = rate
        
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var contentSize: CGSize
        var rate: UIScrollView.DecelerationRate
        
        init(contentSize: CGSize, rate: UIScrollView.DecelerationRate) {
            self.contentSize = contentSize
            self.rate = rate
        }
        
        weak var defaultDelegate: UIScrollViewDelegate?
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            scrollView.decelerationRate = rate
            let minX = scrollView.contentOffset.x
            
            if minX > contentSize.width {
                scrollView.contentOffset.x -= contentSize.width
            }
            
            if minX < 0 {
                scrollView.contentOffset.x += contentSize.width
            }
            
            defaultDelegate?.scrollViewDidScroll?(scrollView)
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            defaultDelegate?.scrollViewDidEndDecelerating?(scrollView)
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            defaultDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
        }
        
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            defaultDelegate?.scrollViewWillBeginDragging?(scrollView)
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            defaultDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
            
    }

}

extension UIView {
    var scrollView: UIScrollView? {
        if let superview, superview is UIScrollView {
            return superview as? UIScrollView
        }
        return superview?.scrollView
    }
}
        
