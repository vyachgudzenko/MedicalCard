//
//  NewAnalysisController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 30.05.2022.
//

import UIKit

class NewAnalysisController: UITableViewController {
    
    var countOfFiles:Int = 0
    var uploadPopover:UploadFilePopoverController?
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var datePiecker: UIDatePicker!
    @IBOutlet weak var doctorLabel: UILabel!
    @IBOutlet weak var diagnosisLabel: UILabel!
    @IBOutlet weak var countOfFilesLabel: UILabel!

    
    
    @IBOutlet weak var dateLocalization: UILabel!
    @IBOutlet weak var doctorLocalization: UILabel!
    @IBOutlet weak var diagnosisLocalization: UILabel!
    @IBOutlet weak var countOfUploadFiles: UILabel!
    @IBOutlet weak var fileLocalization: UILabel!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var uploadFileButton: UIButton!
    
    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        uploadPopover = UploadFilePopoverController()
        uploadPopover?.showPopover(analysisUUID: self.uuid!)
    }
    
    var navigationTitle:String = NSLocalizedString("navigation_title_NewAnalysis", comment: "")
    var titleText:String = ""
    var descriptionText:String = ""
    var resultText:String = ""
    var dateAnalysis:Date = Date()
    var doctor:Doctor?
    var diagnosis:Diagnosis?
    var visitUUID:UUID?
    var uuid:UUID?
    var doctorLabelText = NSLocalizedString("doctor_Unknown", comment: "")
    var diagnosisLabelText = NSLocalizedString("diagnosis_unknown", comment: "")
    
    var doAfterCreate:((String,String,String,Date,Doctor,Diagnosis?,String?,UUID?) -> Void)?
    
    var alert:NewMedicalAlert?
    
    //MARK: Other function
    func fieldsIsEmpty() -> Bool {
        if titleTextField.text == "" || descriptionTextView.text == "" ||
            resultTextView.text == "" ||
            doctor == nil || diagnosis == nil {
            return true
        } else {
            return false
        }
    }
    
    func setupTextView(textView:UITextView){
        textView.layer.borderColor = UIColor.systemGray6.cgColor
        textView.layer.borderWidth = 1
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView(textView: descriptionTextView)
        setupTextView(textView: resultTextView)
        navigationItem.title = navigationTitle
        titleTextField.text = titleText
        titleTextField.placeholder = NSLocalizedString("titleTextField_placeholder_NewAnalysis", comment: "")
        descriptionTextView.text = descriptionText
        descriptionLabel.text = NSLocalizedString("descriptionTextField_placeholder_NewAnalysis", comment: "")
        resultTextView.text = resultText
        resultLabel.text = NSLocalizedString("resultTextField_placeholder_NewAnalysis", comment: "")
        dateLocalization.text = NSLocalizedString("date_NewAnalysis", comment: "")
        doctorLocalization.text = NSLocalizedString("doctorLocalization", comment: "")
        diagnosisLocalization.text = NSLocalizedString("diagnosis_NewVisit", comment: "")
        countOfFilesLabel.text = NSLocalizedString("countOfFiles", comment: "")
        fileLocalization.text = NSLocalizedString("file", comment: "")
        saveButton.title = NSLocalizedString("buttonSave", comment: "")
        uploadFileButton.setTitle(NSLocalizedString("uploadFileButton", comment: ""), for: .normal)
        datePiecker.date = dateAnalysis
        doctorLabel.text = doctorLabelText
        diagnosisLabel.text = diagnosisLabelText
        if uuid == nil{
            uuid = UUID()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        countOfFilesLabel.text = "\(countOfUploadFiles(uuid: uuid!.uuidString)) шт."
    }
    
    //MARK: IBAction
    @IBAction func clickOnSaveButton(_ sender:UIBarButtonItem){
        if fieldsIsEmpty() {
            showAlertFieldISEmpty()
        } else {
            let title = titleTextField.text!
            let description = descriptionTextView.text!
            let result = resultTextView.text!
            let date = datePiecker.date
            doAfterCreate?(title,description,result,date,doctor!,diagnosis,visitUUID?.uuidString,uuid)
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("table_Header", comment: "")
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
        alert = NewMedicalAlert()
        alert?.showAlert(title: "Не заполнены поля", message: "Заполните пожалуйста все поля, что бы можно было корректно сохранить информацию")
    }

}
