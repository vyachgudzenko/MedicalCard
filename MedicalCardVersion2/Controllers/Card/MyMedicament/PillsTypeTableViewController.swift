//
//  PillsTypeTableViewController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 04.05.2022.
//
//MARK: контроллер для выбора типа медикамента
import UIKit

class PillsTypeTableViewController: UITableViewController {
    
    struct TypeCellDescription{
        var type:TypeOfMedicament
        var title:String
        var description:String
    }
    
    private var medicamentTypeInformation: [TypeCellDescription] = [
        (TypeCellDescription(type: .injection,title: NSLocalizedString("type_title_injection", comment: ""), description: NSLocalizedString("type_description_injection", comment: ""))),
        (TypeCellDescription(type: .pill,title: NSLocalizedString("type_title_pill", comment: ""), description: NSLocalizedString("type_description_pill", comment: ""))),
        (TypeCellDescription(type: .syrup, title: NSLocalizedString("type_title_syrup", comment: ""), description: NSLocalizedString("type_description", comment: "")))]
    
    var selectedType:TypeOfMedicament = .pill
    
    var doAfterTypeSelected:((TypeOfMedicament) -> Void)?

    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("navigation_title_PillsType", comment: "")
        let cellNib = UINib(nibName: "TypicallCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "TypicallCell")
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return medicamentTypeInformation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypicallCell", for: indexPath) as! TypicallCell
        let typeDescription = medicamentTypeInformation[indexPath.row]
        cell.titleLabel.text = typeDescription.title
        cell.descriptionLabel.text = typeDescription.description
        if selectedType == typeDescription.type{
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
       return cell
    }
    
    //MARK: Tableview Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedType = medicamentTypeInformation[indexPath.row].type
        doAfterTypeSelected?(selectedType)
        navigationController?.popViewController(animated: true)
    }
}
