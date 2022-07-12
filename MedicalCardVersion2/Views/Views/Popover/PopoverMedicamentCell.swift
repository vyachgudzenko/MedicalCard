//
//  PopoverMedicamentCell.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 12.07.2022.
//

import UIKit

class PopoverMedicamentCell: UITableViewCell {

    @IBOutlet weak var medicamentImageView: UIImageView!
    @IBOutlet weak var medicamentLabel: UILabel!
    
    func setupCell(medicamentType:TypeCellDescription){
        medicamentLabel.text = medicamentType.title
        medicamentImageView.image = getCurrentImageForPillsList(type: medicamentType.type)
    }
    
    private func getCurrentImageForPillsList(type:TypeOfMedicament) -> UIImage{
        switch type{
        case .injection:
            return UIImage(named: "injection.png")!
        case .pill:
            return UIImage(named: "pill (1).png")!
        case .syrup:
            return UIImage(named: "cough-syrup.png")!
        }
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
