//
//  MedicamentListController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 30.06.2022.
//

import UIKit
import CoreData
class MedicamentListController: UIViewController {

    var medicaments:[NSManagedObject] = []
    var visitUUID:UUID?
    
    var floatButton:RedButton! = {
        let button = RedButton()
        return button
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addBarButtonTapped(_ sender: UIBarButtonItem) {
        createNewMedicament(visitUUID: visitUUID?.uuidString)
    }
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let cellNIB  = UINib(nibName: "MedicamentCell", bundle: nil)
        tableView.register(cellNIB, forCellReuseIdentifier: "MedicamentCell")
        view.addSubview(floatButton)
        floatButton.addTarget(self, action: #selector(floatButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Medicament>
        fetchRequest = Medicament.fetchRequest()
        guard let uuidString = visitUUID?.uuidString else {
            return
        }
        fetchRequest.predicate = NSPredicate(
            format: "visitUUID LIKE %@", uuidString)
        do{
            medicaments = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError{
            print("Could not save.\(error),\(error.userInfo)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        floatButton.frame = CGRect(x: view.frame.width - 90, y: view.frame.height - view.frame.height * 0.2, width: 70, height: 70)
    }
    
    //MARK: Other function
    @objc
    func floatButtonTapped(){
        createNewMedicament(visitUUID: visitUUID?.uuidString)
    }
}

//MARK: TableView DataSource
extension MedicamentListController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicaments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let medicament = medicaments[indexPath.row] as! Medicament
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicamentCell") as! MedicamentCell
        cell.setupCell(medicament: medicament)
        return cell
    }
    
    
}

//MARK: TableView Delegate
extension MedicamentListController:UITableViewDelegate{
    
}
