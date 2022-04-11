//
//  MainViewController.swift
//  UIImagePicker
//
//  Created by 순진이 on 2022/04/07.
//

import UIKit
import Photos

class MainViewController: UIViewController {
    
    private var selectedAsset: PHFetchResult<PHAsset>?
    private var allAssets = [PHAsset]()
    private var fetchCollection: PHAssetCollection?
    private var albums: [PHAssetCollection] = []
    private var selectedImage: [UIImage]?
    var allPhotos: PHFetchResult<PHAsset>?
    
//    private var selectedAssetCollection
    
    var firstImageView = UIImageView()
    var secondImageView = UIImageView()
    var thirdImageView = UIImageView()
    var forthImageView = UIImageView()
    var fifthImageView = UIImageView()
    
    
    private var bottomCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let bottomCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return bottomCollectionView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setUpBottomCollectionView()
//        configureUI()
//        popluatePhotos()
        
        getPermissionforPhoto { status in
            guard status else { return }
            self.fetchAssets()
            DispatchQueue.main.async {
                self.bottomCollectionView.reloadData()
            }
        }
            
        
        
        
    }
    
    func getPermissionforPhoto(completionHandler: @escaping (Bool) -> Void) {
      // 1
      guard PHPhotoLibrary.authorizationStatus() != .authorized else {
        completionHandler(true)
        return
      }
      // 2
      PHPhotoLibrary.requestAuthorization { status in
        completionHandler(status == .authorized ? true : false)
      }
    }
    
    func fetchAssets() {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationData", ascending: false)]
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
    }
    
    
    private func popluatePhotos() {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                
                let asset = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                asset.enumerateObjects { [weak self] object, _, _ in
                    //print(object)
                    self?.allAssets.append(object)
                }
                self.allAssets.reverse()
                DispatchQueue.main.async {
                    self.bottomCollectionView.reloadData()
                }
            }
        }
    }
    
//    private func checkAuthorizationStatus() {
//        PHPhotoLibrary.checkAuthorizationStatus {
//            if $0 {
//                self.fetchAlbums()
//            }
//        }
//    }
    
    private func fetchCollectionFromGallery() {
        
    }
    
    private func fetchAlbums() {
        let result = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        result.enumerateObjects { collection, _, _ in
            if (collection.hasAssets()) {
                self.albums.append(collection)
            }
        }
        bottomCollectionView.reloadData()
    }
    
    private func fetchImagesFromGallery(collection: PHAssetCollection?) {
        DispatchQueue.main.async { [self] in
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            if let collection = collection {
                self.selectedAsset = PHAsset.fetchAssets(in: collection, options: fetchOptions)
            } else {
                self.selectedAsset = PHAsset.fetchAssets(with: fetchOptions)
            }
            self.bottomCollectionView.reloadData()
        }
    }

}
//MARK: -UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos?.count ?? 3
    }
    
    //⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = bottomCollectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else { fatalError("Not Founded Cell") }
        
        let asset = self.allAssets[indexPath.item]
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil) { image, _ in
            DispatchQueue.main.async {
                cell.myImageView.image = image
                //버튼은 동그라미 표시만 보이도록
            }
        }
        return cell
    }
}

//MARK: -UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newAssetPhoto = allAssets[indexPath.item]
        let manager = PHImageManager.default()
        manager.requestImage(for: newAssetPhoto, targetSize: CGSize(width: 80, height: 80), contentMode: .aspectFill, options: nil) { image, _ in
            DispatchQueue.main.async {
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

    }
}


//MARK: -UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let size = CGSize(width: view.bounds.size.width/3, height: view.bounds.size.width/3)
            return size
    }
}


//MARK: -Setup UI
extension MainViewController {
    final private func configureUI() {
        setAttributes()
        addTarget()
        setConstraints()
    }
    
    final private func setAttributes() {
        [firstImageView, secondImageView, thirdImageView, forthImageView, fifthImageView].forEach {
            $0.image = UIImage(systemName: "house")
            $0.backgroundColor = .yellow
        }
    }
    
    final private func addTarget() {
        
    }
    
    final private func setConstraints() {
        let imageStackView = UIStackView(arrangedSubviews: [firstImageView, secondImageView, thirdImageView, forthImageView, fifthImageView])
        imageStackView.axis = .horizontal
        imageStackView.distribution = .fillEqually
        
        //guard let bottomCollectionView = bottomCollectionView else { return }
        
        [imageStackView, bottomCollectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        NSLayoutConstraint.activate([
            imageStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            imageStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            imageStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            imageStackView.heightAnchor.constraint(equalToConstant: 80),
            
            bottomCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomCollectionView.topAnchor.constraint(equalTo: imageStackView.bottomAnchor, constant: 20),
            bottomCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
            
        ])
        
    }
}

//MARK: -CollectionView setup
extension MainViewController {
    

    func setUpBottomCollectionView() {
        bottomCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        view.addSubview(bottomCollectionView)
    }

}
