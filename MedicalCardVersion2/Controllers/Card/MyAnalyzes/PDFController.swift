//
//  PDFController.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 14.07.2022.
//

import UIKit
import PDFKit

class PDFController: UIViewController {
    
    var uploadFile:UploadFile?
    
    @IBOutlet weak var baseView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPDFView()
        

        // Do any additional setup after loading the view.
    }
    

    func setupPDFView(){
        let pdfView = PDFView()
        pdfView.frame = baseView.bounds
        let url = URL(fileURLWithPath: uploadFile!.url!)
        print(url)
        guard let pdfDocument = PDFDocument(url: url) else {
            print("Не получилось создать")
            return
        }
        pdfView.document = pdfDocument
        baseView.addSubview(pdfView)
        
    }

}
