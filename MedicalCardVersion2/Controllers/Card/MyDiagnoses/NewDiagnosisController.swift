//
//  NewDiagnosisController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 27.05.2022.
//

import UIKit

class NewDiagnosisController: UITableViewController {
    
    var doctor:Doctor?
    
    var alert:NewMedicalAlert?
    
    var navigationTitle:String = NSLocalizedString("navigation_title_NewDiagnosis", comment: "")
    var titleFirst:String = ""
    var descriptionFirst:String = ""
    var dateFirst:Date = Date()
    var doctorLabelText = NSLocalizedString("doctor_Unknown", comment: "")
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var datePiecker: UIDatePicker!
    @IBOutlet weak var doctorLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = navigationTitle
        titleTextField.text = titleFirst
        titleTextField.placeholder = NSLocalizedString("newDiagnosis_titlePlaceholder_text", comment: "")
        descriptionTextField.text = descriptionFirst
        descriptionTextField.placeholder = NSLocalizedString("newDiagnosis_descriptionPlaceholder_text", comment: "")
        datePiecker.date = dateFirst
        doctorLabel.text = doctorLabelText
        saveButton.title = NSLocalizedString("saveButton_NewDiagnosis", comment: "")
    }
    
    var doAfterCreate:((String,String,Date,Doctor) -> Void)?
    
    //MARK: Other function
    func fieldIsEmpty() -> Bool{
        if titleTextField.text == "" || descriptionTextField.text == "" || doctor == nil{
            return true
        } else {
            return false
        }
    }
    
    //MARK: IBAction function
    @IBAction func clickOnSaveButton(_ sender:UIBarButtonItem){
        if fieldIsEmpty(){
            showAlertFieldISEmpty()
        } else{
            let titleDiagnosis:String = titleTextField.text!
            let descriptionDiagnosis:String = descriptionTextField.text!
            let dateDiagnosis:Date = datePiecker.date
            doAfterCreate?(titleDiagnosis,descriptionDiagnosis,dateDiagnosis,doctor!)
            navigationController?.popViewController(animated: true)
        }
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("table_Header", comment: "")
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDoctorsScreen"{
            let destination = segue.destination as! DoctorsListController
            destination.doAfterSelected = {
                [self] selectedDoctor in
                self.doctor = selectedDoctor
                self.doctorLabel.text = selectedDoctor.getFullName()
            }
        }
    }
    
    //MARK: AlertControllers
    func showAlertFieldISEmpty(){
        alert = NewMedicalAlert()
        alert?.showAlert(title: NSLocalizedString("alert_Titile_NewDiagnosis", comment: ""), message: NSLocalizedString("alert_Message_NewDiagnosis", comment: ""))
    }

}
