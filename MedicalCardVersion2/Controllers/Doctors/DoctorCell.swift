//
//  DoctorCell.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 08.05.2022.
//

import UIKit
//класс для doctorCell
class DoctorCell: UITableViewCell {

    @IBOutlet weak var doctorFullNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var clininNameLabel: UILabel!
    @IBOutlet weak var professionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
