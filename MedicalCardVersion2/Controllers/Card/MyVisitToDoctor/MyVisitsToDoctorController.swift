//
//  MyVisitsToDoctorController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 27.05.2022.
//

import UIKit
import CoreData

class MyVisitsToDoctorController: UIViewController {
    
    var visits:[NSManagedObject] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addBurButtonTapped(_ sender: UIBarButtonItem) {
        createNewVisit()
    }
    var alert:MedicalAlert?
    var floatButton:RedButton! = {
        let button = RedButton()
        return button
    }()
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let cellNib = UINib(nibName: "VisitCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "VisitCell")
        view.addSubview(floatButton)
        floatButton.addTarget(self, action: #selector(floatButtonTapped), for: .touchUpInside)
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
}

extension MyVisitsToDoctorController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VisitCell") as! VisitCell
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

extension MyVisitsToDoctorController:UITableViewDelegate{
    
}
