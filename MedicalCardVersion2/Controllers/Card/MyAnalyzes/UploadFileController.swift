//
//  UploadFileController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 05.07.2022.
//

import UIKit
import Photos
import PhotosUI


class UploadFileController: UIViewController {
    
    var images:[UIImage] = []
    var analysisUUID:UUID?
    
    
    @IBAction func uploadImagesTapped(_ sender: UIButton) {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 5
        config.filter = PHPickerFilter.images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    
    @IBAction func uploadFileTapped(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension UploadFileController:PHPickerViewControllerDelegate{
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { [self] reading, error in
                DispatchQueue.main.async {
                    guard let image = reading as? UIImage, error == nil else {
                        return
                    }
                    saveUploadFile(analysisUUID: self.analysisUUID!.uuidString, file: (image.jpegData(compressionQuality: 1) as? Data)!)
                    
                }
                
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    
}
