//
//  RedButton.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 24.06.2022.
//

import UIKit

class RedButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = frame.height / 2
        self.backgroundColor = .systemPink
        self.tintColor = .white
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        self.setImage(image, for: .normal)
    }

}
