//
//  NewVisitController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 27.06.2022.
//

import UIKit

class NewVisitController: UITableViewController {

    var complaint:String = ""
    var date = Date()
    var doctor:Doctor?
    var diagnosis:Diagnosis?
    
    var doAfterCreate:((String,Date,Doctor?,Diagnosis?) -> Void)?
    
    
    @IBOutlet weak var complaintTextField: UITextField!
    
    @IBOutlet weak var datePiecker: UIDatePicker!
    @IBOutlet weak var doctorLabel: UILabel!
    @IBOutlet weak var diagnosisLabel: UILabel!
    @IBOutlet weak var countOfAnalysisLAbel: UILabel!
    @IBOutlet weak var countOfMedicamentLabel: UILabel!
    
    @IBAction func saveButtonTapped(_ sender:UIBarButtonItem){
        complaint = complaintTextField.text ?? ""
        date = datePiecker.date
        doAfterCreate?(complaint,date,doctor,diagnosis)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doctorLabel.text = doctor?.getFullName() ?? "Выберите врача"
        diagnosisLabel.text = diagnosis?.title ?? "Выберите диагноз"
        countOfAnalysisLAbel.text = "0 шт."
        countOfMedicamentLabel.text = "0 шт."
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
        
        
    }
    

}
