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

    var visitUUID:String?
    
    let sectionOfDay:[PeriodOfTheDay] = [.morning,.dinner,.evening]
    let professionList:[String] = [
        "Терапевт","Травматолог","Невропатолог"]
    var pills:[PeriodOfTheDay:[CourseOfMedicament]] = [:]
    var coursesOfMedicament:[NSManagedObject] = []{
        didSet{
            pills = sortForSectionOfDay(arrayOfMedicament: coursesOfMedicament)
        }
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CourseOfMedicament")
        do{
            coursesOfMedicament = try managedContext.fetch(fetchRequest)
            pills = sortForSectionOfDay(arrayOfMedicament: coursesOfMedicament)
            tableView.reloadData()
        } catch let error as NSError{
            print("Could not save.\(error),\(error.userInfo)")
        }
    }
    
    //MARK: Other function
    func sortForSectionOfDay(arrayOfMedicament:[NSManagedObject]) -> [PeriodOfTheDay:[CourseOfMedicament]]{
        var sortedArray:[PeriodOfTheDay:[CourseOfMedicament]] = [:]
        sectionOfDay.forEach { section in
            sortedArray[section] = []
        }
        
        arrayOfMedicament.forEach { course  in
            let courseOfMedicament = course as! CourseOfMedicament
            switch courseOfMedicament.section{
            case "morning":
                sortedArray[.morning]?.append(courseOfMedicament)
            case "dinner":
                sortedArray[.dinner]?.append(courseOfMedicament)
            case "evening":
                sortedArray[.evening]?.append(courseOfMedicament)
            default: break
            }
        }
        return sortedArray
    }
    
    @objc
    func headerViewButtonTapped(){
        
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
        let courseOfMedicament = pills[fragmentDay]?[indexPath.row] as! CourseOfMedicament
        if courseOfMedicament.itsDrunk == true{
            cell.accessoryType = .checkmark
        }
        cell.setupCell(medicament: courseOfMedicament.medicament!)
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        var title:String?
        switch sectionOfDay[section]{
        case .morning:
            title = "Утро"
        case .dinner:
            title = "Обед"
        case .evening:
            title = "Ужин"
        }
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100 , height: 50))
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 25)
        headerView.addSubview(titleLabel)
        let button = UIButton(type: .system)
        button.frame = CGRect(x: view.frame.width - 140, y: 5, width: 100, height: 40)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.backgroundColor = UIColor.systemOrange.cgColor
        button.setTitle("Выпито все", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(headerViewButtonTapped), for: .touchUpInside)
        headerView.addSubview(button)
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    //MARK: TableViewDelegate
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionSwipeEdit = UIContextualAction(style: .normal, title: "Принято") { [self] _, _, _ in
            let selectSectionDay = sectionOfDay[indexPath.section]
            let course = pills[selectSectionDay]?[indexPath.row] as! CourseOfMedicament
            changeItsDrunk(course: course)
            tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        }
        actionSwipeEdit.backgroundColor = .systemIndigo
        return UISwipeActionsConfiguration(actions: [actionSwipeEdit])
    }
    
    /*override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let currentSection = sectionOfDay[indexPath.section]
        let actionSwipeDelete = UIContextualAction(style: .normal, title: "Удалить") { [self] _, _, _ in
            deleteMedicament(medicament: coursesOfMedicament[indexPath.row] as! Medicament)
            coursesOfMedicament.remove(at: indexPath.row)
            tableView.reloadData()
        }
        actionSwipeDelete.backgroundColor = .systemGray
        return UISwipeActionsConfiguration(actions: [actionSwipeDelete])
    }*/
    
    /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentSection = sectionOfDay[indexPath.section]
        let editScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewPillController") as! NewPillController
        let currentMedicament = pills[currentSection]?[indexPath.row].0
        editScreen.navigationItem.title = currentMedicament?.title
        editScreen.medicamentName = currentMedicament!.title!
        editScreen.medicamentDosage = currentMedicament!.dosage!
        editScreen.medicamentType = currentMedicament!.type!
        editScreen.medicamentFrequency = currentMedicament!.frequency!
        editScreen.doAfterEdit = { [self] title,dosage,type,frequency,doctor,visitUUID in
            
            coursesOfMedicament[indexPath.row].setValue(title, forKey: "title")
            coursesOfMedicament[indexPath.row].setValue(dosage, forKey: "dosage")
            coursesOfMedicament[indexPath.row].setValue(type, forKey: "type")
            coursesOfMedicament[indexPath.row].setValue(frequency, forKey: "frequency")
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
    }*/
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewPillScreen"{
            let destination = segue.destination as! NewPillController
            destination.doAfterEdit = {
                [self] title,dosage,type,frequency,doctor,visitUUID in
                saveNewMedicament(title: title, dosage: dosage, type: type, frequency: frequency, doctor: doctor,visitUUID: visitUUID)
                tableView.reloadData()
                }
            }
        }
}
