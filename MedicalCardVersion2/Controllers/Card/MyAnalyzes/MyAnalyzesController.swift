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
        createNewAnalisys(uuid: nil)
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
    @objc
    func floatButtonTapped(){
        createNewAnalisys(uuid: nil)
    }
}
//MARK: TableView DataSource
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
        print(currentAnalysis.visitUUID)
        cell.setupCell(analysis: currentAnalysis)
        return cell
    }
}
//MARK: TableView Delegate
extension MyAnalyzesController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionSwipe = UIContextualAction(style: .normal, title: "Удалить") { [self] _, _, _ in
            deleteAnalysis(analysis: analyzes[indexPath.row] as! Analysis)
            tableView.reloadData()
            analyzes.remove(at: indexPath.row)
        }
        actionSwipe.backgroundColor = .systemGray
        return UISwipeActionsConfiguration(actions: [actionSwipe])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentAnalysis = analyzes[indexPath.row] as! Analysis
        editAnalysis(analysis: currentAnalysis)
    }

}
