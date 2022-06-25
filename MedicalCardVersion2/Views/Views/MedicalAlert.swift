//
//  MedicalAlert.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 25.06.2022.
//

import Foundation
import UIKit

class MedicalAlert{
    struct Constant{
        static let backgroundAlpha:CGFloat = 0.6
    }
    private var myTargetView:UIView?
    
    private let backgroundView:UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .lightGray
        backgroundView.alpha = 0
        return backgroundView
    }()
    
    private let alertView:UIView =  {
        let alert = UIView()
        let color = UIColor.white
        alert.backgroundColor = color
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 15
        return alert
    }()
    
    func showAlert(title:String,message:String,  viewController:UIViewController){
        guard let targetView = viewController.view else {
            return
        }
        
        myTargetView = targetView
        
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        targetView.addSubview(alertView)
        
        alertView.frame = CGRect(x: 40, y: -300, width: targetView.frame.size.width - 80, height: 300)
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: alertView.frame.width, height: 80))
        titleView.backgroundColor = .systemPink
        alertView.addSubview(titleView)
        
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 60, height: 60))
        imageView.center.y = titleView.center.y
        imageView.image = UIImage(systemName: "cross.fill")
        imageView.backgroundColor = .clear
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        titleView.addSubview(imageView)
        
        let titleLabel = UILabel(frame: CGRect(x: 80, y: 40, width: titleView.frame.width - 10, height: 30))
        titleLabel.center.y = titleView.center.y
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 22)
        titleLabel.numberOfLines = 2
        titleView.addSubview(titleLabel)
        
        let messageLabel = UILabel(frame: CGRect(x: 10, y: 90, width: alertView.frame.width - 20, height: 150))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.font = UIFont.systemFont(ofSize: 18)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        alertView.addSubview(messageLabel)
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: alertView.frame.width / 2 - 40, y: 240, width: 80, height: 50)
        button.backgroundColor = .systemPink
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        alertView.addSubview(button)
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.alpha = Constant.backgroundAlpha
        } completion: { done in
            if done{
                UIView.animate(withDuration: 0.25) {
                    self.alertView.center = targetView.center
                }
            }
        }
    }
    
    @objc
    func dismissAlert(){
        guard let targetView = myTargetView else {
            return
        }
        
        UIView.animate(withDuration: 0.25) {
            self.alertView.frame = CGRect(x: 40, y: targetView.frame.size.height, width: targetView.frame.size.width - 80, height: 300)
        } completion: { done in
            if done{
                UIView.animate(withDuration: 0.25) {
                    self.backgroundView.alpha = 0
                } completion: { done in
                    if done{
                        self.alertView.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                    }
                }

            }
        }

    }
}
