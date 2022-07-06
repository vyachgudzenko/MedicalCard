//
//  NewAnalysisController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 30.05.2022.
//

import UIKit

class NewAnalysisController: UITableViewController {
    
    var countOfFiles:Int = 0
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var resultTextField: UITextField!
    @IBOutlet weak var datePiecker: UIDatePicker!
    @IBOutlet weak var doctorLabel: UILabel!
    @IBOutlet weak var diagnosisLabel: UILabel!
    @IBOutlet weak var countOfFilesLabel: UILabel!
    @IBOutlet weak var uploadButton: UIButton!
    
    
    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        let uploadFileScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UploadFileController") as! UploadFileController
        uploadFileScreen.analysisUUID = uuid
        navigationController?.pushViewController(uploadFileScreen, animated: true)
    }
    
    var titleText:String = ""
    var descriptionText:String = ""
    var resultText:String = ""
    var dateAnalysis:Date = Date()
    var doctor:Doctor?
    var diagnosis:Diagnosis?
    var visitUUID:UUID?
    var uuid:UUID?
    var doctorLabelText = "Выберите врача"
    var diagnosisLabelText = "Выберите диагноз"
    
    var doAfterCreate:((String,String,String,Date,Doctor,Diagnosis,String?,UUID?) -> Void)?
    
    var alert:MedicalAlert?
    
    //MARK: Other function
    func fieldsIsEmpty() -> Bool {
        if titleTextField.text == "" || descriptionTextField.text == "" ||
            resultTextField.text == "" ||
            doctor == nil ||
            diagnosis == nil{
            return true
        } else {
            return false
        }
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.text = titleText
        descriptionTextField.text = descriptionText
        resultTextField.text = resultText
        datePiecker.date = dateAnalysis
        doctorLabel.text = doctorLabelText
        diagnosisLabel.text = diagnosisLabelText
        countOfFilesLabel.text = "\(countOfFiles) шт."
        if uuid == nil{
            uuid = UUID()
        }
    }
    
    //MARK: IBAction
    @IBAction func clickOnSaveButton(_ sender:UIBarButtonItem){
        if fieldsIsEmpty() {
            showAlertFieldISEmpty()
        } else {
            let title = titleTextField.text!
            let description = descriptionTextField.text!
            let result = resultTextField.text!
            let date = datePiecker.date
            doAfterCreate?(title,description,result,date,doctor!,diagnosis!,visitUUID?.uuidString,uuid)
            navigationController?.popViewController(animated: true)
        }
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
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
        if segue.identifier == "toUploadFileList"{
            let destination = segue.destination as! UploadFileListController
            destination.analysisUUID = uuid?.uuidString
        }
    }
    
    //MARK: AlertControllers
    func showAlertFieldISEmpty(){
        alert = MedicalAlert()
        alert?.showAlert(title: "Не заполнены поля", message: "Заполните пожалуйста все поля, что бы можно было корректно сохранить информацию", viewController: self)
    }

}
