import UIKit

final class ZoomOutAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let to = transitionContext.view(forKey: .to) ,
            let from = transitionContext.view(forKey: .from) else { return }

        to.alpha = 0

        let container = transitionContext.containerView
        container.addSubview(to)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            to.alpha = 1
            from.transform = CGAffineTransform(scaleX: 2, y: 2)
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}
