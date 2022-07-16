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
    
    var headerViewButtons:[UIButton] = []
    var canAddButton:Bool = true

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
        navigationItem.title = NSLocalizedString("navigation_title_PillsTable", comment: "")
        headerViewButtons = getButtonsForHeaderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coursesOfMedicament = getArrayOfCourses()
        tableView.reloadData()
    }
    
    //MARK: Other function
    func sortForSectionOfDay(arrayOfMedicament:[NSManagedObject]) -> [PeriodOfTheDay:[CourseOfMedicament]]{
        var sortedArray:[PeriodOfTheDay:[CourseOfMedicament]] = [:]
        sectionOfDay.forEach { section in
            sortedArray[section] = []
        }
        
        arrayOfMedicament.forEach { course  in
            let courseOfMedicament = course as! CourseOfMedicament
            switch courseOfMedicament.sectionEnum{
            case .morning:
                sortedArray[.morning]?.append(courseOfMedicament)
            case .dinner:
                sortedArray[.dinner]?.append(courseOfMedicament)
            case .evening:
                sortedArray[.evening]?.append(courseOfMedicament)
            }
        }
        return sortedArray
    }
    
    private func getButtonsForHeaderView() -> [UIButton]{
        var buttons:[UIButton] = []
        sectionOfDay.forEach { _ in
            let button = UIButton(frame: CGRect(x: view.frame.width - 140, y: 5, width: 100, height: 40))
            button.setTitle(NSLocalizedString("Выпить все", comment: ""), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 10
            button.layer.backgroundColor = UIColor.systemOrange.cgColor
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            buttons.append(button)
        }
        return buttons
    }
    
    private func drinkAllMedicamentnInSection(courses:[CourseOfMedicament]){
        for course in courses {
            changeItsDrunkWithFlag(course: course)
        }
        
    }
    
    @objc
    func buttonTapped(button:UIButton){
        for (btnIndex,btn) in headerViewButtons.enumerated(){
            if btn == button{
                let currentSection = sectionOfDay[btnIndex]
                guard let courses = pills[currentSection] else {
                    return
                }
                drinkAllMedicamentnInSection(courses: courses)
                tableView.reloadSections(IndexSet(arrayLiteral: btnIndex), with: .automatic)
                button.setTitle(NSLocalizedString("Выпито", comment: ""), for: .normal)
            }
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
        let fragmentDay = sectionOfDay[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PillsCell") as! PillsTableViewCell
        
        let courseOfMedicament = pills[fragmentDay]?[indexPath.row]
        print("\(courseOfMedicament?.medicament?.title)  \(courseOfMedicament?.medicament?.amountLeftInCourse)")
        if courseOfMedicament!.statusEnum == .itsDrunk{
            let imageView = UIImageView(image: UIImage(systemName: "checkmark"))
            imageView.tintColor = .systemGreen
            cell.accessoryView = imageView
        }
        if courseOfMedicament!.statusEnum == .forgotten{
            let imageView = UIImageView(image: UIImage(systemName: "xmark"))
            imageView.tintColor = .systemRed
            cell.accessoryView = imageView
        }
        cell.setupCell(medicament: courseOfMedicament!.medicament!)
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        var title:String?
        switch sectionOfDay[section]{
        case .morning:
            title = NSLocalizedString("section_morning", comment: "")
        case .dinner:
            title = NSLocalizedString("section_dinner", comment: "")
        case .evening:
            title = NSLocalizedString("section_evenning", comment: "")
        }
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100 , height: 50))
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 25)
        headerView.addSubview(titleLabel)
        let button = headerViewButtons[section]
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
            let course = pills[selectSectionDay]?[indexPath.row]
            if changeItsDrunkWithFlag(course: course!){
                let medicamentTitle = (course?.medicament?.title)! as String
                let medicament = (course?.medicament)! as Medicament
                deleteAllCoursesThatHaveThisMedicament(medicament: course!.medicament!)
                medicament.isTaken = false
                medicament.isOver = true
                saveChange()
                let alert = NewMedicalAlert()
                alert.showAlert(title: "Вы закончили курс", message: "Вы закончили курс препарата \(medicamentTitle)")
                coursesOfMedicament = getArrayOfCourses()
                tableView.reloadData()
            } else {
                tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
            }
            
        }
        actionSwipeEdit.backgroundColor = .systemIndigo
        return UISwipeActionsConfiguration(actions: [actionSwipeEdit])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionSwipeDelete = UIContextualAction(style: .normal, title: "Забыли выпить") { [self] _, _, _ in
            let currentSection = sectionOfDay[indexPath.section]
            let course = pills[currentSection]?[indexPath.row]
            headerViewButtons[indexPath.section].setTitle("Выпить все", for: .normal)
            changeItsForgotten(course: course!)
            tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        }
        actionSwipeDelete.backgroundColor = .systemGray
        return UISwipeActionsConfiguration(actions: [actionSwipeDelete])
    }
}
