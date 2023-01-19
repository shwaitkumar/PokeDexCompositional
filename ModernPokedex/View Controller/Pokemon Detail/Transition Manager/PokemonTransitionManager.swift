//
//  FullScreenTransitionManager.swift
//  MasterGragaeTask
//
//  Created by Shwait Kumar on 12/10/22.
//

import Foundation
import UIKit
import TinyConstraints

// MARK: PokemonPresentationController
final class PokemonPresentationController: UIPresentationController {
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .close)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(close), for: .primaryActionTriggered)
        button.size(CGSize(width: 30, height: 30))
        button.layer.cornerRadius = 15
        return button
    }()
    
    private lazy var backgroundView: UIVisualEffectView = {
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.effect = nil
        return blurVisualEffectView
    }()
    
    private let blurEffect = UIBlurEffect(style: .systemThinMaterial)
    
    @objc private func close(_ button: UIButton) {
        presentedViewController.viewDidDisappear(true)
        presentedViewController.dismiss(animated: true)
    }
}

// MARK: UIPresentationController
extension PokemonPresentationController {
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        containerView.addSubview(backgroundView)
        containerView.addSubview(closeButton)
        backgroundView.edgesToSuperview()
        closeButton.topToSuperview(offset: 10, usingSafeArea: true)
        closeButton.trailingToSuperview(offset: 14, usingSafeArea: true)
        
        guard let transitionCoordinator = presentingViewController.transitionCoordinator else { return }
        
        closeButton.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        transitionCoordinator.animate(alongsideTransition: { context in
            self.backgroundView.effect = self.blurEffect
            self.closeButton.transform = .identity
        })
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            backgroundView.removeFromSuperview()
            closeButton.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        guard let transitionCoordinator = presentingViewController.transitionCoordinator else { return }
        
        transitionCoordinator.animate(alongsideTransition: { context in
            self.backgroundView.effect = nil
            self.closeButton.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            backgroundView.removeFromSuperview()
            closeButton.removeFromSuperview()
        }
    }
}

// MARK: PokemonTransitionManager
final class PokemonTransitionManager: NSObject, UIViewControllerTransitioningDelegate {
    private let anchorViewTag: Int
    private weak var anchorView: UIView?
    
    init(anchorViewTag: Int) {
        self.anchorViewTag = anchorViewTag
    }
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        anchorView = (presenting ?? source).view.viewWithTag(anchorViewTag)
        return PokemonPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        PokemonAnimationController(animationType: .present, anchorView: anchorView)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        PokemonAnimationController(animationType: .dismiss, anchorView: anchorView)
    }
}

// MARK: UIViewControllerAnimatedTransitioning
final class PokemonAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    fileprivate enum AnimationType {
        case present
        case dismiss
    }
    
    private let animationType: AnimationType
    private let animationDuration: TimeInterval
    private weak var anchorView: UIView?
    
    private let anchorViewCenter: CGPoint
    private let anchorViewSize: CGSize
    private let anchorViewTag: Int
    
    private var propertyAnimator: UIViewPropertyAnimator?
    
    fileprivate init(animationType: AnimationType, animationDuration: TimeInterval = 0.3, anchorView: UIView?) {
        self.animationType = animationType
        self.anchorView = anchorView
        self.animationDuration = animationDuration
        
        if let anchorView = anchorView {
            anchorViewCenter = anchorView.superview?.convert(anchorView.center, to: nil) ?? .zero
            anchorViewSize = anchorView.bounds.size
            anchorViewTag = anchorView.tag
        } else {
            anchorViewCenter = .zero
            anchorViewSize = .zero
            anchorViewTag = 0
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch animationType {
        case .present:
            guard
                let toViewController = transitionContext.viewController(forKey: .to)
            else {
                return transitionContext.completeTransition(false)
            }
            transitionContext.containerView.insertSubview(toViewController.view, at: 1) // In between the presentations controller's background and close button
            toViewController.view.edgesToSuperview()
            toViewController.view.layoutIfNeeded()
            propertyAnimator = presentAnimator(with: transitionContext, animating: toViewController)
        case .dismiss:
            guard
                let fromViewController = transitionContext.viewController(forKey: .from)
            else {
                return transitionContext.completeTransition(false)
            }
            propertyAnimator = dismissAnimator(with: transitionContext, animating: fromViewController)
        }
    }
    
    private func presentAnimator(with transitionContext: UIViewControllerContextTransitioning,
                                 animating viewController: UIViewController) -> UIViewPropertyAnimator {
        let view: UIView = viewController.view.viewWithTag(anchorViewTag) ?? viewController.view
        let finalSize = view.bounds.size
        let finalCenter = view.center
        view.transform = CGAffineTransform(scaleX: anchorViewSize.width / finalSize.width,
                                           y: anchorViewSize.height / finalSize.height)
        view.center = view.superview!.convert(anchorViewCenter, from: nil)
        anchorView?.isHidden = true
        return UIViewPropertyAnimator.runningPropertyAnimator(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseInOut, .transitionCrossDissolve], animations: {
            view.transform = .identity
            view.center = finalCenter
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    private func dismissAnimator(with transitionContext: UIViewControllerContextTransitioning,
                                 animating viewController: UIViewController) -> UIViewPropertyAnimator {
        let view: UIView = viewController.view.viewWithTag(anchorViewTag) ?? viewController.view
        let initialSize = view.bounds.size
        let finalCenter = view.superview!.convert(anchorViewCenter, from: nil)
        let finalTransform = CGAffineTransform(scaleX: self.anchorViewSize.width / initialSize.width,
                                               y: self.anchorViewSize.height / initialSize.height)
        return UIViewPropertyAnimator.runningPropertyAnimator(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseInOut], animations: {
            view.transform = finalTransform
            view.center = finalCenter
        }, completion: { _ in
            self.anchorView?.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
