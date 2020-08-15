//
//  SexButton.swift
//  Kravel
//
//  Created by 윤동민 on 2020/06/08.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

enum Sex {
    case man
    case woman
    
    func getInform() -> (description: String, imageName: String) {
        switch self {
        case .man: return ("남자", ImageKey.icMale)
        case .woman: return ("여자", ImageKey.icFemale)
        }
    }
}

protocol XibButtonDelegate {
    func clickButton(of sex: Sex)
}

class SexButton: UIView {
    static let identifier = "SexButton"
    
    var delegate: XibButtonDelegate?
    
    var sex: Sex? {
        didSet {
            let sexInform = sex!.getInform()
            sexImage.image = UIImage(named: sexInform.imageName)
            sexLabel.text = sexInform.description
        }
    }

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var sexImage: UIImageView! {
        didSet {
            sexImage.tintColor = .veryLightPink
        }
    }
    
    @IBOutlet weak var sexLabel: UILabel! {
        didSet {
            sexLabel.textColor = .veryLightPink
            sexLabel.font = UIFont.systemFont(ofSize: 16)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        setCorner()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
        setCorner()
    }
    
    private func initView() {
        guard let view = Bundle.main.loadNibNamed(SexButton.identifier, owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    private func setCorner() {
        layer.cornerRadius = bounds.width / 17
        layer.borderColor = UIColor.veryLightPink.cgColor
        layer.borderWidth = 1
    }
    
    func setSelectedState(by selected: Bool) {
        sexImage.tintColor = selected ? .grapefruit : .veryLightPink
        sexLabel.textColor = selected ? .grapefruit : .veryLightPink
        layer.borderColor = selected ? UIColor.grapefruit.cgColor : UIColor.veryLightPink.cgColor
    }
    
    @IBAction func clickButton(_ sender: Any) {
        delegate?.clickButton(of: sex!)
    }
}
