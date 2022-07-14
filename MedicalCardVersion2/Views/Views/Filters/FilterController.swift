//
//  FilterController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 14.07.2022.
//

import UIKit

class FilterController: UIViewController {
    
    
    @IBOutlet weak var baseView: UIView!
    
    init(){
        super.init(nibName: "FilterController", bundle: Bundle(for: FilterController.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .coverVertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }
    
    private func setupBaseView(){
        baseView.layer.masksToBounds = true
        baseView.layer.cornerRadius = 20
    }

}
