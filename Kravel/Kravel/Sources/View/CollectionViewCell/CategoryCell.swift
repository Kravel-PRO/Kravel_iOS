//
//  CategoryCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/13.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    static let identifier = "categoryCell"
    
    private var textLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    var category: String? {
        didSet {
            textLabel.text = category
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setAutoLayout()
    }
    
    private func setAutoLayout() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
