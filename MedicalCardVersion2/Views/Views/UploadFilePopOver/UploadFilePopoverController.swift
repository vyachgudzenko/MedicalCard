//
//  UploadFilePopoverController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 14.07.2022.
//

import UIKit
import Photos
import PhotosUI

class UploadFilePopoverController: UIViewController {
    
    var images:[UIImage] = []
    var analysisUUID:UUID?
    var urlString:String?

    @IBOutlet weak var popoverView: UIView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var pdfButton: UIButton!
    
    init(){
        super.init(nibName: "UploadFilePopoverController", bundle: Bundle(for: UploadFilePopoverController.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .coverVertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func imageButtonPressed(_ sender: Any) {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 5
        config.filter = PHPickerFilter.images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func pdfButtonPressed(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        self.present(documentPicker, animated: true)
    }
    
    func showPopover(analysisUUID:UUID){
        self.analysisUUID = analysisUUID
        if #available(iOS 13, *) {
        UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
        } else {
        UIApplication.shared.keyWindow?.rootViewController!.present(self, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popoverView.layer.masksToBounds = true
        popoverView.layer.cornerRadius = 15
        
    }
}

extension UploadFilePopoverController:PHPickerViewControllerDelegate{
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { [self] reading, error in
                DispatchQueue.main.async {
                    guard let image = reading as? UIImage, error == nil else {
                        return
                    }
                    saveUploadFile(analysisUUID: self.analysisUUID!.uuidString, file: (image.jpegData(compressionQuality: 1))!,typeOfFile: .image,url: nil)
                }
            }
        }
        self.dismiss(animated: true)
    }
}

extension UploadFilePopoverController:UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        DispatchQueue.main.async { [self] in
            guard let selectedFileURL = urls.first else {
                return
            }
            urlString = selectedFileURL.path
            saveUploadFile(analysisUUID: self.analysisUUID!.uuidString, file: nil,typeOfFile: .pdf,url: urlString)
        }
        self.dismiss(animated: true)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.dismiss(animated: true)
    }
}

