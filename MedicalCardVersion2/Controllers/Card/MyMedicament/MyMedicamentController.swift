//
//  MyMedicamentController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 29.06.2022.
//

import UIKit
import CoreData

class MyMedicamentController: UIViewController {
    
    var medicaments:[NSManagedObject] = []
    
    var floatButton:RedButton = {
        let button = RedButton()
        return button
    }()

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        createNewMedicament()
    }
    
    //MARK: Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let cellNIB  = UINib(nibName: "MedicamentCell", bundle: nil)
        tableView.register(cellNIB, forCellReuseIdentifier: "MedicamentCell")
        floatButton.addTarget(self, action: #selector(floatButtonTapped), for: .touchUpInside)
        view.addSubview(floatButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Medicament")
        do{
            medicaments = try managedContext.fetch(fetchRequest)
            print(medicaments.count)
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
        createNewMedicament()
    }
}

//MARK: TableView DataSource
extension MyMedicamentController:UITableViewDataSource{
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
extension MyMedicamentController:UITableViewDelegate{
    
}
