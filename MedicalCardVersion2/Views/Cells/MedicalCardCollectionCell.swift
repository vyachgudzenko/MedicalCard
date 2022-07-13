//
//  MedicalCardCollectionCell.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 13.07.2022.
//

import UIKit

class MedicalCardCollectionCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    
    func setupCell(collectionStruct:CollectionStruct){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20
        titleLabel.text = collectionStruct.title
        cardImageView.image = UIImage(named: collectionStruct.imageName)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
