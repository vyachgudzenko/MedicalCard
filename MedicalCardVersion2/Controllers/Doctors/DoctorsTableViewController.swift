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
    
    
    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
        let filter = FilterController()
        filter.showFilter()
    }
    
    var floatButton:RedButton = {
        let button = RedButton()
        return button
    }()
    
    var medicalAlert:NewMedicalAlert!

    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let cellNib = UINib(nibName: "DoctorPrototypeCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "DoctorPrototypeCell")
        view.addSubview(floatButton)
        floatButton.addTarget(self, action: #selector(addBarButtonTapped), for: .touchUpInside)
        navigationItem.title = NSLocalizedString("title_DoctorsTableViewController", comment: "")
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
    
    private func canBeDeleteDoctor(doctor:Doctor) -> Bool{
        if hasDiagnosisThisDoctor(doctor: doctor.getFullName()) == true || hasAnalysisThisDoctor(doctor: doctor.getFullName()) == true {
            return false
        } else {
            return true
        }
    }
    
    @objc
    func addButtonTapped(){
        createNewDoctorController()
    }
    
    //MARK: AlertControllers
    func showAlertCanBeDeletedDoctor(){
        medicalAlert = NewMedicalAlert()
        medicalAlert.showAlert(title: "Упс...", message: "Невозможно удалить эту карточку данных - есть связаные данные")
    }
}
//MARK: TableViewDataSource
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
        print(cell.frame.height)
        return cell
    }

}

//MARK: TableViewDelegate
extension DoctorsTableViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionSwipe = UIContextualAction(style: .normal, title: NSLocalizedString("addToContacts_MyDoctors", comment: "")) { [self]  _, _, _ in
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
        let actionSwipe = UIContextualAction(style: .normal, title: NSLocalizedString(NSLocalizedString("deleteItem", comment: ""), comment: "")) { [self] _, _, _ in
            if canBeDeleteDoctor(doctor: doctors[indexPath.row] as! Doctor){
                deleteDoctor(doctor: doctors[indexPath.row] as! Doctor)
                doctors.remove(at: indexPath.row)
                tableView.reloadData()
                
            }else{
                showAlertCanBeDeletedDoctor()
            }
        }
        actionSwipe.backgroundColor = .systemGray
        return UISwipeActionsConfiguration(actions: [actionSwipe])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentDoctor = doctors[indexPath.row] as! Doctor
        editDoctor(doctor: currentDoctor)
    }

}
