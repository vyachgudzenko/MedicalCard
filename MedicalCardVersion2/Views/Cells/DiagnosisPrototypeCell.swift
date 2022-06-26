//
//  DiagnosisPrototypeCell.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 26.06.2022.
//

import UIKit

class DiagnosisPrototypeCell: UITableViewCell {
    
    
    func setupCell(diagnosis:Diagnosis){
        self.translatesAutoresizingMaskIntoConstraints = false
        let titleLabel = UILabel()
        titleLabel.text = diagnosis.title
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        titleLabel.textAlignment = .center
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
