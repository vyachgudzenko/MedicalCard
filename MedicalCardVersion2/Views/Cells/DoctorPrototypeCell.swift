//
//  DoctorPrototypeCell.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 27.05.2022.
//

import UIKit

class DoctorPrototypeCell: UITableViewCell {
    
    let professionDescription = DoctorsProfessionsController().professionsDescription

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
        professionLabel.text = getStringDescribeOfProfession(profession: doctor.professionEnum)
    }
    
    private func getStringDescribeOfProfession(profession:Profession) -> String {
        let findProfession = professionDescription.first { $0.profession == profession
        }
        return findProfession!.title
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
