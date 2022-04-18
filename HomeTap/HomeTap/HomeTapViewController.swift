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
    let currentImageView = UIImageView() // 가운데 pagecontrol로 넘어갈 이미지

    var selectedImages: [UIImage] = []
    private var selection = [String: PHPickerResult]()
    private var selectedAssetIdentifiers = [String]()
    private var currentAssetIdentifier: String?

    private var selectedImageCollection: UICollectionView?
    
    var images: [UIImage] = [] {
        didSet {
            print("changed")
        }
    }

    var phassetArray: [PHAsset] = []

    let firstImage = UIImageView() // 선택된 이미지
    let secondImage = UIImageView()
    let thirdImage = UIImageView()
    let forthImage = UIImageView()
    let fifthImage = UIImageView()

    let uploadButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureUI()
    }
}

extension HomeTapViewController {
    @objc func uploadButtonTapped(_ sender: UIButton) {
        presentPicker(filter: PHPickerFilter.images)
    }

    private func presentPicker(filter: PHPickerFilter?) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = filter
        configuration.preferredAssetRepresentationMode = .current
        configuration.selection = .ordered
        configuration.selectionLimit = 3
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true)
    }
}

extension HomeTapViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)

        if results.count > 0 {
            let alert = UIAlertController(title: "업로드 하겠습니다.", message: "title", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
        }

        let identifiers = results.compactMap(\.assetIdentifier)
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat

        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
        fetchResult.enumerateObjects { (asset, index, _) -> Void in
            PHImageManager.default().requestImage(for: asset,
                                                  targetSize: CGSize.init(width: 360, height: 360),
                                                  contentMode: PHImageContentMode.aspectFill,
                                                  options: nil) { (image: UIImage?, _: [AnyHashable: Any]?) in
                guard let image = image else { return }
                self.images.append(image)
            }
        }
        print(images.count)
        selectedImageCollection?.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension HomeTapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if images.count > 0, images.count < 6 {
            return images.count
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedImageCollectionViewCell.identifier, for: indexPath) as? SelectedImageCollectionViewCell else { fatalError("Missed Cell") }
        print("count: \(indexPath.item)")
        if images.count > 0 {
            cell.selectedImage.image = images[indexPath.item]
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeTapViewController: UICollectionViewDelegate {
    
}

// MARK: - Setup CollectionView
extension HomeTapViewController {
    func configureCollectionView() {
        let downLayout = UICollectionViewFlowLayout()
        downLayout.scrollDirection = .vertical
        selectedImageCollection = UICollectionView(frame: .zero, collectionViewLayout: downLayout)
        guard let selectedImageCollection = selectedImageCollection else { return }
        selectedImageCollection.register(SelectedImageCollectionViewCell.self, forCellWithReuseIdentifier: SelectedImageCollectionViewCell.identifier)
        selectedImageCollection.delegate = self
        selectedImageCollection.dataSource = self
        view.addSubview(selectedImageCollection)
    }
}

// MARK: - UI
extension HomeTapViewController {
    final private func configureUI() {
        setAttributes()
        setConstraints()
        addTarget()
    }
    final private func setAttributes() {
        mainLbl.text = "당신의 추억을 간직해보세요"

        currentImageView.image = UIImage(systemName: "scribble")
        
        uploadButton.setTitle("사진선택 및 업로드", for: .normal)
        uploadButton.setTitleColor(.black, for: .normal)
        uploadButton.backgroundColor = .lightGray
    }
    final private func addTarget() {
        uploadButton.addTarget(self, action: #selector(uploadButtonTapped(_:)), for: .touchUpInside)
    }
    final private func setConstraints() {
        [mainLbl, currentImageView, uploadButton].forEach {
            view.addSubview($0)
        }
        
        mainLbl.snp.makeConstraints { sk in
            sk.top.equalTo(self.view).offset(180)
            sk.leading.equalTo(self.view).offset(30)
            sk.trailing.equalTo(self.view).offset(-30)
            sk.height.equalTo(100)
        }
        
        currentImageView.snp.makeConstraints { sk in
            sk.top.equalTo(mainLbl.snp.bottom).offset(30)
            sk.leading.equalTo(self.view).offset(10)
            sk.trailing.equalTo(self.view).offset(-10)
            sk.bottom.equalTo(self.view).offset(-300)
        }
        
        
        selectedImageCollection?.snp.makeConstraints { sk in
            sk.top.equalTo(currentImageView.snp.bottom).offset(60)
            sk.leading.trailing.equalTo(currentImageView)
            //sk.bottom.equalToSuperview().offset(-80)
            sk.height.equalTo(150)
        }

        uploadButton.snp.makeConstraints { sk in
            sk.bottom.equalTo(self.view).offset(-60)
            sk.leading.trailing.equalTo(currentImageView)
        }
    }
}
