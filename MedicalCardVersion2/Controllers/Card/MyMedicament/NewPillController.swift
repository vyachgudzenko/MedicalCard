//
//  NewPillController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 04.05.2022.
//
//MARK: контроллер для создания нового медикамента
import UIKit

class NewPillController: UITableViewController {
    
    var alert:MedicalAlert?
    var medicament:Medicament?
    var isNewMedicament:Bool = true
    var doctor:Doctor?
    var visitUUID:String?
    
    
    var isTaken:Bool = false
    var isOver:Bool = false
    var medicamentName = ""
    var medicamentDosage:String = "0"
    var medicamentType:String = "pill"
    var medicamentFrequency:String = "twiceADay"
    
    private var titlesType:[String:String] = [
        "pill":"Таблетки",
        "injection":"Уколы",
        "syrup":"Cироп"]
    
    private var titlesFrequency:[String:String] = [
        "onceADay":"Один раз",
        "twiceADay":"Дважды",
        "threeTimeADay":"Трижды"]
    
    var doAfterEdit:((String,String,String,String,Doctor?,String?,Bool,Bool) -> Void)?
    
    @IBOutlet weak var medicamentNameTextField: UITextField!
    @IBOutlet weak var medicamentDosageTextField: UITextField!
    @IBOutlet weak var medicamentFrequencyLabel: UILabel!
    @IBOutlet weak var medicamentTypeLabel: UILabel!
    @IBOutlet weak var doctorLabel: UILabel!
    @IBOutlet weak var startDatePiecker: UIDatePicker!
    @IBOutlet weak var isOverSwitch: UISwitch!
    
    @IBAction func isOverChanged(_ sender: UISwitch) {
        if isNewMedicament{
            alert = MedicalAlert()
            alert!.showAlert(title: "Не добавлен медикамент", message: "Вы не сможете закончить курс, пока не сохраните препарат", viewController: self)
            isOverSwitch.setOn(false, animated: true)
            }
        if isTaken == false && isNewMedicament == false {
            alert = MedicalAlert()
            alert!.showAlert(title: "Препарат не принимается", message: "На данный момент Вы не принимаете этот препарат и не можете закончить курс", viewController: self)
            isOverSwitch.setOn(false, animated: true)
        }
        if medicament != nil && isTaken == true{
            deleteAllCoursesThatHaveThisMedicament(medicament: medicament!)
            isOver = true
            isTaken = false
            alert = MedicalAlert()
            alert?.showAlert(title: "Вы закончили курс \(medicamentName)", message: "Не забудьте сохранить изменения, нажав кнопку Сохранить", viewController: self)
        }
    }
    
    //MARK: @IBAction
    @IBAction func saveNewMedicament(_ sender:UIBarButtonItem){
        saveThisMedicament()
        navigationController?.popViewController(animated: true)
    }
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        medicamentNameTextField.text = medicamentName
        medicamentDosageTextField.text = medicamentDosage
        medicamentTypeLabel.text = titlesType[medicamentType]
        medicamentFrequencyLabel.text = titlesFrequency[medicamentFrequency]
        doctorLabel.text = doctor?.getFullName() ?? "Выберите врача"
        isOverSwitch.isOn = isOver
    }
    
    //MARK: Other function
    private func saveThisMedicament(){
        let title = medicamentNameTextField.text ?? ""
        let dosage = medicamentDosageTextField.text ?? "0"
        let type = medicamentType
        let frequency = medicamentFrequency
        doAfterEdit?(title,dosage,type,frequency,doctor,visitUUID,isTaken,isOver)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toTypeScreen"{
            let destination = segue.destination as! PillsTypeTableViewController
            destination.selectedType = medicamentType
            destination.doAfterTypeSelected = { [self] selectedType in
                self.medicamentType = selectedType
                self.medicamentTypeLabel?.text = self.titlesType[medicamentType]
            }
        }
        if segue.identifier ==  "toFrequencyScreen"{
            let destination = segue.destination as! PillsFrequencyController
            destination.selectedFraquency = medicamentFrequency
            destination.doAfterFrequencySelected = { [self] selectedFraquency in
                self.medicamentFrequency = selectedFraquency
                self.medicamentFrequencyLabel?.text = titlesFrequency[medicamentFrequency]
            }
        }
        if segue.identifier == "fromNewPillToDoctorList"{
            let destination = segue.destination as! DoctorsListController
            destination.doAfterSelected = {
                [self] selectedDoctor in
                self.doctor = selectedDoctor
                self.doctorLabel.text = selectedDoctor.getFullName()
            }
        }
    }
}
