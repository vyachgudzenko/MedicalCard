//
//  DoctorsListController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 27.05.2022.
//

import UIKit
import CoreData

class DoctorsListController: UITableViewController {
    
    var doctors:[NSManagedObject] = []
    var doAfterSelected:((Doctor) -> Void)?
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "DoctorPrototypeCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "DoctorPrototypeCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Doctor")
        do{
            doctors = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError{
            print("Could not save.\(error),\(error.userInfo)")
        }
    }
    
    //MARK: Other function
    private func save(firstName:String,lastName:String,clinic:String,phoneNumber:String,profession:String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Doctor", in: managedContext)!
        let doctor = NSManagedObject(entity: entity, insertInto: managedContext)
        doctor.setValue(firstName, forKey: "firstName")
        doctor.setValue(lastName, forKey: "lastName")
        doctor.setValue(clinic, forKey: "clinic")
        doctor.setValue(phoneNumber, forKey: "phoneNumber")
        doctor.setValue(profession, forKey: "profession")
        do{
            try managedContext.save()
            tableView.reloadData()
        } catch let error as NSError{
            print("Could not save.\(error),\(error.userInfo)")
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return doctors.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorPrototypeCell", for: indexPath) as! DoctorPrototypeCell
        let currentDoctor = doctors[indexPath.row] as! Doctor
        cell.setupCell(doctor: currentDoctor)
        return cell
    }
    
    //MARK: Tableview Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDoctor = doctors[indexPath.row] as! Doctor
        doAfterSelected?(selectedDoctor)
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromDiagnosisToNewDoctor"{
            let destination = segue.destination as! NewDoctorController
            destination.doAfterCreate = {
                [self] firstName,lastName,clinic,phoneNumber,profession in
                save(firstName: firstName, lastName: lastName, clinic: clinic, phoneNumber: phoneNumber, profession: profession)
            }
        }
    }

}
