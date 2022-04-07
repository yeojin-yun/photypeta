////
////  PhotosViewController.swift
////  BuildingTabBarVC
////
////  Created by 순진이 on 2022/04/07.
////
//
//
//import UIKit
//import Photos
//
//class PhotosViewController: UIViewController {
//
//    // MARK: - Vars & Lets
//    
//    var selectedCollection: PHAssetCollection?
//    private var photos: PHFetchResult<PHAsset>!
//    private var numbeOfItemsInRow = 3
//    
//    // MARK: - Outelts
//    
//    private var collectionView = UICollectionView()
//    
//    // MARK: - Controller lifecycle
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.prepareCollectionView()
//        self.fetchImagesFromGallery(collection: self.selectedCollection)
//        print("PhotosViewContoller")
//    }
//    
//    // MARK: - Private methods
//    
//    private func prepareCollectionView() {
//        self.collectionView.dataSource = self
//        self.collectionView.delegate = self
//        self.collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
//    }
//    
//    private func fetchImagesFromGallery(collection: PHAssetCollection?) {
//        DispatchQueue.main.async {
//            let fetchOptions = PHFetchOptions()
//            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
//            if let collection = collection {
//                self.photos = PHAsset.fetchAssets(in: collection, options: fetchOptions)
//            } else {
//                self.photos = PHAsset.fetchAssets(with: fetchOptions)
//            }
//            self.collectionView.reloadData()
//        }
//    }
//
//}
//
//// MARK: - Exteinsions
//// MARK: - UICollectionViewDataSource
//
//extension PhotosViewController: UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if let photos = photos {
//            return photos.count
//        }
//        return 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell
//        cell?.setImage(photos.object(at: indexPath.row))
//        
//        return cell!
//    }
//}
//
//// MARK: - UICollectionViewDelegateFlowLayout
//
//extension PhotosViewController: UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 6
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 6
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (Int(UIScreen.main.bounds.size.width) - (numbeOfItemsInRow - 1) * 6 - 40) / numbeOfItemsInRow
//        return CGSize(width: width, height: width)
//    }
//
//}
