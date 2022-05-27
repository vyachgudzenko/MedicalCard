//
//  NewDoctorController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 08.05.2022.
//

import UIKit

class NewDoctorController: UITableViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var clinicTextField: UITextField!
    @IBOutlet weak var numberPhoneTextField: UITextField!
    @IBOutlet weak var professionLabel: UILabel!
    
    var firstName:String = ""
    var lastName:String = ""
    var clinic:String = ""
    var phoneNumber:String = ""
    var profession:String = "Терапевт"
    
    var doAfterCreate:((String,String,String,String,String) ->Void)?
    
    var professionTitles:[String] = [
        "Терапевт","Невропатолог","Травматолог"]

    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.text = firstName
        lastNameTextField.text = lastName
        clinicTextField.text = clinic
        numberPhoneTextField.text = phoneNumber
        professionLabel.text = profession
    }
    
    @IBAction func saveNewDoctor(_ sender:UIBarButtonItem){
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let clinic = clinicTextField.text ?? ""
        let numberPhone = numberPhoneTextField.text ?? ""
        if validatedPhoneNumber(phoneStr: numberPhone) == true {
            doAfterCreate?(firstName,lastName,clinic,numberPhone,profession)
            navigationController?.popViewController(animated: true)
        } else {
            showAlert()
        }
        
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfesionDescription"{
            let destination = segue.destination as! DoctorsProfessionsController
            destination.selectedProfession = profession
            destination.doAfterSelected = {
                [self] selectedProfession in
                self.profession = selectedProfession
                self.professionLabel.text = profession
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    //MARK: Дополнительные функции
    func validatedPhoneNumber(phoneStr:String) -> Bool {
        let phonePattern = #"^\(?\d{3}\)?[ -]?\d{3}[ -]?\d{4}$"#
        let result = phoneStr.range(
            of: phonePattern,
            options: .regularExpression)
        let validPhoneNumber = (result != nil)
        return validPhoneNumber
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Не правильно введен номер телефона", message: "Введите номер телефона в формате 0991234567", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
}
