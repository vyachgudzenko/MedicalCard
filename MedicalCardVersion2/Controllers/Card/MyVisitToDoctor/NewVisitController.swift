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
    
    
    var doAfterCreate:((String?,Date?,Doctor?,Diagnosis?,UUID) -> Void)?
    
    
    @IBOutlet weak var complaintTextField: UITextField!
    
    @IBOutlet weak var datePiecker: UIDatePicker!
    @IBOutlet weak var doctorLabel: UILabel!
    @IBOutlet weak var diagnosisLabel: UILabel!
    @IBOutlet weak var countOfAnalysisLAbel: UILabel!
    @IBOutlet weak var countOfMedicamentLabel: UILabel!
    
    @IBAction func saveButtonTapped(_ sender:UIBarButtonItem){
        complaint = complaintTextField.text ?? ""
        date = datePiecker.date
        doAfterCreate?(complaint,date,doctor,diagnosis,uuid!)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        complaintTextField.text = complaint
        doctorLabel.text = doctor?.getFullName() ?? "Выберите врача"
        diagnosisLabel.text = diagnosis?.title ?? "Выберите диагноз"
        datePiecker.date = date
        if uuid == nil{
            uuid = UUID()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        countOfAnalysisLAbel.text = "\(countAnalysisHasThisVisit(uuid: uuid!.uuidString))"
        countOfMedicamentLabel.text = "\(countMedicamentHasThisVisit(uuid: uuid!.uuidString))"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

   

    
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
