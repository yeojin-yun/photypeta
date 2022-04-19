//
//  SelectedImageCollectionViewCell.swift
//  HomeTap
//
//  Created by 순진이 on 2022/04/17.
//

import UIKit
import Photos

class SelectedImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "SelectedImageCollectionViewCell"
    
    let selectedImage = UIImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpImageView()
    }

    
    func setUpImageView() {
        selectedImage.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
        selectedImage.image = UIImage(systemName: "photo.artframe")
        selectedImage.contentMode = .scaleAspectFill
        selectedImage.clipsToBounds = true
        contentView.addSubview(selectedImage)
    }
    

    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
