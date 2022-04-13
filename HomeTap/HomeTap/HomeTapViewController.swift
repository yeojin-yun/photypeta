//
//  HomeTapViewController.swift
//  HomeTap
//
//  Created by 순진이 on 2022/04/13.
//

import UIKit
import SnapKit
import Photos
import PhotosUI

class HomeTapViewController: UIViewController {
    
    let mainLbl = UILabel() // 감성 문구 넣을 레이블
    
    let currentImageView = UIImageView() //가운데 pagecontrol로 넘어갈 이미지
    
    //선택된 이미지
    let firstImage = UIImageView()
    let secondImage = UIImageView()
    let thirdImage = UIImageView()
    let forthImage = UIImageView()
    let fifthImage = UIImageView()

    let uploadButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
}

extension HomeTapViewController {
    @objc func uploadButtonTapped(_ sender: UIButton) {
        presentPicker(filter: PHPickerFilter.images)
        print("phpicker")
    }
    
    private func presentPicker(filter: PHPickerFilter?) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        
        // Set the filter type according to the user’s selection.
        configuration.filter = filter
        // Set the mode to avoid transcoding, if possible, if your app supports arbitrary image/video encodings.
        configuration.preferredAssetRepresentationMode = .current
        // Set the selection behavior to respect the user’s selection order.
        // 사진 선택시 숫자로 표시 or 체크 표시
        //ios15부터 사용 가능
        configuration.selection = .ordered
        // Set the selection limit to enable multiselection.
        configuration.selectionLimit = 5
        // Set the preselected asset identifiers with the identifiers that the app tracks.
        // 기존에 선택된 사진을 picker에 표시
        //ios15부터 사용 가능
        //configuration.preselectedAssetIdentifiers = selectedAssetIdentifiers
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true)
    }
}

extension HomeTapViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
    }
    
    
}

//MARK: -UI
extension HomeTapViewController {
    final private func configureUI() {
        setAttributes()
        setConstraints()
        addTarget()
    }
    
    final private func setAttributes() {
        mainLbl.text = "당신의 추억을 간직해보세요"
        mainLbl.backgroundColor = .yellow
        
        currentImageView.image = UIImage(systemName: "scribble")
        
        firstImage.image = UIImage(systemName: "house")
        secondImage.image = UIImage(systemName: "pencil")
        thirdImage.image = UIImage(systemName: "lasso")
        forthImage.image = UIImage(systemName: "trash")
        fifthImage.image = UIImage(systemName: "folder")
        
        uploadButton.setTitle("사진선택 및 업로드", for: .normal)
        uploadButton.setTitleColor(.red, for: .normal)
        uploadButton.backgroundColor = .darkGray
    }
    
    final private func addTarget() {
        uploadButton.addTarget(self, action: #selector(uploadButtonTapped(_:)), for: .touchUpInside)
    }
    
    final private func setConstraints() {
        let imageStackView = UIStackView(arrangedSubviews: [firstImage, secondImage, thirdImage, forthImage, fifthImage])
        imageStackView.axis = .horizontal
        imageStackView.distribution = .fillEqually
        imageStackView.spacing = 0
        
        [mainLbl, currentImageView, imageStackView, uploadButton].forEach {
            view.addSubview($0)
        }
        
        mainLbl.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(180)
            make.leading.equalTo(self.view).offset(30)
            make.trailing.equalTo(self.view).offset(-30)
            make.height.equalTo(100)
        }
        
        currentImageView.snp.makeConstraints { make in
            make.top.equalTo(mainLbl.snp.bottom).offset(30)
            make.leading.equalTo(self.view).offset(10)
            make.trailing.equalTo(self.view).offset(-10)
            make.bottom.equalTo(self.view).offset(-300)
        }

        imageStackView.snp.makeConstraints { make in
            make.top.equalTo(currentImageView.snp.bottom).offset(60)
            make.leading.trailing.equalTo(currentImageView)
            //make.bottom.equalToSuperview().offset(-80)
            make.height.equalTo(70)
        }
        
        uploadButton.snp.makeConstraints { make in
            make.top.equalTo(imageStackView.snp.bottom).offset(25)
            make.leading.trailing.equalTo(currentImageView)
        }
        
    }
}

