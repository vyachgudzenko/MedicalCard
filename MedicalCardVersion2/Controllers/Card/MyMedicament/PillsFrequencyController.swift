//
//  PillsFrequencyController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 04.05.2022.
//
//MARK: контроллер для выбора частоты приема в день
import UIKit

class PillsFrequencyController: UITableViewController {
    
    
    
    var selectedFraquency:Frequency = .twiceADay
    
    var medicamentFraquencyInformation:[FraquencyCellDescription] = [
        (FraquencyCellDescription(fraquency: .onceADay, title: NSLocalizedString("fraquency_once", comment: ""))),
        (FraquencyCellDescription(fraquency: .twiceADay, title: NSLocalizedString("Два раза в день", comment: ""))),
        (FraquencyCellDescription(fraquency: .threeTimeADay, title: NSLocalizedString("Три раза в день", comment: "")))]
    
    var doAfterFrequencySelected:((Frequency) -> Void)?

    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("navigation_title_PillsFrequency", comment: "")
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return medicamentFraquencyInformation.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FraquencyCell", for: indexPath) as! FraquencyCell
        let typeDescription = medicamentFraquencyInformation[indexPath.row]
        cell.titleLabel.text = typeDescription.title
        if selectedFraquency == typeDescription.fraquency{
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    //MARK: Tableview Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFraquency = medicamentFraquencyInformation[indexPath.row].fraquency
        doAfterFrequencySelected?(selectedFraquency)
        navigationController?.popViewController(animated: true)
    }
}
