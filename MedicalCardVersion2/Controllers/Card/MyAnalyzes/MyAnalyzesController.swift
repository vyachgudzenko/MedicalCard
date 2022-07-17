//
//  MyAnalisysController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 27.05.2022.
//

import UIKit
import CoreData

class MyAnalyzesController: UIViewController {

    var analyzes:[NSManagedObject] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    var searchData:String?
    
    var floatButton:RedButton! = {
        let button = RedButton()
        return button
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func addBarButtonTapped(_ sender: UIBarButtonItem) {
        createNewAnalisys(uuid: nil)
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar(searchBar: searchBar)
        searchBar.delegate = self
        navigationItem.title = NSLocalizedString("navigation_title_MyAnalyzes", comment: "")
        tableView.dataSource = self
        tableView.delegate = self
        let cellNib = UINib(nibName: "AnalysisCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "AnalysisCell")
        view.addSubview(floatButton)
        floatButton.addTarget(self, action: #selector(floatButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        analyzes = getAnalyzes()
        
    }
    
    override func viewDidLayoutSubviews() {
        floatButton.frame = CGRect(x: view.frame.width - 90, y: view.frame.height - view.frame.height * 0.2, width: 70, height: 70)
    }
    //MARK: Other function
    @objc
    func floatButtonTapped(){
        createNewAnalisys(uuid: nil)
    }
    
    private func setupSearchBar(searchBar:UISearchBar){
        searchBar.layer.masksToBounds = true
        searchBar.layer.cornerRadius = 15
        searchBar.searchBarStyle = .default
        
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
        let count = countOfUploadFiles(uuid: currentAnalysis.uuid!.uuidString)
        cell.setupCell(analysis: currentAnalysis,countOfFile: count)
        return cell
    }
}
//MARK: TableView Delegate
extension MyAnalyzesController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionSwipe = UIContextualAction(style: .normal, title: NSLocalizedString("deleteItem", comment: "")) { [self] _, _, _ in
            deleteAnalysis(analysis: analyzes[indexPath.row] as! Analysis)
            analyzes.remove(at: indexPath.row)
            tableView.reloadData()
            
        }
        actionSwipe.backgroundColor = .systemGray
        return UISwipeActionsConfiguration(actions: [actionSwipe])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentAnalysis = analyzes[indexPath.row] as! Analysis
        editAnalysis(analysis: currentAnalysis)
    }

}

extension MyAnalyzesController:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchData = searchText
        if searchData == ""{
            analyzes = getAnalyzes()
        } else {
            analyzes = getSearchResultAnalyzes(searchText: searchData!)
        }
    }
}
