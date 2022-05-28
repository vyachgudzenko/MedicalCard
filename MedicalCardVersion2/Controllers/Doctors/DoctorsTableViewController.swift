//
//  DoctorsTableViewController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 04.05.2022.
//

import UIKit
import ContactsUI
import CoreData

class DoctorsTableViewController: UITableViewController, CNContactViewControllerDelegate {
    
    var doctors:[NSManagedObject] = []

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
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewDoctorScreen"{
            let destination = segue.destination as! NewDoctorController
            destination.doAfterCreate = {
                [self] firstName,lastName,clinic,phoneNumber,profession in
                save(firstName: firstName, lastName: lastName, clinic: clinic, phoneNumber: phoneNumber, profession: profession)
            }
        }
    }
    
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
        cell.doctorFullName.text = currentDoctor.getFullName()
        cell.professionLabel.text = currentDoctor.profession
        cell.clininNameLabel.text = currentDoctor.clinic
        cell.phoneNumberLabel.text = currentDoctor.phoneNumber
        return cell
    }
    
    //MARK: TableView delegate
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionSwipe = UIContextualAction(style: .normal, title: "Добавить в контакты") { [self]  _, _, _ in
            let doctor = doctors[indexPath.row]
            let newContact = CNMutableContact()
            newContact.givenName = doctor.value(forKey: "firstName") as! String
            newContact.familyName = doctor.value(forKey: "lastName") as! String
            newContact.jobTitle = doctor.value(forKey: "clinic") as! String
            newContact.phoneNumbers.append(CNLabeledValue(label: "Доктор", value: CNPhoneNumber(stringValue: doctor.value(forKey: "phoneNumber") as! String)))
            let unkvc = CNContactViewController(forUnknownContact: newContact)
            unkvc.contactStore = CNContactStore()
            unkvc.delegate = self
            unkvc.allowsActions = false
            self.navigationController?.pushViewController(unkvc, animated: true)
        }
        actionSwipe.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [actionSwipe])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionSwipe = UIContextualAction(style: .normal, title: "Удалить") { [self] _, _, _ in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            
            managedContext.delete(doctors[indexPath.row])
            do{
                try managedContext.save()
                doctors.remove(at: indexPath.row)
                tableView.reloadData()
            } catch let error as NSError{
                print("Could not save.\(error),\(error.userInfo)")
            }
        }
        actionSwipe.backgroundColor = .systemGray
        return UISwipeActionsConfiguration(actions: [actionSwipe])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentDoctor = doctors[indexPath.row] as! Doctor
        let editScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewDoctorController") as! NewDoctorController
        editScreen.navigationItem.title = currentDoctor.getFullName()
        editScreen.firstName = currentDoctor.firstName!
        editScreen.lastName = currentDoctor.lastName!
        editScreen.clinic = currentDoctor.clinic!
        editScreen.phoneNumber = currentDoctor.phoneNumber!
        editScreen.profession = currentDoctor.profession!
        editScreen.doAfterCreate = {
             firstName,lastName,clinic,numberPhone,profession in
            currentDoctor.firstName = firstName
            currentDoctor.lastName = lastName
            currentDoctor.clinic = clinic
            currentDoctor.phoneNumber = numberPhone
            currentDoctor.profession = profession
            print(currentDoctor.isDeleted)
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            do{
                try managedContext.save()
            } catch let error as NSError{
                print("Could not save.\(error),\(error.userInfo)")
            }
            tableView.reloadData()
        }
        self.navigationController?.pushViewController(editScreen, animated: true)
    }
}
