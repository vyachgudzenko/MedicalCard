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
        self.layer.masksToBounds = false
        self.layer.cornerRadius = frame.height / 2
        self.backgroundColor = .systemPink
        self.tintColor = .white
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        self.setImage(image, for: .normal)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
    }

}
