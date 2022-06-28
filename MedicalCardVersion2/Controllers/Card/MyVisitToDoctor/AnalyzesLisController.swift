//
//  AnalyzesLisController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 28.06.2022.
//

import UIKit
import CoreData

class AnalyzesLisController: UIViewController {
    
    var visit:VisitToDoctor?
    var sortAnalyzes:[NSManagedObject] = []

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addBarButtonTapped(_ sender: UIBarButtonItem) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let cellNib = UINib(nibName: "AnalysisCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "AnalysisCell")
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
    
}
