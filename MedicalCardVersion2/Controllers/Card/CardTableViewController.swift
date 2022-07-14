//
//  CardTableViewController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 04.05.2022.
//

import UIKit

struct CollectionStruct{
    var title:String
    var imageName:String
    var viewController:String
}

class CardTableViewController: UIViewController {
    
    var collectionStruct:[CollectionStruct] = [
        CollectionStruct(title: NSLocalizedString("diagnosis", comment: ""), imageName: "diagnosisColor", viewController: "MyDiagnosesController"),
        CollectionStruct(title: NSLocalizedString("visits", comment: ""), imageName: "hospital-building", viewController: "MyVisitsToDoctorController"),
        CollectionStruct(title: NSLocalizedString("analysis", comment: ""), imageName: "flask", viewController: "MyAnalyzesController"),
        CollectionStruct(title: NSLocalizedString("medicaments", comment: ""), imageName: "medicine (1)", viewController: "MyMedicamentController")
    ]
    
    let cellsCount:CGFloat = 2
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("title_medicalCard", comment: "")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        let cellNib = UINib(nibName: "MedicalCardCollectionCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "MedicalCardCollectionCell")
        
    }
    
    //MARK: Other function
    private func goToSpecifiedController(controllerName:String){
        let specifiedController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: controllerName)
        navigationController?.pushViewController(specifiedController, animated: true)
    }
}

extension CardTableViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionStruct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MedicalCardCollectionCell", for: indexPath) as! MedicalCardCollectionCell
        let itemCard = collectionStruct[indexPath.item]
        cell.setupCell(collectionStruct: itemCard)
        return cell
    }
    
    
}

extension CardTableViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemCard = collectionStruct[indexPath.item]
        goToSpecifiedController(controllerName: itemCard.viewController)
    }
}

extension CardTableViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameCV = collectionView.bounds
        let sideCell = frameCV.width / cellsCount - 10
        return CGSize(width: sideCell, height: sideCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
