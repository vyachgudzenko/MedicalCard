//
//  AnalysisCell.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 01.06.2022.
//

import UIKit

class AnalysisCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var doctorFullName: UILabel!
    
    @IBOutlet weak var fileNameLabel: UILabel!
    
    @IBOutlet weak var doctorImageView: UIImageView!
    
    func setupCell(analysis:Analysis){
        titleLabel.text = analysis.title
        resultLabel.text = analysis.result
        let dataFormater = DateFormatter()
        dataFormater.dateFormat = "yyyy-MM-dd"
        let formatedDate = dataFormater.string(from: analysis.date!)
        dateLabel.text = formatedDate
        doctorFullName.text = analysis.doctor!.getFullName()
        fileNameLabel.text = NSLocalizedString("notFile", comment: "")
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
