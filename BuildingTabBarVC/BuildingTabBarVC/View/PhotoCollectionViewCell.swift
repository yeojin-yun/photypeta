//
//  PhotoCollectionViewCell.swift
//  BuildingTabBarVC
//
//  Created by 순진이 on 2022/04/07.
//


import UIKit
import Photos

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PhotoCollectionViewCell"

    // MARK: - Property
    let photoImageView = UIImageView(frame: .zero)
    let checkmarkImageView = UIImageView(frame: .zero)
    
    
    override var isSelected: Bool {
        didSet {
            self.checkmarkImageView.isHidden = isSelected ? false : true
        }
    }

    override init(frame: CGRect) {
//        self.isSelected = false
        super.init(frame: frame)
        setUpPhotoImageView()
        setUpCheckmarkImageView()
    }
  
    
    // MARK: - Vars & Lets
    
    
    func setUpCheckmarkImageView() {
        checkmarkImageView.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
        checkmarkImageView.layer.cornerRadius = checkmarkImageView.frame.size.width * 0.5
        checkmarkImageView.image = UIImage(systemName: "checkmark.circle")
        checkmarkImageView.clipsToBounds = true
        contentView.addSubview(checkmarkImageView)
    }
    
    func setUpPhotoImageView() {
        photoImageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
        photoImageView.image = UIImage(systemName: "photo.artframe")
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.clipsToBounds = true
        contentView.addSubview(photoImageView)
    }
    

    
    // MARK: - Public methods
    
    func setImage(_ asset: PHAsset) {
        self.photoImageView.image = asset.getAssetThumbnail(size: CGSize(width: self.frame.width * 3, height: self.frame.height * 3))
    }
    
    func setImage(_ image: UIImage) {
        self.photoImageView.image = image
    }

    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}
