//
//  NewVisitController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 27.06.2022.
//

import UIKit

class NewVisitController: UITableViewController {

    var complaint:String? = ""
    var date:Date = Date()
    var doctor:Doctor?
    var diagnosis:Diagnosis?
    var uuid:UUID?
    var navigationTitle:String = NSLocalizedString("navigation_title_NewVisit", comment: "")
    
    
    var doAfterCreate:((String?,Date?,Doctor?,Diagnosis?,UUID) -> Void)?
    
    
    @IBOutlet weak var complaintLabel: UILabel!
    
    @IBOutlet weak var complaintTextView: UITextView!
    @IBOutlet weak var datePiecker: UIDatePicker!
    @IBOutlet weak var doctorLabel: UILabel!
    @IBOutlet weak var diagnosisLabel: UILabel!
    @IBOutlet weak var countOfAnalysisLAbel: UILabel!
    @IBOutlet weak var countOfMedicamentLabel: UILabel!
    //Localization outlets
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var dateLabelLocaliztion: UILabel!
    @IBOutlet weak var doctorLabelLocalization: UILabel!
    @IBOutlet weak var diagnosisLabelLocalization: UILabel!
    @IBOutlet weak var analysisLabelLocalization: UILabel!
    @IBOutlet weak var medicamentLabelLocalization: UILabel!
    
    @IBAction func saveButtonTapped(_ sender:UIBarButtonItem){
        complaint = complaintTextView.text ?? ""
        date = datePiecker.date
        doAfterCreate?(complaint,date,doctor,diagnosis,uuid!)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView(textView: complaintTextView)
        navigationItem.title = navigationTitle
        complaintTextView.text = complaint
        complaintLabel.text = NSLocalizedString("complaintPlaceholder_NewVisit", comment: "")
        dateLabelLocaliztion.text = NSLocalizedString("date_NewVisit", comment: "")
        dateLabelLocaliztion.text = NSLocalizedString("doctor_NewVisit", comment: "")
        doctorLabel.text = doctor?.getFullName() ?? NSLocalizedString("doctor_Unknown", comment: "")
        diagnosisLabelLocalization.text = NSLocalizedString("diagnosis_NewVisit", comment: "")
        diagnosisLabel.text = diagnosis?.title ?? NSLocalizedString("diagnosis_unknown", comment: "")
        saveButton.title = NSLocalizedString("buttonSave", comment: "")
        analysisLabelLocalization.text = NSLocalizedString("analysis_NewVisit", comment: "")
        medicamentLabelLocalization.text = NSLocalizedString("medicaments_NewVisit", comment: "")
        datePiecker.date = date
        if uuid == nil{
            uuid = UUID()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        countOfAnalysisLAbel.text = "\(countAnalysisHasThisVisit(uuid: uuid!.uuidString))"
        countOfMedicamentLabel.text = "\(countMedicamentHasThisVisit(uuid: uuid!.uuidString))"
    }
    //MARK: Other function
    func setupTextView(textView:UITextView){
        textView.layer.borderColor = UIColor.systemGray6.cgColor
        textView.layer.borderWidth = 1
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("table_Header", comment: "")
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromVisitToDoctors"{
            let destination = segue.destination as! DoctorsListController
            destination.doAfterSelected = {
                [self] selectedDoctor in
                self.doctor = selectedDoctor
                self.doctorLabel.text = selectedDoctor.getFullName()
            }
        }
        if segue.identifier == "fromVisitToDiagnosis"{
            let destination = segue.destination as! DiagnosesListController
            destination.doAfterSelected = {
                selectedDiagnosis in
                self.diagnosis = selectedDiagnosis
                self.diagnosisLabel.text = selectedDiagnosis.title
            }
        }
        if segue.identifier == "fromVisitToAnalyzes"{
            let destination = segue.destination as!
            AnalyzesLisController
            destination.visitUUID = uuid
            tableView.reloadData()
        }
        if segue.identifier == "fromVisitToMedicament"{
            let destination = segue.destination as!
            MedicamentListController
            destination.visitUUID = uuid
            tableView.reloadData()
        }
        
    }
    

}
