//
//  AddButton.swift
//  DoneDoneMemo
//
//  Created by Yuki Sumida on 2018/03/12.
//  Copyright © 2018年 Yuki Sumida. All rights reserved.
//

import UIKit

class AddButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.9 : 1
        }
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        self.layer.cornerRadius = 28.0
        let image = UIImage(named: "ic_add")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.setImage(image, for: .normal)
        self.tintColor = UIColor.white
    }
}
