//
//  MyAnalisysController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 27.05.2022.
//

import UIKit
import CoreData

class MyAnalyzesController: UIViewController {

    var analyzes:[NSManagedObject] = []
    
    var floatButton:RedButton! = {
        let button = RedButton()
        return button
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addBarButtonTapped(_ sender: UIBarButtonItem) {
        createNewAnalisys()
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let cellNib = UINib(nibName: "AnalysisCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "AnalysisCell")
        view.addSubview(floatButton)
        floatButton.addTarget(self, action: #selector(floatButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Analysis")
        do{
            analyzes = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError{
            print("Could not save.\(error),\(error.userInfo)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        floatButton.frame = CGRect(x: view.frame.width - 90, y: view.frame.height - view.frame.height * 0.2, width: 70, height: 70)
    }
    //MARK: Other function
    private  func save(title:String,descriptionofAnalysis:String,result:String,date:Date,doctor:Doctor,diagnosis:Diagnosis){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Analysis", in: managedContext)!
        let newAnalysis = NSManagedObject(entity: entity, insertInto: managedContext)
        newAnalysis.setValue(title, forKey: "title")
        newAnalysis.setValue(descriptionofAnalysis, forKey: "descriptionOfAnalysis")
        newAnalysis.setValue(result, forKey: "result")
        newAnalysis.setValue(date, forKey: "date")
        newAnalysis.setValue(doctor, forKey: "doctor")
        newAnalysis.setValue(doctor.getFullName(), forKey: "doctorFullName")
        newAnalysis.setValue(diagnosis, forKey: "diagnosis")
        newAnalysis.setValue(diagnosis.title, forKey: "diagnosisTitle")
    }

    func createNewAnalisys(){
        let newAnalisys = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewAnalysisController") as! NewAnalysisController
        newAnalisys.doAfterCreate = { [self]
            titleOfAnalysis,descriptionOfAnalysis,result,date,doctor,diagnosis in
            save(title: titleOfAnalysis, descriptionofAnalysis: descriptionOfAnalysis, result: result, date: date, doctor: doctor, diagnosis: diagnosis)
        }
        navigationController?.pushViewController(newAnalisys, animated: true)
    }
    
    @objc
    func floatButtonTapped(){
        createNewAnalisys()
    }
    
    // MARK: - Navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewAnalysis"{
            let destination = segue.destination as! NewAnalysisController
            destination.doAfterCreate = { [self]
                titleOfAnalysis,descriptionOfAnalysis,result,date,doctor,diagnosis in
                save(title: titleOfAnalysis, descriptionofAnalysis: descriptionOfAnalysis, result: result, date: date, doctor: doctor, diagnosis: diagnosis)
            }
        }
    }*/
}

extension MyAnalyzesController:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return analyzes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnalysisCell", for: indexPath) as! AnalysisCell
        let currentAnalysis = analyzes[indexPath.row] as! Analysis
        cell.setupCell(analysis: currentAnalysis)
        return cell
    }
}

extension MyAnalyzesController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionSwipe = UIContextualAction(style: .normal, title: "Удалить") { [self] _, _, _ in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(analyzes[indexPath.row])
            do{
                try managedContext.save()
                analyzes.remove(at: indexPath.row)
                tableView.reloadData()
            } catch let error as NSError{
                print("Could not save.\(error),\(error.userInfo)")
            }
        }
        actionSwipe.backgroundColor = .systemGray
        return UISwipeActionsConfiguration(actions: [actionSwipe])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentAnalysis = analyzes[indexPath.row] as! Analysis
        let editScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewAnalysisController") as! NewAnalysisController
        editScreen.navigationItem.title = currentAnalysis.title
        editScreen.titleText = currentAnalysis.title!
        editScreen.descriptionText = currentAnalysis.descriptionOfAnalysis ?? ""
        editScreen.resultText = currentAnalysis.result!
        editScreen.dateAnalysis = currentAnalysis.date!
        editScreen.doctor = currentAnalysis.doctor
        editScreen.doctorLabelText = currentAnalysis.doctorFullName!
        editScreen.diagnosis = currentAnalysis.diagnosis
        editScreen.diagnosisLabelText = currentAnalysis.diagnosisTitle!
        editScreen.doAfterCreate = {
            titleOfAnalysis,descriptionOfAnalysis,result,date,doctor,diagnosis in
            currentAnalysis.title = titleOfAnalysis
            currentAnalysis.descriptionOfAnalysis = descriptionOfAnalysis
            currentAnalysis.result = result
            currentAnalysis.date = date
            currentAnalysis.doctor = doctor
            currentAnalysis.diagnosis = diagnosis
            currentAnalysis.doctorFullName = doctor.getFullName()
            currentAnalysis.diagnosisTitle = diagnosis.title
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
