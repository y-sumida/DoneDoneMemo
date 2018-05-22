import UIKit

final class ZoomInAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let to = transitionContext.view(forKey: .to) else { return }

        to.transform = CGAffineTransform(scaleX: 2, y: 2)

        let container = transitionContext.containerView
        container.addSubview(to)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            to.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}
