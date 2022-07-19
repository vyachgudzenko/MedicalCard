//
//  FilterController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 14.07.2022.
//

import UIKit

class FilterController: UIViewController {
    
    
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    /*@IBOutlet weak var dateButton: FilterButton!
    
    @IBOutlet weak var alphabetButton: FilterButton!
    
    
    @IBAction func dateButtonTapped(_ sender: UIButton) {
        dateButton.flag = !dateButton.flag
        if dateButton.flag{
            alphabetButton.flag = false
        }
    }
    @IBAction func alphabetButtonTapped(_ sender: Any) {
        alphabetButton.flag = !alphabetButton.flag
        if alphabetButton.flag{
            dateButton.flag = false
        }
    }*/
    
    var dateCreateButton:FilterButton! = {
        let button = FilterButton()
        button.setTitle("Date", for: .normal)
        return button
    }()
    
    var alphabetButton:FilterButton! = {
        let button = FilterButton()
        button.setTitle("Alphabet", for: .normal)
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
        dateCreateButton.flag = !dateCreateButton.flag
        if dateCreateButton.flag{
            alphabetButton.flag = false
        }
    }
    
    @objc
    func alphabetButtonTapped(){
        alphabetButton.flag = !alphabetButton.flag
        if alphabetButton.flag{
            dateCreateButton.flag = false
        }
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
        dateCreateButton.addTarget(self, action: #selector(dateCreateButtonTapped), for: .touchUpInside)
        alphabetButton.addTarget(self, action: #selector(alphabetButtonTapped), for: .touchUpInside)
        dateCreateButton.flag = true
    }
    
    private func setupBaseView(){
        baseView.layer.masksToBounds = true
        baseView.layer.cornerRadius = 20
    }
    
    private func setupStackView(){
        stackView.addArrangedSubview(dateCreateButton)
        stackView.addArrangedSubview(alphabetButton)
    }
    

}
