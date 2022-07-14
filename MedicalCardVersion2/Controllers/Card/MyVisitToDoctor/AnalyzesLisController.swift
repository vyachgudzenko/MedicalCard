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
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("navigation_title_AnalyzList", comment: "")
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
    
    //MARK: Other function
    @objc
    func floatButtonTapped(){
        createNewAnalisys(uuid: visitUUID)
    }
}

//MARK: TAbleView DataSource
extension AnalyzesLisController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortAnalyzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnalysisCell", for: indexPath) as! AnalysisCell
        let currentAnalysis = sortAnalyzes[indexPath.row] as! Analysis
        cell.setupCell(analysis: currentAnalysis,countOfFile: countOfUploadFiles(uuid: currentAnalysis.uuid!.uuidString))
        return cell
    }
    
    
}

//MARK: TAbleView Delegate
extension AnalyzesLisController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentAnalysis = sortAnalyzes[indexPath.row] as! Analysis
        editAnalysis(analysis: currentAnalysis)
    }
}
