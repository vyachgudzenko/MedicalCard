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
    
    
    @IBOutlet weak var phoneImage: UIImageView!
    @IBOutlet weak var workImage: UIImageView!
    @IBOutlet weak var doctorImage: UIImageView!
    
    func setupCell(doctor:Doctor){
        doctorFullName.text = doctor.getFullName()
        phoneNumberLabel.text = doctor.phoneNumber
        clininNameLabel.text = doctor.clinic
        professionLabel.text = doctor.profession
        phoneImage.image = UIImage(systemName: "phone")?.withRenderingMode(.alwaysTemplate)
        workImage.image = UIImage(named: "hospitalImage")?.withRenderingMode(.alwaysTemplate)
        doctorImage.image = UIImage(named: "doctor")?.withRenderingMode(.alwaysTemplate)
        
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
