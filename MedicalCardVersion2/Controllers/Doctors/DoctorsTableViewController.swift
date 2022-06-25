//
//  DoctorsTableViewController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 04.05.2022.
//

import UIKit
import ContactsUI
import CoreData

class DoctorsTableViewController: UIViewController, CNContactViewControllerDelegate{
    
    var doctors:[NSManagedObject] = []
    var cellSpacing:CGFloat = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBurButton: UIBarButtonItem!
    
    @IBAction func addBarButtonTapped(_ sender: Any) {
        createNewDoctorController()
    }
    var floatButton:RedButton = {
        let button = RedButton()
        return button
    }()
    
    var medicalAlert:MedicalAlert!

    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let cellNib = UINib(nibName: "DoctorPrototypeCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "DoctorPrototypeCell")
        view.addSubview(floatButton)
        floatButton.addTarget(self, action: #selector(addBarButtonTapped), for: .touchUpInside)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatButton.frame = CGRect(x: view.frame.width - 90, y: view.frame.height - view.frame.height * 0.2, width: 70, height: 70)
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
    
    private func canBeDeleteDoctor(doctor:Doctor) -> Bool{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Diagnosis>
        fetchRequest = Diagnosis.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "doctorFullName LIKE %@", doctor.getFullName())
        do{
            let object = try managedContext.fetch(fetchRequest)
            if object.isEmpty{
                return true
            }
        } catch{
            fatalError()
        }
        return false
    }
    
    private func createNewDoctorController(){
        let newDoctorScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewDoctorController") as! NewDoctorController
        newDoctorScreen.doAfterCreate = {
            [self] firstName,lastName,clinic,phoneNumber,profession in
            save(firstName: firstName, lastName: lastName, clinic: clinic, phoneNumber: phoneNumber, profession: profession)
        }
        self.navigationController?.pushViewController(newDoctorScreen, animated: true)
        
        
    }
    
    @objc
    func addButtonTapped(){
        createNewDoctorController()
    }
        
    //MARK: Navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewDoctorScreen"{
            let destination = segue.destination as! NewDoctorController
            destination.doAfterCreate = {
                [self] firstName,lastName,clinic,phoneNumber,profession in
                save(firstName: firstName, lastName: lastName, clinic: clinic, phoneNumber: phoneNumber, profession: profession)
            }
        }
    }*/
    
    //MARK: AlertControllers
    func showAlertCanBeDeletedDoctor(){
        medicalAlert = MedicalAlert()
        medicalAlert.showAlert(title: "Упс...", message: "Невозможно удалить эту карточку данных - есть связаные данные", viewController: self)
    }
}

extension DoctorsTableViewController:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctors.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorPrototypeCell", for: indexPath) as! DoctorPrototypeCell
        let currentDoctor = doctors[indexPath.row] as! Doctor
        cell.setupCell(doctor: currentDoctor)
        return cell
    }

}

extension DoctorsTableViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionSwipe = UIContextualAction(style: .normal, title: "Удалить") { [self] _, _, _ in
            if canBeDeleteDoctor(doctor: doctors[indexPath.row] as! Doctor){
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
            } else {
                showAlertCanBeDeletedDoctor()
            }
        }
        actionSwipe.backgroundColor = .systemGray
        return UISwipeActionsConfiguration(actions: [actionSwipe])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
