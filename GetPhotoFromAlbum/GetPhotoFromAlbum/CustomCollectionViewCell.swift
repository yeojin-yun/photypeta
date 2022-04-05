//
//  CustomCollectionViewCell.swift
//  GetPhotoFromAlbum
//
//  Created by 순진이 on 2022/04/04.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier = "CustomCollectionViewCell"
    
    let myImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(systemName: "house")
        //imageView.backgroundColor = .yellow
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemYellow
        contentView.addSubview(myImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        myImageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
    }
}
