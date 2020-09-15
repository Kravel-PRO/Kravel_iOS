//
//  MyScrapCell.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/24.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class MyScrapCell: UICollectionViewCell {
    static let identifier = "MyScrapCell"
    
    // MARK: - 스크랩 이미지 설정
    @IBOutlet weak var scrapImageView: UIImageView! {
        didSet {
            scrapImageView.layer.cornerRadius = scrapImageView.frame.width / 20
            scrapImageView.clipsToBounds = true
        }
    }
    
    var scrapImage: UIImage? {
        didSet {
            scrapImageView.image = scrapImage
        }
    }
    
    // MARK: - 스크랩 라벨 설정
    @IBOutlet weak var scrapLabel: UILabel!
    
    var scrapText: String? {
        didSet {
            scrapLabel.text = scrapText
            scrapLabel.sizeToFit()
        }
    }
    

    // MARK: - UICollectionViewCell Override 설정
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
