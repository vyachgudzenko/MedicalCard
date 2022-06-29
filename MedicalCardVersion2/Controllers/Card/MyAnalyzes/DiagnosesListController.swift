//
//  DiagnosesListController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 30.05.2022.
//

import UIKit
import CoreData

class DiagnosesListController: UIViewController {

    var diagnoses:[NSManagedObject] = []
    var doAfterSelected:((Diagnosis) -> Void)?
    
    var floatButton:RedButton = {
        let button = RedButton()
        return button
    }()
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addButtonTapped(_ sender: Any) {
        createNewDiagnosisController()
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let cellNib = UINib(nibName: "DiagnosisCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "DiagnosisCell")
        floatButton.addTarget(self, action: #selector(floatButtonTapped), for: .touchUpInside)
        view.addSubview(floatButton)
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
    @objc
    func floatButtonTapped(){
        createNewDiagnosisController()
    }
}

extension DiagnosesListController:UITableViewDataSource{
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
}

extension DiagnosesListController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentDiagnosis = diagnoses[indexPath.row] as! Diagnosis
        doAfterSelected?(currentDiagnosis)
        navigationController?.popViewController(animated: true)
    }
}
