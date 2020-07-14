//
//  ContentDetailVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/15.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class ContentDetailVC: UIViewController {
    static let identifier = "ContentDetailVC"

    @IBOutlet weak var thumbnail_imageView: UIImageView!
    
    @IBOutlet weak var introduceLabel: UILabel! {
        willSet {
            guard let informStr = self.informStr, let name = self.name else { return }
            newValue.attributedText = createAttributeString(of: informStr, highlightPart: name)
            newValue.sizeToFit()
        }
    }
    
    var informStr: String?
    
    var category: KCategory? {
        didSet {
            guard let category = category else { return }
            guard let name = self.name else { return }
            switch category {
            case .talent: informStr = "\(name)가\n다녀간 곳은 어딜까요?"
            case .move: informStr = "\(name)\n촬영지가 어딜까요?"
            }
        }
    }
    
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
    
    private func setNav() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .white
        self.setTransparentNav()
    }
    
    private func createAttributeString(of str: String, highlightPart: String) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: str, attributes: [.foregroundColor: UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1.0), .font: UIFont.systemFont(ofSize: 24)])
        attributeString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 24), range: (str as NSString).range(of: highlightPart))
        return attributeString
    }
}
