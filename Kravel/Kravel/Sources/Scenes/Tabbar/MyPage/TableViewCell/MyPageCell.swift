//
//  MyPageCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/22.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class MyPageCell: UITableViewCell {
    static let identifier = ""
    
    // MARK: - 메뉴 이미지 설정
    @IBOutlet weak var menuImageView: UIImageView!
    
    var menuImage: UIImage? {
        didSet {
            menuImageView.image = menuImage
        }
    }
    
    // MARK: - 메뉴 라벨 설정
    @IBOutlet weak var menuLabel: UILabel!
    
    var menuName: String? {
        didSet {
            menuLabel.text = menuName
            menuLabel.sizeToFit()
        }
    }
    
    // MARK: - UITableViewCell Override 부분
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
