//
//  DiagnosisCell.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 26.06.2022.
//

import UIKit

class DiagnosisCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var doctorFullNameLabel: UILabel!
    @IBOutlet weak var dateImageView: UIImageView!
    @IBOutlet weak var doctorImageView: UIImageView!
    
    func setupCell(diagnosis:Diagnosis){
        titleLabel.text = diagnosis.title
        descriptionLabel.text = diagnosis.descriptionOfDiagnosis
        let dataFormater = DateFormatter()
        dataFormater.dateFormat = "yyyy-MM-dd"
        let formatedDate = dataFormater.string(from: diagnosis.date!)
        dateLabel.text = formatedDate
        doctorFullNameLabel.text = diagnosis.doctor!.getFullName()
        dateImageView.image = UIImage(systemName: "clock")
        doctorImageView.image = UIImage(named: "doctor")?.withRenderingMode(.alwaysTemplate)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
