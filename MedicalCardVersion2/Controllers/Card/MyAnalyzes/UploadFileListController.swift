//
//  UploadFileListController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 05.07.2022.
//

import UIKit
import CoreData
import PDFKit

class UploadFileListController: UIViewController {
    
    var analysisUUID:String?
    var sortFiles:[NSManagedObject] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let cellNib = UINib(nibName: "UploadFileCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "UploadFileCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UploadFile>
        fetchRequest = UploadFile.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "analysisUUID LIKE %@", analysisUUID!)
        do{
            sortFiles = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch{
            fatalError()
        }
    }

}

extension UploadFileListController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UploadFileCell") as! UploadFileCell
        cell.setupCell(uploadFile: sortFiles[indexPath.row] as! UploadFile)
        return cell
    }
}

extension UploadFileListController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentUploadFile = sortFiles[indexPath.row] as! UploadFile
        if currentUploadFile.typeOfFileEnum == .pdf{
            let pdfController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PDFController") as! PDFController
            pdfController.uploadFile = currentUploadFile
            navigationController?.pushViewController(pdfController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeAction = UIContextualAction(style: .normal, title: NSLocalizedString("deleteItem", comment: "")) { [self] _, _, _ in
            let currentFile = sortFiles[indexPath.row] as! UploadFile
            deleteUploadFile(file: currentFile)
            sortFiles.remove(at: indexPath.row)
            tableView.reloadData()
        }
        swipeAction.backgroundColor = .systemGray
        return UISwipeActionsConfiguration(actions: [swipeAction])
    }
}
