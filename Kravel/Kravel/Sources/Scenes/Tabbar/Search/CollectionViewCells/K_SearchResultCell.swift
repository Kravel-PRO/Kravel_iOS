//
//  K_SearchResultCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/08.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class K_SearchResultCell: UICollectionViewCell {
    static let identifier = "K_SearchResultCell"
    
    // MARK: - 이미지 보여주는 Label
    var searchImageView: UIImageView = {
        let searchImageView = UIImageView()
        searchImageView.translatesAutoresizingMaskIntoConstraints = false
        searchImageView.contentMode = .scaleAspectFill
        searchImageView.clipsToBounds = true
        return searchImageView
    }()
    
    private func setSearchImageViewLayout() {
        NSLayoutConstraint.activate([
            searchImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            searchImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            searchImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            searchImageView.heightAnchor.constraint(equalTo: searchImageView.widthAnchor, multiplier: 1)
        ])
        
        searchImageView.layer.cornerRadius = self.frame.width / 2
    }
    
    // MARK: - 이름 설정 Label
    var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textColor = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1.0)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    var name: String? {
        didSet {
            nameLabel.text = name
            nameLabel.sizeToFit()
        }
    }
    
    private func setNameLabelLayout() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: searchImageView.bottomAnchor, constant: 4),
            nameLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
    }
    
    // MARK: - 연도 설정하는 Label
    var yearLabel: UILabel = {
        let yearLabel = UILabel()
        yearLabel.font = UIFont.systemFont(ofSize: 12)
        yearLabel.textColor = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 0.6)
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        return yearLabel
    }()
    
    var year: String? {
        didSet {
            yearLabel.text = year
            yearLabel.sizeToFit()
        }
    }
    
    private func setYearLabel() {
        NSLayoutConstraint.activate([
            yearLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            yearLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(searchImageView)
        addSubview(nameLabel)
        addSubview(yearLabel)
        setSearchImageViewLayout()
        setNameLabelLayout()
        setYearLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(searchImageView)
        addSubview(nameLabel)
        addSubview(yearLabel)
        setSearchImageViewLayout()
        setNameLabelLayout()
        setYearLabel()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        searchImageView.image = nil
        name = nil
        year = nil
    }
}
