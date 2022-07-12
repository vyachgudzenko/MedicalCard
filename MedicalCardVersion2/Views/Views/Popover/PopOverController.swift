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

class PopOverController: UIViewController {
    
    
    private var medicamentTypeInformation: [TypeCellDescription] = [
        (TypeCellDescription(type: .injection,title: NSLocalizedString("type_title_injection", comment: ""), description: NSLocalizedString("type_description_injection", comment: ""))),
        (TypeCellDescription(type: .pill,title: NSLocalizedString("type_title_pill", comment: ""), description: NSLocalizedString("type_description_pill", comment: ""))),
        (TypeCellDescription(type: .syrup, title: NSLocalizedString("type_title_syrup", comment: ""), description: NSLocalizedString("type_description", comment: "")))]
    
    var selectedType:TypeOfMedicament = .pill
    
    var delegate:PopOverDelegate?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let cellNib = UINib(nibName: "PopoverMedicamentCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "PopoverMedicamentCell")
        popoverView.layer.masksToBounds = true
        popoverView.layer.cornerRadius = 15
    }
}

extension PopOverController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicamentTypeInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopoverMedicamentCell") as! PopoverMedicamentCell
        let medicamentType = medicamentTypeInformation[indexPath.row]
        if medicamentType.type == selectedType{
            cell.accessoryType = .checkmark
        }
        cell.setupCell(medicamentType: medicamentType)
        return cell
    }
}

extension PopOverController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedType = medicamentTypeInformation[indexPath.row].type
        self.dismiss(animated: true)
        delegate?.didCellSelected(self)
    }
}
