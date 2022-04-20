//
//  HomeTapViewController.swift
//  HomeTap
//
//  Created by 순진이 on 2022/04/13.
//

//images 배열의 순서가 바뀌는 문제 -> 🔴부분에서 순서가 바뀌는 거 같음(해당 동작이 비동기로 동작하는지 볼 것)
//recomendedImages의 추천 갯수를 5개로 제한하기 -> if로 제한 걸기(count가 5 이하까지만 추가될 수 있도록) + 또 다른 필터(생성일자)가 필요할 듯

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
    private var selectedAssetIdentifierIterator: IndexingIterator<[String]>?
    private var currentAssetIdentifier: String?

    private var selectedImageCollection: UICollectionView?
    
    var images: [UIImage] = [] {
        didSet {
            //print("2. 선택된 이미지 배열 변경: \(images.count)")
        }
    }
    
    var recommendedImages: [UIImage] = [] {
        didSet {
            print("추천된 이미지 배열 변경: \(recommendedImages.count)")
        }
    }

    var phassetArray: [PHAsset] = []


    let uploadButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureUI()
        assetToUIImage()
    }
    
    private func assetToUIImage() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            if status == .authorized {
                let phImageManager = PHImageManager.default()
                //fetchAsset을 Asset 배열로 만들어야 함 (현재는 PHFetchResult<PHAsset>)
                let fetchAsset = PHAsset.fetchAssets(with: .image, options: nil)
                fetchAsset.enumerateObjects { asset, index, _ in
                    if asset.isFavorite {
                        //PHAsset을 Image로 바꿔줄 필요가 있음
                        phImageManager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil) { (image: UIImage?, info) in
                            let isDegraded = (info?[PHImageResultIsDegradedKey] as? Bool) ?? false
                            if isDegraded { return }
                            guard let image = image else { return }
                            
                            self.recommendedImages.append(image)
                            DispatchQueue.main.async {
                                self.selectedImageCollection?.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
}

extension HomeTapViewController {
    @objc func uploadButtonTapped(_ sender: UIButton) {
        presentPicker(filter: PHPickerFilter.images)
    }

    private func presentPicker(filter: PHPickerFilter?) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.preferredAssetRepresentationMode = .current
        configuration.selection = .ordered
        configuration.selectionLimit = 5
        configuration.preselectedAssetIdentifiers = selectedAssetIdentifiers

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true)
    }
    
//    func callItemProvider() {
//        guard let assetIdentifier = selectedAssetIdentifierIterator?.next() else { return }
//        currentAssetIdentifier = assetIdentifier
//
//        let progress: Progress?
//        let itemProvider = selection[assetIdentifier]!.itemProvider
//
//        if itemProvider.canLoadObject(ofClass: UIImage.self) {
//            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
//                DispatchQueue.main.async {
//                    self?.handleCompletion(assetIdentifier: assetIdentifier, object: image, error: error)
//                }
//            }
//        }
//
//    }
//
//
//    func handleCompletion(assetIdentifier: String, object: Any?, error: Error? = nil) {
//        guard currentAssetIdentifier == assetIdentifier else { return }
//        if let image = object as? UIImage {
//
//        }
//    }
    
    func test(results: [PHPickerResult]) {
        guard let assetIdentifier = selectedAssetIdentifierIterator?.next() else { return }
        print("5. assetIdentifier: \(assetIdentifier)")
        
        currentAssetIdentifier = assetIdentifier
        //print("6. currentAssetIdentifier: \(currentAssetIdentifier)")
        
        let identifiers = results.compactMap(\.assetIdentifier)
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        print("🟠identifiers: \(identifiers)")
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
        print("🔵fetchResult: \(fetchResult)")
        fetchResult.enumerateObjects { (asset, index, _) -> Void in
            print("🔴asset: \(asset), index: \(index)") //순서 바뀌는 부분
            PHImageManager.default().requestImage(for: asset,
                                                  targetSize: CGSize.init(width: 360, height: 360),
                                                  contentMode: PHImageContentMode.aspectFill,
                                                  options: nil) { (image: UIImage?, info) in
                let isDegraded = (info?[PHImageResultIsDegradedKey] as? Bool) ?? false
                if isDegraded { return }
                guard let image = image else { return }
                print("1. 이미지\(image)")
                self.images.append(image)
                if !self.images.isEmpty {
                    //print("3. 배열에 내용 있음")
                }
                
                DispatchQueue.main.async {
                    self.selectedImageCollection?.reloadData()
                    //print("불리는 시점 확인")
                }
                
            }
        }
    }
}

extension HomeTapViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        
        let exisitingSelection = self.selection
        //print("1. exisitingSelection: \(exisitingSelection)")//첫 번째 선택일 때는 빈배열
        
        var newSelection = [String: PHPickerResult]()
        //print("2. newSelection: \(newSelection)")//첫 번째 선택일 때는 빈배열
        
        for result in results {
            let identifier = result.assetIdentifier!
            newSelection[identifier] = exisitingSelection[identifier] ?? result
            //print("번외1 : \(identifier)")
        }
        //print("1-1. exisitingSelection: \(exisitingSelection)")//첫 번째 선택일 때는 빈배열
        //print("2-2. newSelection: \(newSelection)")

        // Track the selection in case the user deselects it later.
        selection = newSelection
        selectedAssetIdentifiers = results.map(\.assetIdentifier!)
        //print("3. selectedAssetIdentifiers: \(selectedAssetIdentifiers)")

        selectedAssetIdentifierIterator = selectedAssetIdentifiers.makeIterator()
        //print("4. selectedAssetIdentifierIterator: \(selectedAssetIdentifierIterator)")

//        guard let assetIdentifier = selectedAssetIdentifierIterator?.next() else { return }
//        print("5. assetIdentifier: \(assetIdentifier)")
//
//        currentAssetIdentifier = assetIdentifier
//        print("6. currentAssetIdentifier: \(currentAssetIdentifier)")
        
        if results.count > 0 {
            test(results: results)
            images.removeAll()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HomeTapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if images.count > 0, images.count < 6 {
            print("collection cell 갯수: \(images.count)")
            return images.count

        }
        return recommendedImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedImageCollectionViewCell.identifier, for: indexPath) as? SelectedImageCollectionViewCell else { fatalError("Missed Cell") }
        if images.count > 0 {
            cell.selectedImage.image = images[indexPath.item]
        } else {
            cell.selectedImage.image = recommendedImages[indexPath.item]
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeTapViewController: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeTapViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.bounds.size.width/6, height: view.bounds.size.width/6)
        return size
    }
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
