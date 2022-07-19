//
//  FilterButton.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 19.07.2022.
//

import UIKit

class FilterButton: UIButton {
    
    var flag:Bool = false {
        didSet{
            if flag{
                self.setTitleColor(.white, for: .normal)
                self.layer.backgroundColor = UIColor.systemPink.cgColor
            } else{
                self.setTitleColor(.systemPink, for: .normal)
                self.layer.backgroundColor = UIColor.white.cgColor
            }
            self.setNeedsDisplay()
        }
    }
    
    var selectedColor:UIColor = .systemPink
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15
        self.layer.borderColor = selectedColor.cgColor
        self.layer.borderWidth = 1
        if flag{
            self.setTitleColor(.white, for: .normal)
            self.layer.backgroundColor = selectedColor.cgColor
        } else{
            self.setTitleColor(selectedColor, for: .normal)
            self.layer.backgroundColor = UIColor.white.cgColor
        }
    }
    
}
