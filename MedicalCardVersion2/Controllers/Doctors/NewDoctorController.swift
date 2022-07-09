//
//  NewDoctorController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 08.05.2022.
//

import UIKit

class NewDoctorController: UITableViewController {
    
    //MARK: Outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var clinicTextField: UITextField!
    @IBOutlet weak var numberPhoneTextField: UITextField!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var specializationLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var firstName:String = ""
    var lastName:String = ""
    var clinic:String = ""
    var phoneNumber:String = ""
    var profession:Profession = .therapist
    
    var doAfterCreate:((String,String,String,String,String) ->Void)?
    
    var professionTitles:[Profession:String] = [
        .therapist:"Терапевт",.neuropathologist:"Невропатолог",.traumatologist:"Травматолог"]
    
    var alert:MedicalAlert?

    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("title_NewDoctor", comment: "")
        saveButton.title = NSLocalizedString("buttonSave", comment: "")
        firstNameTextField.placeholder = NSLocalizedString("placeholder_FirstName", comment: "")
        lastNameTextField.placeholder = NSLocalizedString("placeholder_LastName", comment: "")
        clinicTextField.placeholder = NSLocalizedString("placeholder_Job", comment: "")
        numberPhoneTextField.placeholder = NSLocalizedString("placeholder_PhoneNumber", comment: "")
        specializationLabel.text = NSLocalizedString("specialization_Label", comment: "")
        firstNameTextField.text = firstName
        lastNameTextField.text = lastName
        clinicTextField.text = clinic
        numberPhoneTextField.text = phoneNumber
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        professionLabel.text = professionTitles[profession]
    }
    
    //MARK: Other function
    func validatedPhoneNumber(phoneStr:String) -> Bool {
        let phonePattern = #"^\(?\d{3}\)?[ -]?\d{3}[ -]?\d{4}$"#
        let result = phoneStr.range(
            of: phonePattern,
            options: .regularExpression)
        let validPhoneNumber = (result != nil)
        return validPhoneNumber
    }
    
    func fieldIsEmpty() -> Bool{
        if firstNameTextField.text == "" || lastNameTextField.text == "" || clinicTextField.text == "" {
            return true
        } else{
            return false
        }
    }
    
    //MARK: IBAction
    @IBAction func saveNewDoctor(_ sender:UIBarButtonItem){
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let clinic = clinicTextField.text ?? ""
        let numberPhone = numberPhoneTextField.text ?? ""
        if fieldIsEmpty(){
            showAlertFieldISEmpty()
        } else {
            if validatedPhoneNumber(phoneStr: numberPhone) == true {
                doAfterCreate?(firstName,lastName,clinic,numberPhone,profession.rawValue)
                navigationController?.popViewController(animated: true)
            } else {
                showAlertPhoneNumberValidation()
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("table_Header", comment: "")
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfesionDescription"{
            let destination = segue.destination as! DoctorsProfessionsController
            destination.selectedProfession = profession
            destination.doAfterSelected = {
                [self] selectedProfession in
                self.profession = selectedProfession
                self.professionLabel.text = profession.rawValue
            }
        }
    }
    
    //MARK: AlertControllers
    func showAlertPhoneNumberValidation(){
        alert = MedicalAlert()
        alert?.showAlert(title: "Некорректный номер телефона", message: "Введите номер телефона в формате 0991234567", viewController: self)
    }
    
    func showAlertFieldISEmpty(){
        alert = MedicalAlert()
        alert?.showAlert(title: "Не заполнены поля", message: "Заполните пожалуйста все поля, что бы можно было корректно сохранить информацию", viewController: self)
    }
}
