//
//  NearByAttractionCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/25.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class NearByAttractionCell: UICollectionViewCell {
    static let identifier = "NearByAttractionCell"
    
    // MARK: - 주변 관광지 앞에 표시할 그림자 뷰
    var shadowView: UIView = {
        let shadowView = UIView()
        shadowView.backgroundColor = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 0.45)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        return shadowView
    }()
    
    // MARK: - 주변 관광지 이미지 설정
    var nearByAttractionImageView: UIImageView = {
        let nearByAttractionImageView = UIImageView()
        nearByAttractionImageView.translatesAutoresizingMaskIntoConstraints = false
        nearByAttractionImageView.contentMode = .scaleAspectFill
        return nearByAttractionImageView
    }()
    
    var nearByAttractionImage: UIImage? {
        didSet {
            nearByAttractionImageView.image = nearByAttractionImage
        }
    }
    
    // MARK: - 주변 관광지 이름 Label
    var nearByAttractionNameLabel: UILabel = {
        let nearByAttractionNameLabel = UILabel()
        nearByAttractionNameLabel.font = UIFont.systemFont(ofSize: 14)
        nearByAttractionNameLabel.textColor = .white
        nearByAttractionNameLabel.textAlignment = .center
        return nearByAttractionNameLabel
    }()
    
    var nearByAttractionName: String? {
        didSet {
            nearByAttractionNameLabel.text = nearByAttractionName
            nearByAttractionNameLabel.sizeToFit()
        }
    }
    
    // MARK: - UICollectionViewCell Override 설정
    override func prepareForReuse() {
        super.prepareForReuse()
        nearByAttractionImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(nearByAttractionImageView)
        self.contentView.addSubview(shadowView)
        self.contentView.addSubview(nearByAttractionNameLabel)
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentView.addSubview(nearByAttractionImageView)
        self.contentView.addSubview(shadowView)
        self.contentView.addSubview(nearByAttractionNameLabel)
        setLayout()
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            nearByAttractionImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            nearByAttractionImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            nearByAttractionImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            nearByAttractionImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            shadowView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            shadowView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            shadowView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            nearByAttractionNameLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            nearByAttractionNameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
}
