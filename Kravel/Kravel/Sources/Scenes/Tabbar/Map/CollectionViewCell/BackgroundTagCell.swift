//
//  BackgroundTagCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/13.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class BackgroundTagCell: UICollectionViewCell {
    static let identifier = "BackgroundTagCell"
    
    // MARK: - 태그 라벨 설정
    var tagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = UIColor(red: 255/255, green: 99/255, blue: 89/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var tagTitle: String? {
        didSet {
            tagLabel.text = tagTitle
            tagLabel.sizeToFit()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 255/255, green: 99/255, blue: 89/255, alpha: 0.1)
        self.contentView.addSubview(tagLabel)
        setLabelLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor(red: 255/255, green: 99/255, blue: 89/255, alpha: 0.1)
        self.contentView.addSubview(tagLabel)
        setLabelLayout()
    }
    
    private func setLabelLayout() {
        NSLayoutConstraint.activate([
            tagLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            tagLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            tagLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            tagLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4)
        ])
    }

}
