//
//  NewAnalysisController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 30.05.2022.
//

import UIKit

class NewAnalysisController: UITableViewController {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var resultTextField: UITextField!
    @IBOutlet weak var datePiecker: UIDatePicker!
    @IBOutlet weak var doctorLabel: UILabel!
    @IBOutlet weak var diagnosisLabel: UILabel!
    @IBOutlet weak var uploadButton: UIButton!
    
    var titleText:String = ""
    var descriptionText:String = ""
    var resultText:String = ""
    var dateAnalysis:Date = Date()
    var doctor:Doctor?
    var diagnosis:Diagnosis?
    var doctorLabelText = "Выберите врача"
    var diagnosisLabelText = "Выберите диагноз"
    
    var doAfterCreate:((String,String,String,Date,Doctor,Diagnosis) -> Void)?
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.text = titleText
        descriptionTextField.text = descriptionText
        resultTextField.text = resultText
        datePiecker.date = dateAnalysis
        doctorLabel.text = doctorLabelText
        diagnosisLabel.text = diagnosisLabelText
    }
    
    //MARK: IBAction
    @IBAction func clickOnSaveButton(_ sender:UIBarButtonItem){
        let title = titleTextField.text!
        let description = descriptionTextField.text!
        let result = resultTextField.text!
        let date = datePiecker.date
        doAfterCreate?(title,description,result,date,doctor!,diagnosis!)
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromNewAnaysisToDoctors"{
            let destination = segue.destination as! DoctorsListController
            destination.doAfterSelected = {
                [self] selectedDoctor in
                self.doctor = selectedDoctor
                self.doctorLabel.text = selectedDoctor.getFullName()
            }
        }
        if segue.identifier == "toDiagnosesList"{
            let destination = segue.destination as! DiagnosesListController
            destination.doAfterSelected = {
                selectedDiagnosis in
                self.diagnosis = selectedDiagnosis
                self.diagnosisLabel.text = selectedDiagnosis.title
            }
        }
    }

}
