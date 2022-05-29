//
//  NewPillController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 04.05.2022.
//
//MARK: контроллер для создания нового медикамента
import UIKit

class NewPillController: UITableViewController {
    
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
    
    var doAfterEdit:((String,String,String,String) -> Void)?
    
    @IBOutlet weak var medicamentNameTextField: UITextField!
    @IBOutlet weak var medicamentDosageTextField: UITextField!
    @IBOutlet weak var medicamentFrequencyLabel: UILabel!
    @IBOutlet weak var medicamentTypeLabel: UILabel!
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        medicamentNameTextField.text = medicamentName
        medicamentDosageTextField.text = medicamentDosage
        medicamentTypeLabel.text = titlesType[medicamentType]
        medicamentFrequencyLabel.text = titlesFrequency[medicamentFrequency]
    }
    
    //MARK: @IBAction
    @IBAction func saveNewMedicament(_ sender:UIBarButtonItem){
        let title = medicamentNameTextField.text ?? ""
        let dosage = medicamentDosageTextField.text ?? "0"
        let type = medicamentType
        let frequency = medicamentFrequency
        doAfterEdit?(title,dosage,type,frequency)
        navigationController?.popViewController(animated: true)
    
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
    }
}
