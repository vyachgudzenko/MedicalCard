//
//  DiagnosesListController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 30.05.2022.
//

import UIKit
import CoreData

class DiagnosesListController: UITableViewController {

    var diagnoses:[NSManagedObject] = []
    var doAfterSelected:((Diagnosis) -> Void)?
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "DiagnosisCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "DiagnosisCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Diagnosis")
        do{
            diagnoses = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError{
            print("Could not save.\(error),\(error.userInfo)")
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diagnoses.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiagnosisCell", for: indexPath) as! DiagnosisCell
        let diagnosis = diagnoses[indexPath.row] as! Diagnosis
        print(diagnosis)
        cell.titleLabel.text = diagnosis.title
        cell.descriptionLabel.text = diagnosis.descriptionOfDiagnosis
        let dataFormater = DateFormatter()
        dataFormater.dateFormat = "yyyy-MM-dd"
        let formatedDate = dataFormater.string(from: diagnosis.date!)
        cell.dateLabel.text = "Дата: \(formatedDate)"
        cell.doctorFullNameLabel.text = "Врач: \(diagnosis.doctor!.getFullName())"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentDiagnosis = diagnoses[indexPath.row] as! Diagnosis
        doAfterSelected?(currentDiagnosis)
        navigationController?.popViewController(animated: true)
    }

}
