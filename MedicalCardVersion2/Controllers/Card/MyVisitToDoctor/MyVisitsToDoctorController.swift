//
//  MyVisitsToDoctorController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 27.05.2022.
//

import UIKit
import CoreData

class MyVisitsToDoctorController: UIViewController {
    
    let headerViewHeight:CGFloat = 50
    let calendar = Calendar(identifier: .gregorian)
    
    var visits:[NSManagedObject] = [] {
        didSet{
            sortedVisits = sortedVisitsBySection(visits)
        }
    }
    let sections:[SectionOfMonth] = [.today,.yesterday,.thisWeek,.thisMonth,.earlier]
    var sortedVisits:[SectionOfMonth:[NSManagedObject]] = [:]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addBurButtonTapped(_ sender: UIBarButtonItem) {
        createNewVisit()
    }
    var alert:NewMedicalAlert?
    var floatButton:RedButton! = {
        let button = RedButton()
        return button
    }()
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("navigation_title_MyVisits", comment: "")
        tableView.dataSource = self
        tableView.delegate = self
        let cellNib = UINib(nibName: "VisitCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "VisitCell")
        let notDataCellNIB = UINib(nibName: "NotDataCell", bundle: nil)
        tableView.register(notDataCellNIB, forCellReuseIdentifier: "NotDataCell")
        view.addSubview(floatButton)
        floatButton.addTarget(self, action: #selector(floatButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "VisitToDoctor")
        do{
            visits = try managedContext.fetch(fetchRequest)
            sortedVisits = sortedVisitsBySection(visits)
            tableView.reloadData()
        } catch let error as NSError{
            print("Could not save.\(error),\(error.userInfo)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatButton.frame = CGRect(x: view.frame.width - 90, y: view.frame.height - view.frame.height * 0.2, width: 70, height: 70)
    }
    //MARK: Other function
    @objc
    func floatButtonTapped(){
        createNewVisit()
    }
    
    private func sortedVisitsBySection(_ originVisits:[NSManagedObject]) -> [SectionOfMonth:[VisitToDoctor]]{
        var sortedArray:[SectionOfMonth:[VisitToDoctor]] = [:]
        sections.forEach { section in
            sortedArray[section] = []
        }
        
        for visit in originVisits {
            let visitToSort = visit as! VisitToDoctor
            switch whichSectionThisDate(date: visitToSort.date!){
            case .today:
                sortedArray[.today]?.append(visitToSort)
            case .yesterday:
                sortedArray[.yesterday]?.append(visitToSort)
            case .thisWeek:
                sortedArray[.thisWeek]?.append(visitToSort)
            case .thisMonth:
                sortedArray[.thisMonth]?.append(visitToSort)
            case .earlier:
                sortedArray[.earlier]?.append(visitToSort)
            }
        }
        return sortedArray
    }
    
    private func whichSectionThisDate(date:Date) -> SectionOfMonth{
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: today)
        let monthAgo = calendar.date(byAdding: .month, value: -1, to: today)
        if calendar.isDateInToday(date){
            return .today
        } else if calendar.isDateInYesterday(date){
            return .yesterday
        } else if date > weekAgo! && date < yesterday!{
            return .thisWeek
        } else if date > monthAgo! && date < weekAgo! {
            return .thisMonth
        } else {
            return .earlier
        }
    }
}
//MARK: TableView DataSource
extension MyVisitsToDoctorController:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionOfMonth = sections[section]
        guard let currentArray = sortedVisits[sectionOfMonth] else {
            return 1
        }
        return currentArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerViewHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title:String?
        switch sections[section]{
        case .today:
            title = NSLocalizedString("sectionOfMonth_today", comment: "")
        case .yesterday:
            title = NSLocalizedString("sectionOfMonth_yesterday", comment: "")
        case .thisWeek:
            title = NSLocalizedString("sectionOfMonth_thisWeek", comment: "")
        case  .thisMonth:
            title = NSLocalizedString("sectionOfMonth_thisMonth", comment: "")
        default:
            title = NSLocalizedString("sectionOfMonth_earlie", comment: "")
        }
        let headerView = UIView()
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 40 , height: headerViewHeight))
        titleLabel.text = title
        titleLabel.textColor = .darkGray
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 25,weight: .light)
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionOfMonth = sections[indexPath.section]
        let currentVisit = sortedVisits[sectionOfMonth]?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "VisitCell") as! VisitCell
        cell.setupCell(visit: currentVisit as! VisitToDoctor)
        return cell
    }
}

//MARK: TableViewDelegate
extension MyVisitsToDoctorController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentVisit = visits[indexPath.row] as! VisitToDoctor
        editVisit(visit: currentVisit)
    }
}
