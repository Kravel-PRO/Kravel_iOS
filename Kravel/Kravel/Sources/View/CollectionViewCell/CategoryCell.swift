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
    static let nibName = "CategoryCell"
    
    private var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .veryLightPink
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var category: String? {
        didSet {
            textLabel.text = category
            textLabel.sizeToFit()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            textLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 14) : UIFont.systemFont(ofSize: 14)
            textLabel.textColor = isSelected ? .grapefruit : .veryLightPink
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(textLabel)
        setAutoLayout()
    }
    
    private func setAutoLayout() {
        NSLayoutConstraint.activate([
            textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
