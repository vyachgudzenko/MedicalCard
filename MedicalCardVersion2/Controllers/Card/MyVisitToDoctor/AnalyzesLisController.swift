//
//  AnalyzesLisController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 28.06.2022.
//

import UIKit
import CoreData

class AnalyzesLisController: UIViewController {
    
    var visitUUID:UUID?
    var sortAnalyzes:[NSManagedObject] = []
    
    var floatButton:RedButton! = {
        let button = RedButton()
        return button
    }()

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addBarButtonTapped(_ sender: UIBarButtonItem) {
        createNewAnalisys(uuid: visitUUID)
        tableView.reloadData()
    }
    
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Analysis>
        fetchRequest = Analysis.fetchRequest()
        guard let uuidString = visitUUID?.uuidString else {
            return
        }
        fetchRequest.predicate = NSPredicate(
            format: "visitUUID LIKE %@", uuidString)
        do{
            sortAnalyzes = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch{
            fatalError()
        }
    }
    
    override func viewDidLayoutSubviews() {
        floatButton.frame = CGRect(x: view.frame.width - 90, y: view.frame.height - view.frame.height * 0.2, width: 70, height: 70)
    }
    
    @objc
    func floatButtonTapped(){
        createNewAnalisys(uuid: visitUUID)
    }
}

extension AnalyzesLisController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortAnalyzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnalysisCell", for: indexPath) as! AnalysisCell
        let currentAnalysis = sortAnalyzes[indexPath.row] as! Analysis
        cell.setupCell(analysis: currentAnalysis)
        return cell
    }
    
    
}

extension AnalyzesLisController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentAnalysis = sortAnalyzes[indexPath.row] as! Analysis
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
            titleOfAnalysis,descriptionOfAnalysis,result,date,doctor,diagnosis,visitUUID in
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
