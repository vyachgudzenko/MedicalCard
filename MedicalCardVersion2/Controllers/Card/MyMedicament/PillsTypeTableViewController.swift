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
        (TypeCellDescription(type: .injection,title: "Уколы", description: "Внутривенные,подкожные,внутримышечные иньекции, которые Вы делаете самостоятельно или же это делает мед. персонал")),
        (TypeCellDescription(type: .pill,title: "Таблетки", description: "Препараты в форме таблеток. Возможен прием как перед, так и после еды")),
        (TypeCellDescription(type: .syrup, title: "Сироп/Суспензия", description: "Препараты в виде сиропа или суспензии. Возможен прием как перед, так и после еды."))]
    
    var selectedType:TypeOfMedicament = .pill
    
    var doAfterTypeSelected:((TypeOfMedicament) -> Void)?

    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
