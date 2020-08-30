//
//  ImageManager.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/31.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit
import Photos

class ImageManager {
    static let shared = ImageManager()
    
    private let imageManager = PHImageManager()
    
    func requestImage(from asset: PHAsset, thumnailSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        self.imageManager.requestImage(for: asset, targetSize: thumnailSize, contentMode: .aspectFill, options: nil) { image, info in
            completion(image)
        }
    }
}
