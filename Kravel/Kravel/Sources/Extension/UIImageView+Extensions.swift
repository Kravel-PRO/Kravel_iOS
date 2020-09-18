//
//  UIImageView+Extensions.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/07.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with urlString: String) {
        let url = URL(string: urlString)
        self.kf.setImage(
            with: url,
            placeholder: nil,
            options: [
                .transition(.fade(1))
            ], completionHandler:
                {
                    result in
                    switch result {
                    case .success: break
                    case .failure(let error):
                        print(error)
                        let defaultImage = UIImage()
                        self.image = defaultImage
                    }
                })
    }
}

