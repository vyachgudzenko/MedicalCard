//
//  MedicamentCell.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 29.06.2022.
//

import UIKit

class MedicamentCell: UITableViewCell {
    
    private var titlesType:[TypeOfMedicament:String] = [
        .pill:NSLocalizedString("titleType_pill", comment: ""),
        .injection:NSLocalizedString("titleType_injection", comment: ""),
        .syrup:NSLocalizedString("titleType_syrup", comment: "")]
    
    private var titlesFrequency:[Frequency:String] = [
        .onceADay:"Один раз в день",
        .twiceADay:"Дважды в день",
        .threeTimeADay:"Трижды в день"]
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var doctorLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var doctorImageView: UIImageView!
    
    @IBOutlet weak var statusImageView: UIImageView!
    
    func setupCell(medicament:Medicament){
        titleLabel.text = medicament.title
        typeLabel.text = titlesType[medicament.medicamentTypeEnum]!
        frequencyLabel.text = titlesFrequency[medicament.frequencyEnum]!
        doctorLabel.text = medicament.doctor?.getFullName() ?? NSLocalizedString("doctor_NotSelect", comment: "")
        if medicament.isTaken{
            statusLabel.text = NSLocalizedString("isTaken_MedicamentCell", comment: "")
        } else{
            statusLabel.text = NSLocalizedString("notTaken_newMedicament", comment: "")
        }
        typeImageView.image = getCurrentImageForPillsList(medicament: medicament)
        statusImageView.image = getStatusImage(medicament: medicament)
    }
    
    func getCurrentImageForPillsList(medicament:Medicament) -> UIImage{
        switch medicament.type{
        case "injection":
            return UIImage(named: "inject")!
        case "pill":
            return UIImage(named: "pill (1) — копия")!
        case "syrup":
            return UIImage(named: "syrup")!
        default:
            return UIImage(named: "pill (1) — копия")!
        }
    }
    
    func getStatusImage(medicament:Medicament) -> UIImage{
        if medicament.isTaken{
            return UIImage(named: "accept")!
        } else {
            return UIImage(named: "close")!
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
