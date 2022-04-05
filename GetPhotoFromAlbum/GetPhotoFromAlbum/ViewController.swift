//
//  ViewController.swift
//  GetPhotoFromAlbum
//
//  Created by 순진이 on 2022/04/04.
//

import UIKit
import Photos
import PhotosUI

class ViewController: UIViewController {

    private var collectionView: UICollectionView?
    
    var allMedia: PHFetchResult<PHAsset>?
    let scale = UIScreen.main.scale
    var thumnailSize = CGSize.zero
    
    private var images = [UIImage]() //[PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didRightAddTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Asset", style: .plain, target: self, action: #selector(didLeftBtnTapped))
        
        //populatePhotos()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
        guard let collectionView = collectionView else { return }
        
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
//        collectionView.frame = view.bounds
        
        self.allMedia = PHAsset.fetchAssets(with: nil)
        
        //self.collectionView.reloadData()
        self.thumnailSize = CGSize(width: 1024 * self.scale, height: 1024 * self.scale)
    }
    
    @objc private func didRightAddTapped() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 5
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        //navigationController?.pushViewController(vc, animated: true)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc private func didLeftBtnTapped() {
        let vc = GetPhotoFromLibraryViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
//    private func populatePhotos() {
//        PHPhotoLibrary.requestAuthorization { [weak self] status in
//            if status == .authorized {
//                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
//                assets.enumerateObjects { (object, _, _) in
//                    //self.images.append(object)
//                }
//            }
//        }
//    }


}


//MARK: -PHPhotoViewController
extension ViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
         picker.dismiss(animated: true)
        
        let group = DispatchGroup()
        
        results.forEach { result in
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                defer {
                    group.leave()
                }
                guard let image = reading as? UIImage, error == nil else { return }
                self.images.append(image)
            }
        }
        group.notify(queue: .main) {
            self.collectionView?.reloadData()
        }
                     
    }
    
    
}




// MARK: -UICollectionDelegate, UICollectionDataSource, UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        cell.myImageView.image = images[indexPath.item]
//        cell.contentView.backgroundColor = .systemBlue
//        let asset = self.allMedia?.object(at: indexPath.item)
//        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.view.frame.width / 3, height: self.view.frame.width / 3)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}


