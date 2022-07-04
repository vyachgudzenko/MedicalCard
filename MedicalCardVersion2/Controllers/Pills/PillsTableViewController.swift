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
        let fragmentDay = sectionOfDay[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PillsCell") as! PillsTableViewCell
        
        let courseOfMedicament = pills[fragmentDay]?[indexPath.row] as! CourseOfMedicament
        if courseOfMedicament.status == "itsDrunk"{
            let imageView = UIImageView(image: UIImage(systemName: "checkmark"))
            imageView.tintColor = .systemGreen
            cell.accessoryView = imageView
        }
        if courseOfMedicament.status == "forgotten"{
            let imageView = UIImageView(image: UIImage(systemName: "xmark"))
            imageView.tintColor = .systemRed
            cell.accessoryView = imageView
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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionSwipeDelete = UIContextualAction(style: .normal, title: "Забыли выпить") { [self] _, _, _ in
            let currentSection = sectionOfDay[indexPath.section]
            let course = pills[currentSection]?[indexPath.row]
            changeItsForgotten(course: course!)
            tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        }
        actionSwipeDelete.backgroundColor = .systemGray
        return UISwipeActionsConfiguration(actions: [actionSwipeDelete])
    }
}
