//
//  MyDiseaseController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 27.05.2022.
//

import UIKit
import CoreData

class MyDiagnosesController: UIViewController {
    var diagnoses:[NSManagedObject] = []
    var alert:MedicalAlert?
    
    @IBOutlet weak var tableView: UITableView!
    var floatButton:RedButton! = {
        let button = RedButton()
        return button
    }()
    
    @IBAction func addBarButtonTapped(_ sender: Any) {
        createNewDiagnosisController()
    }
    
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let cellNib = UINib(nibName: "DiagnosisCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "DiagnosisCell")
        view.addSubview(floatButton)
        floatButton.addTarget(self, action: #selector(floatButtonTapped), for: .touchUpInside)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatButton.frame = CGRect(x: view.frame.width - 90, y: view.frame.height - view.frame.height * 0.2, width: 70, height: 70)
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
    
    func createNewDiagnosisController(){
        let newDiagnosis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewDiagnosisController") as! NewDiagnosisController
        newDiagnosis.doAfterCreate = {
            [self] titleOfDiagnosis,descriptionOfDiagnosis,date,doctor in
            save(title: titleOfDiagnosis, description: descriptionOfDiagnosis, date: date, doctor: doctor)
            
        }
        navigationController?.pushViewController(newDiagnosis, animated: true)
    }
    
    @objc
    func floatButtonTapped(){
        createNewDiagnosisController()
    }
    
    private func deleteDiagnosis(diagnosis:Diagnosis, index:Int){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(diagnosis)
        do{
            try managedContext.save()
            diagnoses.remove(at: index)
            tableView.reloadData()
        } catch let error as NSError{
            print("Could not save.\(error),\(error.userInfo)")
        }
    }
    
    private func canBeDeleteDiagnosis(diagnosis:Diagnosis) -> Bool{
        if hasAnalysisThisDiagnosis(diagnosisTitle: diagnosis.title!){
            return false
        } else {
            return true
        }
    }
    
    private func hasAnalysisThisDiagnosis(diagnosisTitle:String) -> Bool{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Analysis>
        fetchRequest = Analysis.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "diagnosisTitle LIKE %@", diagnosisTitle)
        do{
            let object = try managedContext.fetch(fetchRequest)
            if object.isEmpty{
                return false
            }
        } catch{
            fatalError()
        }
        return true
    }
}
//MARK: TableViewDataSource
extension MyDiagnosesController:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diagnoses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiagnosisCell", for: indexPath) as! DiagnosisCell
        let diagnosis = diagnoses[indexPath.row] as! Diagnosis
        
        cell.setupCell(diagnosis: diagnosis)
        return cell
    }
    
    //MARK: AlertController
    private func showAlert(){
        alert = MedicalAlert()
        alert?.showAlert(title: "Упс...", message: "Невозможно удалить эту карточку данных - есть связаные данные", viewController: self)
    }

}
//MARK: TableViewDelegate
extension MyDiagnosesController:UITableViewDelegate{
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionSwipe = UIContextualAction(style: .normal, title: "Удалить") { [self] _, _, _ in
            if canBeDeleteDiagnosis(diagnosis: diagnoses[indexPath.row] as! Diagnosis){
                deleteDiagnosis(diagnosis: diagnoses[indexPath.row] as! Diagnosis, index: indexPath.row)
            } else {
                showAlert()
            }
        }
        actionSwipe.backgroundColor = .systemGray
        return UISwipeActionsConfiguration(actions: [actionSwipe])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentDiagnosis = diagnoses[indexPath.row] as! Diagnosis
        let editScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewDiagnosisController") as! NewDiagnosisController
        editScreen.navigationItem.title = currentDiagnosis.title
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
}
