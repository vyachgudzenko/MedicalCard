//
//  DoctorsProfessionsController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 09.05.2022.
//

import UIKit

class DoctorsProfessionsController: UITableViewController {

    var professionsDescription:[ProfesionsDescription] = [
        ProfesionsDescription(profession: .therapist, title: "Терапевт", description: "Занимается общим лечением и установкой диагнозов"),
        ProfesionsDescription(profession: .traumatologist, title: "Травматолог", description: "Занимается опорно-двигательным аппаратом.Также травмы, ушибы и растяжение"),
        ProfesionsDescription(profession: .neuropathologist, title: "Невропатолог", description: "Занимается нервной системой,неврологическими расстройствами")]
    
    var selectedProfession:Profession = .therapist
    
    var doAfterSelected:((Profession) -> Void)?
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("navigation_title_DoctorProfession", comment: "")
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
        return professionsDescription.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypicallCell", for: indexPath) as! TypicallCell
        let professionDescription = professionsDescription[indexPath.row]
        cell.titleLabel.text = professionDescription.title
        cell.descriptionLabel.text = professionDescription.description
        if selectedProfession == professionDescription.profession{
            cell.accessoryType = .checkmark
        } else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    //MARK: TableView delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProfession = professionsDescription[indexPath.row].profession
        doAfterSelected?(selectedProfession)
        navigationController?.popViewController(animated: true)
    }
}
