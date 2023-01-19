//
//  StretchyHeaderView.swift
//  MasterGragaeTask
//
//  Created by Shwait Kumar on 17/11/22.
//

import Foundation
import UIKit

/// Stretchy Header
final class StretchyHeaderView: UIView {
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var imageViewHeight = NSLayoutConstraint()
    private var imageViewBottom = NSLayoutConstraint()
    private var containerView = UIView()
    private var containerViewHeight = NSLayoutConstraint()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
        setViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Create Subviews
    private func createViews() {
        addSubview(containerView)
        containerView.addSubview(imageView)
    }
    
    /// Setup View Constraints
    func setViewConstraints() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: containerView.widthAnchor),
            centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = translatesAutoresizingMaskIntoConstraints
        containerViewHeight = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerViewHeight.isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewBottom = imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        imageViewBottom.isActive = true
        imageViewHeight = imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        imageViewHeight.isActive = true
    }
    
    /// Notify View of scroll change from container
    public func scrollviewDidScroll(scrollView: UIScrollView) {
        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
    
}
