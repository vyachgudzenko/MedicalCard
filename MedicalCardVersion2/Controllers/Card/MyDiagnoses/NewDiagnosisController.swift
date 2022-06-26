//
//  NewDiagnosisController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 27.05.2022.
//

import UIKit

class NewDiagnosisController: UITableViewController {
    
    var doctor:Doctor?
    
    var alert:MedicalAlert?
    
    var titleFirst:String = ""
    var descriptionFirst:String = ""
    var dateFirst:Date = Date()
    var doctorLabelText = "Выберите врача"
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var datePiecker: UIDatePicker!
    @IBOutlet weak var doctorLabel: UILabel!
   
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.text = titleFirst
        descriptionTextField.text = descriptionFirst
        datePiecker.date = dateFirst
        doctorLabel.text = doctorLabelText
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
        alert = MedicalAlert()
        alert?.showAlert(title: "Не заполнены поля", message: "Заполните пожалуйста все поля, что бы можно было корректно сохранить информацию", viewController: self)
    }

}
