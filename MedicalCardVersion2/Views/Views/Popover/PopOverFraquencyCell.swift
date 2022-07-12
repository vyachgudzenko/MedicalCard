//
//  PopOverFraquencyCell.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 13.07.2022.
//

import UIKit

class PopOverFraquencyCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    func setupCell(fraquency:FraquencyCellDescription){
        titleLabel.text = fraquency.title
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
