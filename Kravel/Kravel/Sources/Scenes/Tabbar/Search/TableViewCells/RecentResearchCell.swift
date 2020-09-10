//
//  RecentResearchCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/22.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class RecentResearchCell: UITableViewCell {
    static let identifier = "RecentResearchCell"
    
    var indexPath: IndexPath?
    var cellButtonDelegate: CellButtonDelegate?
    
    // MARK: - 돋보기 이미지 설정
    var searchImageView: UIImageView = {
        let searchImageView = UIImageView()
        searchImageView.contentMode = .scaleAspectFill
        searchImageView.image = UIImage(named: ImageKey.icSearch)
        searchImageView.translatesAutoresizingMaskIntoConstraints = false
        return searchImageView
    }()
    
    // MARK: - 최근 검색어 표시 Label
    var researchLabel: UILabel = {
        let researchLabel = UILabel()
        researchLabel.font = UIFont.systemFont(ofSize: 16)
        researchLabel.textColor = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1.0)
        researchLabel.translatesAutoresizingMaskIntoConstraints = false
        return researchLabel
    }()
    
    var researchText: String? {
        didSet {
            researchLabel.text = researchText
            researchLabel.sizeToFit()
        }
    }
    
    // MARK: - 삭제 표시
    var deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.setImage(UIImage(named: ImageKey.icbtnDelete), for: .normal)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        return deleteButton
    }()
    
    // Delete 버튼 클릭했을 때, Delegate에 이벤트 전달
    @objc func deleteRecentResearch(_ sender: Any) {
        guard let indexPath = self.indexPath else { return }
        cellButtonDelegate?.clickHeart(at: indexPath)
    }
    
    private func addDeleteButtonAction() {
        deleteButton.addTarget(self, action: #selector(deleteRecentResearch(_:)), for: .touchUpInside)
    }
    
    // MARK: - Constraint 초기 설정
    private func addSubViews() {
        self.addSubview(searchImageView)
        self.addSubview(researchLabel)
        self.addSubview(deleteButton)
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            searchImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            searchImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.23),
            searchImageView.widthAnchor.constraint(equalTo: searchImageView.heightAnchor),
            searchImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18),
            researchLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            researchLabel.leadingAnchor.constraint(equalTo: searchImageView.trailingAnchor, constant: 26),
            deleteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            deleteButton.heightAnchor.constraint(equalTo: searchImageView.heightAnchor, multiplier: 1.3),
            deleteButton.widthAnchor.constraint(equalTo: deleteButton.heightAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18),
            researchLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: 16)
        ])
    }
    
    
    // MARK: - UITableViewCell Override 설정
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        setConstraint()
        addDeleteButtonAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubViews()
        setConstraint()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        indexPath = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
