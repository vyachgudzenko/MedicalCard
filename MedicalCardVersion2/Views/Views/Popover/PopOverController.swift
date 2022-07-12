//
//  PupoverController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 12.07.2022.
//

import UIKit

protocol PopOverDelegate{
    func didCellSelected(_ popOver:PopOverController)
}

enum PopOverCellType{
    case medicamentType
    case medicamentFraquency
}

class PopOverController: UIViewController {
    
    private var medicamentTypeInformation: [TypeCellDescription] = [
        (TypeCellDescription(type: .injection,title: NSLocalizedString("type_title_injection", comment: ""), description: NSLocalizedString("type_description_injection", comment: ""))),
        (TypeCellDescription(type: .pill,title: NSLocalizedString("type_title_pill", comment: ""), description: NSLocalizedString("type_description_pill", comment: ""))),
        (TypeCellDescription(type: .syrup, title: NSLocalizedString("type_title_syrup", comment: ""), description: NSLocalizedString("type_description", comment: "")))]
    
    private var medicamentFraquencyInformation:[FraquencyCellDescription] = [
        (FraquencyCellDescription(fraquency: .onceADay, title: NSLocalizedString("fraquency_once", comment: ""))),
        (FraquencyCellDescription(fraquency: .twiceADay, title: NSLocalizedString("Два раза в день", comment: ""))),
        (FraquencyCellDescription(fraquency: .threeTimeADay, title: NSLocalizedString("Три раза в день", comment: "")))]
    
    var selectedType:TypeOfMedicament?
    var selectedFraquency:Frequency?
    var delegate:PopOverDelegate?
    var cellType:PopOverCellType = .medicamentType
    
    @IBOutlet weak var popoverView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    init(){
        super.init(nibName: "PupoverController", bundle: Bundle(for: PopOverController.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .coverVertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showPopOver(type:TypeOfMedicament){
        self.selectedType = type
        if #available(iOS 13, *) {
        UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
        } else {
        UIApplication.shared.keyWindow?.rootViewController!.present(self, animated: true, completion: nil)
        }
    }
    
    func showPopOver(fraquency:Frequency){
        self.selectedFraquency = fraquency
        if #available(iOS 13, *) {
        UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
        } else {
        UIApplication.shared.keyWindow?.rootViewController!.present(self, animated: true, completion: nil)
        }
    }
    
    func setupPopOver(cellType:PopOverCellType){
        self.cellType = cellType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        switch cellType{
        case .medicamentType:
            titleLabel.text = "Тип лекарств"
            let cellNib = UINib(nibName: "PopoverMedicamentCell", bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: "PopoverMedicamentCell")
        case .medicamentFraquency:
            titleLabel.text = "Частота приема"
            let cellNib = UINib(nibName: "PopOverFraquencyCell", bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: "PopOverFraquencyCell")
        }
        
        popoverView.layer.masksToBounds = true
        popoverView.layer.cornerRadius = 15
    }
}

extension PopOverController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicamentTypeInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cellType{
        case .medicamentType:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PopoverMedicamentCell") as! PopoverMedicamentCell
            let medicamentType = medicamentTypeInformation[indexPath.row]
            if medicamentType.type == selectedType {
                cell.accessoryType = .checkmark
            }
            cell.setupCell(medicamentType: medicamentType)
            return cell
        case .medicamentFraquency:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PopOverFraquencyCell") as! PopOverFraquencyCell
            let fraquency = medicamentFraquencyInformation[indexPath.row]
            if fraquency.fraquency == selectedFraquency{
                cell.accessoryType = .checkmark
            }
            cell.setupCell(fraquency: fraquency)
            return cell
        }
        
    }
}

extension PopOverController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch cellType{
        case .medicamentType:
            selectedType = medicamentTypeInformation[indexPath.row].type
        case .medicamentFraquency:
            selectedFraquency = medicamentFraquencyInformation[indexPath.row].fraquency
        }
        self.dismiss(animated: true)
        delegate?.didCellSelected(self)
    }
}
