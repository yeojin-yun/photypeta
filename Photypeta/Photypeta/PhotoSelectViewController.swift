//
//  PhotoSelectViewController.swift
//  Photypeta
//
//  Created by 순진이 on 2022/04/08.
//

//포토가 선택되는 뷰컨


import UIKit
import Photos

class PhotoSelectViewController: UIViewController {
    
    
    var assets: PHFetchResult<PHAsset>?
    var photoCollectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    

    
}

//MARK: -UICollectionViewDataSource
extension PhotoSelectViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == bottomCollectionView) {
            return allAssetFromLibrary.count
        }
        return 5
    }
    
    //⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
    func PhotoSelectViewController(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        
        if (collectionView == bottomCollectionView) {
            let asset = self.allAssetFromLibrary[indexPath.item]
            let manager = PHImageManager.default()
            manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil) { image, _ in
                DispatchQueue.main.async {
                    cell.myImageView.image = image
                    //버튼은 동그라미 표시만 보이도록
                }
            }
            return cell
        } else {
            if count > 0 {
                let asset = self.selectedAsset[indexPath.item]
                let manager = PHImageManager.default()
                manager.requestImage(for: asset, targetSize: CGSize(width: 80, height: 80), contentMode: .aspectFill, options: nil) { image, _ in
                    DispatchQueue.main.async {
                        cell.myImageView.image = image
                        self.topCollectionView?.reloadData()
                    }
                }
            }
        }
        return cell
    }
}


//MARK: -UICollectionViewDelegate
extension PhotoSelectViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

//MARK: -UI
extension PhotoSelectViewController {
    final private func configureUI() {
        setupPhotoSelectCollectionView()
        setAttributes()
        addTarget()
        setConstraints()
    }
    
    
    func setupPhotoSelectCollectionView() {
        let downLayout = UICollectionViewFlowLayout()
        downLayout.scrollDirection = .vertical
        
        photoCollectionView = UICollectionView(frame: CGRect(x: 0, y: 220, width: view.frame.size.width, height: 600), collectionViewLayout: downLayout)
        
        guard let collectionView = photoCollectionView else { return }
        
        collectionView.register(PhotoSelectCollectionViewCell.self, forCellWithReuseIdentifier: PhotoSelectCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
    }
    
    final private func setAttributes() {
        
    }
    final private func addTarget() {
        
    }
    
    final private func setConstraints() {
        guard let photoCollectionView = photoCollectionView else { return }
        
        [photoCollectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
    }
}

