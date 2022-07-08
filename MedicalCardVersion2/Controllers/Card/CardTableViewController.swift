//
//  CardTableViewController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 04.05.2022.
//

import UIKit

class CardTableViewController: UITableViewController {
    
    //MARK: Outlets
    @IBOutlet weak var diagnosisLabel: UILabel!
    @IBOutlet weak var diagnosisDescriptionLabel: UILabel!
    @IBOutlet weak var visitLabel: UILabel!
    @IBOutlet weak var visitDescriptionLabel: UILabel!
    @IBOutlet weak var analysisLabel: UILabel!
    @IBOutlet weak var analysisDescriptionLAbel: UILabel!
    @IBOutlet weak var medicamentLabel: UILabel!
    @IBOutlet weak var medicamentDescriptionLsbel: UILabel!
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("title_medicalCard", comment: "")
        diagnosisLabel.text = NSLocalizedString("diagnosis", comment: "")
        diagnosisDescriptionLabel.text = NSLocalizedString("diagnosisDescription", comment: "")
        visitLabel.text = NSLocalizedString("visits", comment: "")
        visitDescriptionLabel.text = NSLocalizedString("visitsDescription", comment: "")
        analysisLabel.text = NSLocalizedString("analysis", comment: "")
        analysisDescriptionLAbel.text = NSLocalizedString("analysisDescription", comment: "")
        medicamentLabel.text = NSLocalizedString("medicaments", comment: "")
        medicamentDescriptionLsbel.text = NSLocalizedString("medicamentsDescription", comment: "")
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
}
