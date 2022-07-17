//
//  MyDiseaseController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 27.05.2022.
//

import UIKit
import CoreData

class MyDiagnosesController: UIViewController {
    
    var searchData:String?
    
    var diagnoses:[NSManagedObject] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    var alert:NewMedicalAlert?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
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
        searchBar.delegate = self
        setupSearchBar(searchBar: searchBar)
        navigationItem.title = NSLocalizedString("navigation_title_MyDiagnosis", comment: "")
        tableView.dataSource = self
        tableView.delegate = self
        let cellNib = UINib(nibName: "DiagnosisCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "DiagnosisCell")
        view.addSubview(floatButton)
        floatButton.addTarget(self, action: #selector(floatButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        diagnoses = getDiagnoses()
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
    
    private func setupSearchBar(searchBar:UISearchBar){
        searchBar.layer.masksToBounds = true
        searchBar.layer.cornerRadius = 15
        searchBar.searchBarStyle = .default
        
    }
    
    
    private func canBeDeleteDiagnosis(diagnosis:Diagnosis) -> Bool{
        if hasAnalysisThisDiagnosis(diagnosisTitle: diagnosis.title!){
            return false
        } else {
            return true
        }
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
        alert = NewMedicalAlert()
        alert?.showAlert(title: NSLocalizedString("alert_Title_MyDiagnosis", comment: ""), message: NSLocalizedString("alert_Message_MyDiagnosis", comment: ""))
    }

}
//MARK: TableViewDelegate
extension MyDiagnosesController:UITableViewDelegate{
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionSwipe = UIContextualAction(style: .normal, title: "Удалить") { [self] _, _, _ in
            if canBeDeleteDiagnosis(diagnosis: diagnoses[indexPath.row] as! Diagnosis){
                deleteDiagnosis(diagnosis: diagnoses[indexPath.row] as! Diagnosis, index: indexPath.row)
                diagnoses.remove(at: indexPath.row)
                tableView.reloadData()
            } else {
                showAlert()
            }
        }
        actionSwipe.backgroundColor = .systemGray
        return UISwipeActionsConfiguration(actions: [actionSwipe])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentDiagnosis = diagnoses[indexPath.row] as! Diagnosis
        editDiagnosis(diagnosis: currentDiagnosis)
    }
}

extension MyDiagnosesController:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchData = searchText
        if searchData == ""{
            diagnoses = getDiagnoses()
        } else {
            diagnoses = getSearchResultDiagnosis(searchText: searchData!)
        }
        
    }
}
