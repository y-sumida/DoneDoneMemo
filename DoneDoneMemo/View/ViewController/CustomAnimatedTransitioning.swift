import UIKit

final class CustomAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let to = transitionContext.view(forKey: .to) else { return }

        let container = transitionContext.containerView

        to.alpha = 0.0

        container.addSubview(to)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            to.alpha = 1.0
            }, completion: { _ in
                transitionContext.completeTransition(true)
        })
    }
}
