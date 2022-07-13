//
//  MyMedicamentController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 29.06.2022.
//

import UIKit
import CoreData

class MyMedicamentController: UIViewController {
    
    var medicaments:[NSManagedObject] = []
    var alert:NewMedicalAlert?
    
    var floatButton:RedButton = {
        let button = RedButton()
        return button
    }()

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        createNewMedicament(visitUUID: nil  )
    }
    
    
    @IBAction func filterBarButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    //MARK: Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("navigation_title_MyMedicament", comment: "")
        tableView.dataSource = self
        tableView.delegate = self
        let cellNIB  = UINib(nibName: "MedicamentCell", bundle: nil)
        tableView.register(cellNIB, forCellReuseIdentifier: "MedicamentCell")
        floatButton.addTarget(self, action: #selector(floatButtonTapped), for: .touchUpInside)
        view.addSubview(floatButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Medicament")
        do{
            medicaments = try managedContext.fetch(fetchRequest)
            print(medicaments.count)
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
    @objc
    func floatButtonTapped(){
        createNewMedicament(visitUUID: nil)
    }
}

//MARK: TableView DataSource
extension MyMedicamentController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicaments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let medicament = medicaments[indexPath.row] as! Medicament
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicamentCell") as! MedicamentCell
        cell.setupCell(medicament: medicament)
        return cell
    }
    
    
}

//MARK: TableView Delegate
extension MyMedicamentController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionSwipe = UIContextualAction(style: .normal, title: NSLocalizedString("startCourse_MyMedicament", comment: "")) { [self] _, _, _ in
            let currentMedicament = medicaments[indexPath.row] as! Medicament
            if currentMedicament.isTaken == false{
                generateCourseOfDay(medicament: currentMedicament)
                currentMedicament.isTaken = true
                currentMedicament.isOver = false
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
                let managedContext = appDelegate.persistentContainer.viewContext
                do{
                    try managedContext.save()
                } catch let error as NSError{
                    print("Could not save.\(error),\(error.userInfo)")
                }
                tableView.reloadData()
                alert = NewMedicalAlert()
                alert?.showAlert(title: NSLocalizedString("alert_title_Add_MyMedicament", comment: ""), message: NSLocalizedString("alert_message_Add_MyMedicament", comment: ""))
            } else {
                alert = NewMedicalAlert()
                alert?.showAlert(title: NSLocalizedString("alert_impossibleAdd_title", comment: ""), message: NSLocalizedString("alert_impossibleAdd_message", comment: ""))
            }
        }
        actionSwipe.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [actionSwipe])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionSwipe = UIContextualAction(style: .normal, title: NSLocalizedString("deleteItem", comment: "")) {[self] _, _, _ in
            let currentMedicament = medicaments[indexPath.row] as! Medicament
            if currentMedicament.isTaken{
                alert = NewMedicalAlert()
                alert?.showAlert(title: NSLocalizedString("alert_delete_title_MyMedicament" , comment: ""), message: NSLocalizedString("alert_delete_message_MyMedicament", comment: ""))
            }else{
                deleteMedicament(medicament: currentMedicament)
                medicaments.remove(at: indexPath.row)
                tableView.reloadData()
            }
        }
        actionSwipe.backgroundColor = .systemGray
        return UISwipeActionsConfiguration(actions: [actionSwipe])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentMedicament = medicaments[indexPath.row] as! Medicament
        editMedicament(medicament: currentMedicament)
    }
}
