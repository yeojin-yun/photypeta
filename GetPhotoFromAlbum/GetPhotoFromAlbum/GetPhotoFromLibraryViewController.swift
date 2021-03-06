//
//  GetPhotoFromLibraryViewController.swift
//  GetPhotoFromAlbum
//
//  Created by 순진이 on 2022/04/05.
//

import UIKit
import Photos

//앨범 전체를 가져옴
//가져온 사진에서 어떻게 원하는 사진을 선택할 것인가?

class GetPhotoFromLibraryViewController: UIViewController {

    //private var allPhotos: PHFetchResult<PHAsset>?
    private var images = [PHAsset]()
    private var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
        guard let collectionView = collectionView else { return }
        
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        popluatePhotos()
    }
    

    private func popluatePhotos() {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
//                let fetchOptions = PHFetchOptions()
//                self.allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                
                let asset = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                asset.enumerateObjects { [weak self] object, _, _ in
                    print(object)
                    self?.images.append(object)
                }
                self.images.reverse()
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }
    }

}

extension GetPhotoFromLibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count//allPhotos?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        let asset = self.images[indexPath.item]
        
//        cell.myImageView.fetchImage(asset: asset!, contentMode: .aspectFit, targetSize: cell.myImageView.frame.size)
//        return cell
        
        //let asset = self.images[indexPath.item]
        let manager = PHImageManager.default()

        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil) { image, _ in
            DispatchQueue.main.async {
                cell.myImageView.image = image
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
        cell.contentView.layer.borderWidth = 5
        cell.contentView.layer.borderColor = UIColor.black.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.bounds.size.width/3, height: view.bounds.size.width/3)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
