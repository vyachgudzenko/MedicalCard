//
//  VisitCell.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 27.06.2022.
//

import UIKit

class VisitCell: UITableViewCell {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var complaintLAbel: UILabel!
    @IBOutlet weak var doctorLabel: UILabel!
    @IBOutlet weak var doctorImageView: UIImageView!
    
    func setupCell(visit:VisitToDoctor){
        let dataFormater = DateFormatter()
        dataFormater.dateFormat = "yyyy-MM-dd"
        let formatedDate = dataFormater.string(from: visit.date!)
        dateLabel.text = formatedDate
        complaintLAbel.text = visit.complaint
        doctorLabel.text = visit.doctorFullName
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
