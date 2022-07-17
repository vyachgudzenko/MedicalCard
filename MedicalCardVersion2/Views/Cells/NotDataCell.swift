//
//  NotDataCell.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 04.07.2022.
//

import UIKit

class NotDataCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionLabel.text = "Нет данных за этот период"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
