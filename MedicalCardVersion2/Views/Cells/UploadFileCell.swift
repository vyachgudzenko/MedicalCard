//
//  UploadFileCell.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 05.07.2022.
//

import UIKit

class UploadFileCell: UITableViewCell {

    @IBOutlet weak var fileImageView: UIImageView!
    
    func setupCell(uploadFile:UploadFile){
        guard let image = UIImage(data: uploadFile.file!) else {
            return
        }
        fileImageView.image = image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
