//
//  DoctorsListController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 27.05.2022.
//

import UIKit
import CoreData

class DoctorsListController: UIViewController {
    
    var doctors:[NSManagedObject] = []
    var doAfterSelected:((Doctor) -> Void)?
    
    var floatButton:RedButton = {
        let button = RedButton()
        return button
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addBarButtonTapped(_ sender: UIBarButtonItem) {
        createNewDoctorController()
    }
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let cellNib = UINib(nibName: "DoctorPrototypeCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "DoctorPrototypeCell")
        floatButton.addTarget(self, action: #selector(floatButtonTapped), for: .touchUpInside)
        view.addSubview(floatButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Doctor")
        do{
            doctors = try managedContext.fetch(fetchRequest)
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
        createNewDoctorController()
    }
}

extension DoctorsListController:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return doctors.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorPrototypeCell", for: indexPath) as! DoctorPrototypeCell
        let currentDoctor = doctors[indexPath.row] as! Doctor
        cell.setupCell(doctor: currentDoctor)
        return cell
    }

}

extension DoctorsListController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDoctor = doctors[indexPath.row] as! Doctor
        doAfterSelected?(selectedDoctor)
        navigationController?.popViewController(animated: true)
    }
}
