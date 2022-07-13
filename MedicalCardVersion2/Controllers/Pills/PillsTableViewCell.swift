//
//  PillsTableViewCell.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 04.05.2022.
//
//MARK: класс для динамического прототипа 
import UIKit

class PillsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var dosageLabel: UILabel!
    
    func setupCell(medicament:Medicament){
        titleLabel.text = medicament.title
        dosageLabel.text = medicament.dosage
        pic.image = getCurrentImageForPillsList(medicament: medicament)
    }
    
    func getCurrentImageForPillsList(medicament:Medicament) -> UIImage{
        switch medicament.medicamentTypeEnum{
        case .injection:
            return UIImage(named: "inject")!
        case .pill:
            return UIImage(named: "pill (1) — копия")!
        case .syrup:
            return UIImage(named: "syrup")!
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
