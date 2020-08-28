//
//  PagingViewCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/14.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class PagingViewCell: UICollectionViewCell {
    static let identifier = "pagingViewCell"
    
    @IBOutlet weak var containerView: UIView!
    
    var childView: UIView? {
        didSet {
            guard let childView = childView else { return }
            childView.translatesAutoresizingMaskIntoConstraints = false
            childView.frame = containerView.bounds
            containerView.addSubview(childView)
            NSLayoutConstraint.activate([
                childView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                childView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                childView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                childView.topAnchor.constraint(equalTo: containerView.topAnchor)
            ])
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        childView?.removeFromSuperview()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
