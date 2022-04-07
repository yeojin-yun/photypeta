//
//  ImageViewController.swift
//  BuildingTabBarVC
//
//  Created by 순진이 on 2022/04/07.
//

import UIKit
import Photos
import PhotosUI

//bottomCollectionView : PHAsset으로 받아온 사진들을 선택하면 해당 PHAsset 파일들이 selectedPHAsset 배열로 들어갈 수 있도록
//topCollectionView : selectedPHAsset의 사진들을 컬렉뷰에 표시 / 패딩을 줘야 함
//선택된 사진들을 넘버링해서 누를 때마다 count가 올라갈 수 있도록 (최대 5개)
//컬렉션뷰가 늦게 로드되는 문제는 어떻게 할 것인지?
//컬렉션뷰 선택 시 view에 나타나는 애니메이션

class ImageViewController: UIViewController {
    
    private var images = [PHAsset]() // Library 속 image 전부 가져옴
    private var selectedImages = [UIImage]() // 선택된 이미지 넣을 배열

    private var topCollectionView: UICollectionView?
    private var bottomCollectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpNavigationItem()
        setUpTopCollectionView()
        setUpDownCollectionView()
        popluatePhotos()
    }
    
    func setUpDownCollectionView() {
        let topLayout = UICollectionViewFlowLayout()
        topLayout.scrollDirection = .horizontal
        
        topCollectionView = UICollectionView(frame: CGRect(x: 0, y: 120, width: view.bounds.size.width, height: 80), collectionViewLayout: topLayout)
        
        guard let collectionView = topCollectionView else { return }
        
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    
    func setUpTopCollectionView() {
        let downLayout = UICollectionViewFlowLayout()
        downLayout.scrollDirection = .vertical
        
        bottomCollectionView = UICollectionView(frame: CGRect(x: 0, y: 220, width: view.frame.size.width, height: 600), collectionViewLayout: downLayout)
        
        guard let collectionView = bottomCollectionView else { return }
        
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
    }
    
    private func popluatePhotos() {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                
                let asset = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                asset.enumerateObjects { [weak self] object, _, _ in
                    //print(object)
                    self?.images.append(object)
                }
                self.images.reverse()
                DispatchQueue.main.async {
                    self.bottomCollectionView?.reloadData()
                }
            }
        }
    }
    
    func getUIImage(asset: PHAsset) -> UIImage {
        var image = UIImage()
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = true
        options.version = .original
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
                if let data = data {
                    image = UIImage(data: data)!
                }
            }
            return image
    }

}

//MARK: -UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == bottomCollectionView) {
            return images.count
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        
        if (collectionView == bottomCollectionView) {
            let asset = self.images[indexPath.item]
            let manager = PHImageManager.default()
            manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil) { image, _ in
                DispatchQueue.main.async {
                    cell.myImageView.image = image
                }
            }
            return cell
        }
        //cell.myImageView.image = selectedImages[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //선택한 셀의 이미지를 seletedImages에 넣어 그 배열을 collectionview에 표시
        
        let selectedImage = getUIImage(asset: images[indexPath.item])
        selectedImages.append(selectedImage)
        DispatchQueue.main.async {
            let cell = self.topCollectionView?.cellForItem(at: indexPath) as! CustomCollectionViewCell
            cell.myImageView.image = self.selectedImages[0]
            self.bottomCollectionView?.reloadData()
        }
        
//        let selectedManager = PHImageManager.default()
//        selectedManager.requestImage(for: selectedImage, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil) { image, _ in
//            DispatchQueue.main.async {
//                cell.myImageView.image = image
//                self.bottomCollectionView?.reloadData()
//            }
        
        
        
        
        
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell
        cell?.contentView.layer.borderWidth = 0
        cell?.contentView.layer.borderColor = nil
        print("\(indexPath.item)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == bottomCollectionView) {
            let size = CGSize(width: view.bounds.size.width/3, height: view.bounds.size.width/3)
            return size
        } else {
            let size = CGSize(width: 80, height: 80)
            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}



//MARK: - Setup Navigation Bar Item
extension ImageViewController {
    func setUpNavigationItem() {
        navigationItem.title = "ImgTest"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(leftBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(rightBarButtonItemTapped(_:)))
    }
    
    
    @objc func leftBarButtonItemTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarButtonItemTapped(_ sender: UIButton) {
        print("선택")
    }
}
