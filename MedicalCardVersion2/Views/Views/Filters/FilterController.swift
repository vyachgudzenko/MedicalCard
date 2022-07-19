//
//  FilterController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 14.07.2022.
//

import UIKit

protocol FilterControllerDelegate{
    func okButtonPressed(_ filter:FilterController)
}

class FilterController: UIViewController {
    
    var valueForSort:SortByTypes = .date
    var delegate:FilterControllerDelegate?
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackViewForItems: UIStackView!
    @IBOutlet weak var okStackView: UIStackView!
    
    var dateCreateButton:FilterButton! = {
        let button = FilterButton()
        button.setTitle("Date", for: .normal)
        button.flag = true
        return button
    }()
    
    var alphabetButton:FilterButton! = {
        let button = FilterButton()
        button.setTitle("Alphabet", for: .normal)
        return button
    }()
    
    var fromSmallestButton:FilterButton! = {
        let button = FilterButton()
        button.flag = true
        button.setTitle("От меньшего к большему", for: .normal)
        button.selectedColor = .systemIndigo
        button.titleLabel?.numberOfLines = 2
        return button
    }()
    
    var fromBiggestButton:FilterButton! = {
        let button = FilterButton()
        button.setTitle("От большего к меньшему", for: .normal)
        button.selectedColor = .systemIndigo
        button.titleLabel?.numberOfLines = 2
        return button
    }()
    
    var okButton:FilterButton! = {
        let button = FilterButton()
        button.setTitle("OK", for: .normal)
        button.selectedColor = .systemGreen
        button.flag = true
        return button
    }()
    
    var cancelButton:FilterButton! = {
        let button = FilterButton()
        button.setTitle("Cancel", for: .normal)
        button.selectedColor = .systemGray
        return button
    }()
    
    init(){
        super.init(nibName: "FilterController", bundle: Bundle(for: FilterController.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .coverVertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func dateCreateButtonTapped(){
        if dateCreateButton.flag != true{
            dateCreateButton.flag = !dateCreateButton.flag
            alphabetButton.flag = false
            valueForSort = .date
        }
       
    }
    
    @objc
    func alphabetButtonTapped(){
        if alphabetButton.flag != true{
            alphabetButton.flag = !alphabetButton.flag
            dateCreateButton.flag = false
            valueForSort = .alphbet
        }
        
    }
    
    @objc
    func fromSmallestButtonTapped(){
        if fromSmallestButton.flag != true{
            fromSmallestButton.flag = !fromSmallestButton.flag
            fromBiggestButton.flag = false
        }
        
    }
    
    @objc
    func fromBiggestButtonTapped(){
        if fromBiggestButton.flag != true{
            fromBiggestButton.flag = !fromBiggestButton.flag
            fromSmallestButton.flag = false
        }
    }
    
    @objc
    func okButtonTapped(){
        self.dismiss(animated: true)
        self.delegate?.okButtonPressed(self)
    }
    
    @objc
    func cancelButtonTapped(){
        self.dismiss(animated: true)
    }
    
    func showFilter(){
        if #available(iOS 13, *) {
        UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
        } else {
        UIApplication.shared.keyWindow?.rootViewController!.present(self, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseView()
        setupStackView()
        setupStackViewSelectedItem()
        setupOkStackView()
        dateCreateButton.addTarget(self, action: #selector(dateCreateButtonTapped), for: .touchUpInside)
        alphabetButton.addTarget(self, action: #selector(alphabetButtonTapped), for: .touchUpInside)
        fromSmallestButton.addTarget(self, action: #selector(fromSmallestButtonTapped), for: .touchUpInside)
        fromBiggestButton.addTarget(self, action: #selector(fromBiggestButtonTapped), for: .touchUpInside)
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
    }
    
    private func setupBaseView(){
        baseView.layer.masksToBounds = true
        baseView.layer.cornerRadius = 20
    }
    
    private func setupStackView(){
        stackView.addArrangedSubview(dateCreateButton)
        stackView.addArrangedSubview(alphabetButton)
    }
    
    private func setupStackViewSelectedItem(){
        stackViewForItems.addArrangedSubview(fromSmallestButton)
        stackViewForItems.addArrangedSubview(fromBiggestButton)
    }
    
    private func setupOkStackView(){
        okStackView.addArrangedSubview(cancelButton)
        okStackView.addArrangedSubview(okButton)
       
    }
    

}
