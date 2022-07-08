//
//  MedicamentCell.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 29.06.2022.
//

import UIKit

class MedicamentCell: UITableViewCell {
    
    private var titlesType:[String:String] = [
        "pill":"Таблетки",
        "injection":"Уколы",
        "syrup":"Cироп"]
    
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
    
    func setupCell(medicament:Medicament){
        titleLabel.text = medicament.title
        typeLabel.text = titlesType[medicament.type!]!
        frequencyLabel.text = titlesFrequency[medicament.frequencyEnum]!
        doctorLabel.text = medicament.doctor?.getFullName() ?? "Не указан"
        if medicament.isTaken{
            statusLabel.text = "Принимается"
        } else{
            statusLabel.text = "Не принимается"
        }
        typeImageView.image = getCurrentImageForPillsList(medicament: medicament).withRenderingMode(.alwaysTemplate)
        doctorImageView.image = UIImage(named: "doctor")?.withRenderingMode(.alwaysTemplate)
    }
    
    func getCurrentImageForPillsList(medicament:Medicament) -> UIImage{
        switch medicament.type{
        case "injection":
            return UIImage(named: "injection.png")!
        case "pill":
            return UIImage(named: "pill (1).png")!
        case "syrup":
            return UIImage(named: "cough-syrup.png")!
        default:
            return UIImage(named: "pill (1).png")!
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
