//
//  DoctorPrototypeCell.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 27.05.2022.
//

import UIKit

class DoctorPrototypeCell: UITableViewCell {

    @IBOutlet weak var doctorFullName: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var clininNameLabel: UILabel!
    @IBOutlet weak var professionLabel: UILabel!
    
    func setupCell(doctor:Doctor){
        doctorFullName.text = doctor.getFullName()
        phoneNumberLabel.text = doctor.phoneNumber
        clininNameLabel.text = doctor.clinic
        professionLabel.text = doctor.profession
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
