//
//  PillsTableViewController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 04.05.2022.
//
//MARK: основной контроллер для таблеток
import UIKit
import CoreData

class PillsTableViewController: UITableViewController {

    let sectionOfDay:[PeriodOfTheDay] = [.morning,.dinner,.evening]
    let professionList:[String] = [
        "Терапевт","Травматолог","Невропатолог"]
    var pills:[PeriodOfTheDay:[(Medicament,Bool)]] = [:]
    var originalPill:[NSManagedObject] = []{
        didSet{
            pills = sortForSectionOfDay(arrayOfMedicament: originalPill)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Medicament")
        do{
            originalPill = try managedContext.fetch(fetchRequest)
            pills = sortForSectionOfDay(arrayOfMedicament: originalPill)
            tableView.reloadData()
        } catch let error as NSError{
            print("Could not save.\(error),\(error.userInfo)")
        }
    }
    
    
    func sortForSectionOfDay(arrayOfMedicament:[NSManagedObject]) -> [PeriodOfTheDay:[(Medicament,Bool)]]{
        var sortedArray:[PeriodOfTheDay:[(medicament:Medicament,isDrunk:Bool)]] = [:]
        let sectionOfDay:[PeriodOfTheDay] = [.morning,.dinner,.evening]
        sectionOfDay.forEach { section in
            sortedArray[section] = []
        }
        arrayOfMedicament.forEach { medicament  in
            let sortedMedicament = medicament as! Medicament
            switch sortedMedicament.frequency{
            case "onceADay":
                let tuple = (medicament as! Medicament,false)
                sortedArray[.morning]?.append(tuple)
            case "twiceADay":
                let tuple = (medicament as! Medicament,false)
                sortedArray[.morning]?.append(tuple)
                sortedArray[.evening]?.append(tuple)
            case "threeTimeADay":
                let tuple = (medicament as! Medicament,false)
                sortedArray[.morning]?.append(tuple)
                sortedArray[.dinner]?.append(tuple)
                sortedArray[.evening]?.append(tuple)
            default: break
            }
        }
        return sortedArray
    }
    
    //MARK: Навигация
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewPillScreen"{
            let destination = segue.destination as! NewPillController
            destination.doAfterEdit = {
                [self] title,dosage,type,frequency in
                saveNewMedicament(title: title, dosage: dosage, type: type, frequency: frequency)
                tableView.reloadData()
                }
            }
        }
    
    func saveNewMedicament(title:String,dosage:String,type:String,frequency:String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Medicament", in: managedContext)!
        let newMedicament = NSManagedObject(entity: entity, insertInto: managedContext)
        newMedicament.setValue(title, forKey: "title")
        newMedicament.setValue(dosage, forKey: "dosage")
        newMedicament.setValue(type, forKey: "type")
        newMedicament.setValue(frequency, forKey: "frequency")
        do{
            try managedContext.save()
            originalPill.append(newMedicament)
        } catch let error as NSError{
            print("Could not save.\(error),\(error.userInfo)")
        }
        
    }
    
    
    //MARK: TableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionOfDay.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionDay = sectionOfDay[section]
        guard let currentMedicamentArray = pills[sectionDay] else {return 0}
        return currentMedicamentArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PillsCell") as! PillsTableViewCell
        let fragmentDay = sectionOfDay[indexPath.section]
        guard let currentMedicamentTuple = pills[fragmentDay]?[indexPath.row] else {
            return cell
        }
        if currentMedicamentTuple.1 == true{
            cell.accessoryType = .checkmark
        }
        cell.titleLabel.text = currentMedicamentTuple.0.title
        cell.dosageLabel.text = currentMedicamentTuple.0.dosage
        cell.pic.image = getCurrentImageForPillsList(medicament: currentMedicamentTuple.0)
        return cell
    }
    
    func getCurrentImageForPillsList(medicament:Medicament) -> UIImage{
        switch medicament.type{
        case "injection":
            return UIImage(named: "injection.png")!
        case "pill":
            return UIImage(named: "pill (1).png")!
        case "syrup":
            return UIImage(named: "cough-syrup.png")!
        default:
            return UIImage(named: "pill (1).png")!
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title:String?
        switch sectionOfDay[section]{
        case .morning:
            title = "Утро"
        case .dinner:
            title = "Обед"
        case .evening:
            title = "Ужин"
        }
        return title
    }
    
    //MARK: TableViewDelegate
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionSwipeEdit = UIContextualAction(style: .normal, title: "Принято") { [self] _, _, _ in
            let selectSectionDay = sectionOfDay[indexPath.section]
            pills[selectSectionDay]?[indexPath.row].1 = true
            tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        }
        actionSwipeEdit.backgroundColor = .systemIndigo
        return UISwipeActionsConfiguration(actions: [actionSwipeEdit])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let currentSection = sectionOfDay[indexPath.section]
        let actionSwipeDelete = UIContextualAction(style: .normal, title: "Удалить") { [self] _, _, _ in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(originalPill[indexPath.row])
            do{
                try managedContext.save()
                originalPill.remove(at: indexPath.row)
                //pills = sortForSectionOfDay(arrayOfMedicament: originalPill)
                tableView.reloadData()
            } catch let error as NSError{
                print("Could not save.\(error),\(error.userInfo)")
            }
        }
        actionSwipeDelete.backgroundColor = .systemGray
        return UISwipeActionsConfiguration(actions: [actionSwipeDelete])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentSection = sectionOfDay[indexPath.section]
        let editScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewPillController") as! NewPillController
        let currentMedicament = pills[currentSection]?[indexPath.row].0
        editScreen.navigationItem.title = currentMedicament?.title
        editScreen.medicamentName = currentMedicament!.title!
        editScreen.medicamentDosage = currentMedicament!.dosage!
        editScreen.medicamentType = currentMedicament!.type!
        editScreen.medicamentFrequency = currentMedicament!.frequency!
        editScreen.doAfterEdit = { [self] title,dosage,type,frequency in
            
            originalPill[indexPath.row].setValue(title, forKey: "title")
            originalPill[indexPath.row].setValue(dosage, forKey: "dosage")
            originalPill[indexPath.row].setValue(type, forKey: "type")
            originalPill[indexPath.row].setValue(frequency, forKey: "frequency")
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            do{
                try managedContext.save()
                tableView.reloadData()
            } catch let error as NSError{
                print("Could not save.\(error),\(error.userInfo)")
            }
        }
        self.navigationController?.pushViewController(editScreen, animated: true)
    }
}
