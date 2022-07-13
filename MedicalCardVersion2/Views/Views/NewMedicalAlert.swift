//
//  NewMedicalAlert.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 12.07.2022.
//

import UIKit

class NewMedicalAlert: UIViewController {
    
    var titleText:String = ""
    var messageText:String = ""
    
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    @IBAction func okButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    init(){
        super.init(nibName: "NewMedicalAlert", bundle: Bundle(for: NewMedicalAlert.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAlert(){
        titleLabel.text = titleText
        messageLabel.text = messageText
    }
    
    func showAlert(title:String,message:String){
        titleText = title
        messageText = message
        if #available(iOS 13, *) {
        UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
        } else {
        UIApplication.shared.keyWindow?.rootViewController!.present(self, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        alertView.layer.masksToBounds = true
        alertView.layer.cornerRadius = 15
        setupAlert()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
