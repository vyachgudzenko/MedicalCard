//
//  TabbarController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 04.05.2022.
//

import UIKit

class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()

        // Do any additional setup after loading the view.
    }
    
    func setupTabbar(){
        tabBar.tintColor = .systemPink
        tabBar.unselectedItemTintColor = .darkGray
    }

}
