//
//  MyDiseaseController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 27.05.2022.
//

import UIKit
import CoreData

class MyDiagnosesController: UITableViewController {
    var diagnoses:[NSManagedObject] = []
    
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
    
    //MARK: Other function
    private func save(title:String,description:String,date:Date,doctor:Doctor){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Diagnosis", in: managedContext)!
        let newDiagnosis = NSManagedObject(entity: entity, insertInto: managedContext)
        newDiagnosis.setValue(title, forKey: "title")
        newDiagnosis.setValue(description, forKey: "descriptionOfDiagnosis")
        newDiagnosis.setValue(date, forKey: "date")
        newDiagnosis.setValue(doctor.getFullName(), forKey: "doctorFullName")
        newDiagnosis.setValue(doctor, forKey: "doctor")
        do{
            try managedContext.save()
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
        cell.titleLabel.text = diagnosis.title
        cell.descriptionLabel.text = diagnosis.descriptionOfDiagnosis
        let dataFormater = DateFormatter()
        dataFormater.dateFormat = "yyyy-MM-dd"
        let formatedDate = dataFormater.string(from: diagnosis.date!)
        cell.dateLabel.text = "Дата: \(formatedDate)"
        cell.doctorFullNameLabel.text = "Врач: \(diagnosis.doctor!.getFullName())"
        return cell
    }

    //MARK: TableView delegate
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionSwipe = UIContextualAction(style: .normal, title: "Удалить") { [self] _, _, _ in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(diagnoses[indexPath.row])
            do{
                try managedContext.save()
                diagnoses.remove(at: indexPath.row)
                tableView.reloadData()
            } catch let error as NSError{
                print("Could not save.\(error),\(error.userInfo)")
            }
        }
        actionSwipe.backgroundColor = .systemGray
        return UISwipeActionsConfiguration(actions: [actionSwipe])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentDiagnosis = diagnoses[indexPath.row] as! Diagnosis
        let editScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewDiagnosisController") as! NewDiagnosisController
        navigationItem.title = currentDiagnosis.title
        editScreen.titleFirst = currentDiagnosis.title!
        editScreen.descriptionFirst = currentDiagnosis.descriptionOfDiagnosis!
        editScreen.dateFirst = currentDiagnosis.date!
        editScreen.doctor = currentDiagnosis.doctor
        editScreen.doctorLabelText = (currentDiagnosis.doctor?.getFullName())!
        editScreen.doAfterCreate = {
            titleOfDiagnosis,descriptionOfDiagnosis,date,doctor in
            currentDiagnosis.title = titleOfDiagnosis
            currentDiagnosis.descriptionOfDiagnosis = descriptionOfDiagnosis
            currentDiagnosis.date = date
            currentDiagnosis.doctor = doctor
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            do{
                try managedContext.save()
            } catch let error as NSError{
                print("Could not save.\(error),\(error.userInfo)")
            }
            tableView.reloadData()
        }
        navigationController?.pushViewController(editScreen, animated: true)
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewDiagnosisScreen"{
            let destination = segue.destination as! NewDiagnosisController
            destination.doAfterCreate = {
                [self] titleOfDiagnosis,descriptionOfDiagnosis,date,doctor in
                save(title: titleOfDiagnosis, description: descriptionOfDiagnosis, date: date, doctor: doctor)
                
            }
        }
    }

}
