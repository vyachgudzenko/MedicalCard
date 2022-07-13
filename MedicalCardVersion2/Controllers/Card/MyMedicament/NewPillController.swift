//
//  NewPillController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 04.05.2022.
//
//MARK: контроллер для создания нового медикамента
import UIKit

class NewPillController: UITableViewController {
    
    var popOver:PopOverController?
    
    var alert:NewMedicalAlert?
    var medicament:Medicament?
    var isNewMedicament:Bool = true
    var doctor:Doctor?
    var visitUUID:String?
    
    
    var isTaken:Bool = false
    var isOver:Bool = false
    var medicamentName = ""
    var medicamentDosage:String = "0"
    var medicamentType:TypeOfMedicament = .pill
    var medicamentFrequency:Frequency = .twiceADay
    
    var navigationTitle:String = NSLocalizedString("navigation_title_NewMedicament", comment: "")
    
    private var titlesType:[TypeOfMedicament:String] = [
        .pill:"Таблетки",
        .injection:"Уколы",
        .syrup:"Cироп"]
    
    private var titlesFrequency:[Frequency:String] = [
        .onceADay:"Один раз",
        .twiceADay:"Дважды",
        .threeTimeADay:"Трижды"]
    
    var doAfterEdit:((String,String,String,String,Doctor?,String?,Bool,Bool) -> Void)?
    
    @IBOutlet weak var medicamentNameTextField: UITextField!
    @IBOutlet weak var medicamentDosageTextField: UITextField!
    @IBOutlet weak var medicamentFrequencyLabel: UILabel!
    @IBOutlet weak var medicamentTypeLabel: UILabel!
    @IBOutlet weak var doctorLabel: UILabel!
    @IBOutlet weak var startDatePiecker: UIDatePicker!
    @IBOutlet weak var isOverSwitch: UISwitch!
    @IBOutlet weak var countOfDayTextField: UITextField!
    
    @IBOutlet weak var countOfDayLabel: UILabel!
    @IBOutlet weak var freguencyLocalization: UILabel!
    @IBOutlet weak var startDateLocalization: UILabel!
    @IBOutlet weak var doctorLocalization: UILabel!
    @IBOutlet weak var typeMedicamentLocalization: UILabel!
    @IBOutlet weak var courseIsOverLabel: UILabel!
    
    @IBAction func isOverChanged(_ sender: UISwitch) {
        if isNewMedicament{
            alert = NewMedicalAlert()
            alert!.showAlert(title: NSLocalizedString("alert_title_NotAddedMedicament", comment: ""), message: NSLocalizedString("alert_message_NotAddedMedicament", comment: ""))
            isOverSwitch.setOn(false, animated: true)
            }
        if isTaken == false && isNewMedicament == false {
            alert = NewMedicalAlert()
            alert!.showAlert(title: NSLocalizedString("alert_title_MedicamentIsNotInCourse", comment: ""), message: NSLocalizedString("alert_message_MedicamentIsNotInCourse", comment: ""))
            isOverSwitch.setOn(false, animated: true)
        }
        if medicament != nil && isTaken == true{
            deleteAllCoursesThatHaveThisMedicament(medicament: medicament!)
            isOver = true
            isTaken = false
            alert = NewMedicalAlert()
            alert?.showAlert(title: NSLocalizedString("alert_title_CourseIsOver", comment: "") + "\(medicamentName)", message: NSLocalizedString("alert_message_CourseIsOver", comment: ""))
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
        navigationItem.title = navigationTitle
        medicamentNameTextField.text = medicamentName
        medicamentNameTextField.placeholder = NSLocalizedString("medicamentNamePlaceholder_NewMedicament", comment: "")
        medicamentDosageTextField.text = medicamentDosage
        medicamentDosageTextField.placeholder = NSLocalizedString("medicamentDosagePlaceholder_NewMedicament", comment: "")
        medicamentTypeLabel.text = titlesType[medicamentType]
        medicamentFrequencyLabel.text = titlesFrequency[medicamentFrequency]
        doctorLabel.text = doctor?.getFullName() ?? NSLocalizedString("doctor_Unknown", comment: "")
        isOverSwitch.isOn = isOver
        countOfDayLabel.text = NSLocalizedString("countOfDay_NewMedicament", comment: "")
        freguencyLocalization.text = NSLocalizedString("freguencyLabel_NewMedicament", comment: "")
        typeMedicamentLocalization.text = NSLocalizedString("typeOfMedicament_NewMedicament", comment: "")
        doctorLocalization.text = NSLocalizedString("doctor_NewMedicament", comment: "")
        startDateLocalization.text = NSLocalizedString("startDate_NewMedicament", comment: "")
        courseIsOverLabel.text = NSLocalizedString("courseIsOver_NewMedicament", comment: "")
        
        
    }
    
    //MARK: Other function
    private func saveThisMedicament(){
        let title = medicamentNameTextField.text ?? ""
        let dosage = medicamentDosageTextField.text ?? "0"
        let type = medicamentType
        let frequency = medicamentFrequency
        doAfterEdit?(title,dosage,type.rawValue,frequency.rawValue,doctor,visitUUID,isTaken,isOver)
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
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromNewPillToDoctorList"{
            let destination = segue.destination as! DoctorsListController
            destination.doAfterSelected = {
                [self] selectedDoctor in
                self.doctor = selectedDoctor
                self.doctorLabel.text = selectedDoctor.getFullName()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 3:
            popOver = PopOverController()
            popOver?.delegate = self
            popOver?.setupPopOver(cellType: .medicamentFraquency)
            popOver?.showPopOver(fraquency: medicamentFrequency)
            didCellSelected(popOver!)
        case 4:
            popOver = PopOverController()
            popOver?.delegate = self
            popOver?.setupPopOver(cellType: .medicamentType)
            popOver?.showPopOver(type: medicamentType)
            didCellSelected(popOver!)
        
        default:break
            
        }
    }
}

extension NewPillController:PopOverDelegate{
    func didCellSelected(_ popOver: PopOverController) {
        switch popOver.cellType{
        case .medicamentType:
            medicamentType = popOver.selectedType!
            medicamentTypeLabel.text = titlesType[medicamentType]
        case .medicamentFraquency:
            medicamentFrequency = popOver.selectedFraquency!
            medicamentFrequencyLabel.text = titlesFrequency[medicamentFrequency]
        }
    }
    
    
}
