//
//  Animator.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 21.02.2023.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    enum TransitionDirection {
        case right
        case left
    }
    
    let transitionDuration: Double = 0.20
    let transitionDirection: TransitionDirection
    
    init(_ direction: TransitionDirection) {
        transitionDirection = direction
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?)
    -> TimeInterval {
        return transitionDuration as TimeInterval
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let translation: CGFloat = transitionDirection == .right ? container.frame.width : -container
            .frame.width
        let toViewStartFrame = container.frame
            .applying(CGAffineTransform(translationX: translation, y: 0))
        let fromViewFinalFrame = container.frame
            .applying(CGAffineTransform(translationX: -translation, y: 0))
        
        container.addSubview(toView)
        toView.frame = toViewStartFrame
        
        UIView.animate(withDuration: transitionDuration, animations: {
            fromView.frame = fromViewFinalFrame
            toView.frame = container.frame
            
        }) { _ in
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
