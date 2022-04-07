//
//  CustomCollectionViewCell.swift
//  BuildingTabBarVC
//
//  Created by 순진이 on 2022/04/06.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier = "CustomCollectionViewCell"
    
    
    //Bool 값에 따라 선택한 셀에 특정 표시를 할 것 - 불투명하게 한다거나, 테투리를 만든다거나
    let myImageView = UIImageView(frame: .zero)
    let myCheckButton = UIButton(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpImageView()
        setUpButton()
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                myCheckButton.isHidden = false
                //print("isSelected")
            } else {
                myCheckButton.isHidden = true
                //print("isDeselected")
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpButton() {
        myCheckButton.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
        myCheckButton.layer.cornerRadius = myCheckButton.frame.size.width * 0.5
        myCheckButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        myCheckButton.setTitleColor(.black, for: .normal)
        myCheckButton.clipsToBounds = true
        myCheckButton.backgroundColor = .lightGray
        contentView.addSubview(myCheckButton)
    }
    
    func setUpImageView() {
        myImageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
        myImageView.image = UIImage(systemName: "photo.artframe")
        myImageView.contentMode = .scaleAspectFill
        myImageView.clipsToBounds = true
        contentView.addSubview(myImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
