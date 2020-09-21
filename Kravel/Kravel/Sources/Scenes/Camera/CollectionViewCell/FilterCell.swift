//
//  FilterCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/22.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    static let identifier = "FilterCell"
    
    // MARK: - 선택 되었을 때, 색상 지정
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? UIColor.white : UIColor.white.withAlphaComponent(0.51)
            filterNameLabel.textColor = isSelected ? UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0) : UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 0.26)
        }
    }
    
    // MARK: - 필터 네임
    var filterNameLabel: UILabel = {
        let filterNameLabel = UILabel()
        filterNameLabel.font = UIFont.systemFont(ofSize: 14)
        filterNameLabel.textColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0).withAlphaComponent(0.26)
        filterNameLabel.textAlignment = .center
        filterNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return filterNameLabel
    }()
    
    var filterName: String? {
        didSet {
            filterNameLabel.text = filterName
            filterNameLabel.sizeToFit()
        }
    }
    
    // MARK: - UICollectionViewCell Override 설정
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        filterName = nil
    }
    
    private func initView() {
        self.backgroundColor = UIColor.white.withAlphaComponent(0.51)
        self.contentView.addSubview(filterNameLabel)
        NSLayoutConstraint.activate([
            filterNameLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            filterNameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            filterNameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 6),
            filterNameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -6)
        ])
    }
}
