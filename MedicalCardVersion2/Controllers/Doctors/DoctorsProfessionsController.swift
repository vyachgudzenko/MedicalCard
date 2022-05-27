//
//  DoctorsProfessionsController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 09.05.2022.
//

import UIKit

class DoctorsProfessionsController: UITableViewController {

    var professionsDescription:[ProfesionsDescription] = [
        ProfesionsDescription(title: "Терапевт", description: "Занимается общим лечением и установкой диагнозов"),
        ProfesionsDescription(title: "Травматолог", description: "Занимается опорно-двигательным аппаратом.Также травмы, ушибы и растяжение"),
        ProfesionsDescription(title: "Невропатолог", description: "Занимается нервной системой,неврологическими расстройствами")]
    
    var selectedProfession:String = "Терапевт"
    
    var doAfterSelected:((String) -> Void)?
    
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
        return professionsDescription.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypicallCell", for: indexPath) as! TypicallCell
        let professionDescription = professionsDescription[indexPath.row]
        cell.titleLabel.text = professionDescription.title
        cell.descriptionLabel.text = professionDescription.description
        if selectedProfession == professionDescription.title{
            cell.accessoryType = .checkmark
        } else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    //MARK: TableView delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProfession = professionsDescription[indexPath.row].title
        doAfterSelected?(selectedProfession)
        navigationController?.popViewController(animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
