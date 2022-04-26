//
//  HomeViewController.swift
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
//ThumNail photo


class HomeViewController: UIViewController {
    
    private var allAssetFromLibrary = [PHAsset]() // Library 속 모든 포토
    private var selectedAsset = [PHAsset]() // 선택된 이미지 넣을 배열
    private var assetCollection: PHAssetCollection?
    private var fetchResultAsset: PHFetchResult<PHAsset>?
    
    
    private var topCollectionView: UICollectionView?
    private var bottomCollectionView: UICollectionView?
    
    private var count: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpNavigationItem()
        configureCollectionView()
        
        popluatePhotos()
        
    }
    

    
    private func popluatePhotos() {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                
                let asset = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                asset.enumerateObjects { [weak self] object, _, _ in
                    //print(object)
                    self?.allAssetFromLibrary.append(object)
                }
                self.allAssetFromLibrary.reverse()
                DispatchQueue.main.async {
                    self.bottomCollectionView?.reloadData()
                }
            }
        }
    }
    
    private func fetchImagesFromGallery(collection: PHAssetCollection) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationData", ascending: true)]
        fetchResultAsset = PHAsset.fetchKeyAssets(in: collection, options: fetchOptions)
        bottomCollectionView?.reloadData()
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
//MARK: -UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == bottomCollectionView) {
            return allAssetFromLibrary.count
        } 
        return 5
    }
    //🟠 셀에 표시될 데이터 - 일단 나오지만, Collection이 아니라 전체 데이터를 가져온 듯함
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
extension HomeViewController: UICollectionViewDelegate {
    //⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️셀이 선택된 후 발생할 이벤트
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //bottomCollectionView에서 선택한 셀의 이미지를 seletedImages에 넣어 그 배열을 topcollectionview에 표시
        if collectionView == bottomCollectionView {
            
            guard let cell = topCollectionView?.cellForItem(at: indexPath) as? CustomCollectionViewCell else { return }
            
            //print("현재 선택된 이미지는 \(allAssetFromLibrary[indexPath.item])")
            selectedAsset.append(allAssetFromLibrary[indexPath.item]) // 배열형태
            
            //print("몇개냐면 \(selectedAsset)") //똑같은 사진 넣으면 crash (nil) -> 배열은 값 중복 불가능하므로
            count = selectedAsset.count
            
            print(selectedAsset.count)
            
            let selectedPhoto = selectedAsset[count-1]
            let selectedManager = PHImageManager.default()
            selectedManager.requestImage(for: selectedPhoto, targetSize: CGSize(width: 80, height: 80), contentMode: .aspectFill, options: nil) { image, _ in
                DispatchQueue.main.async {
                    cell.myImageView.image = image
                    self.bottomCollectionView?.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell
        cell?.contentView.layer.borderWidth = 0
        cell?.contentView.layer.borderColor = nil
    }

}


//MARK: -UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
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
    

}

//MARK: - Setup Navigation Bar Item
extension HomeViewController {
    func setUpNavigationItem() {
        navigationItem.title = "CollectionViewTest"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(leftBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(rightBarButtonItemTapped(_:)))
    }
    
    
    @objc func leftBarButtonItemTapped(_ sender: UIButton) {
        print("취소")
    }
    
    @objc func rightBarButtonItemTapped(_ sender: UIButton) {
        navigationController?.pushViewController(ImageViewController(), animated: true)
    }
}

//MARK: - Setup CollectionView
extension HomeViewController {
    func configureCollectionView() {
        setUpTopCollectionView()
        setUpBottomCollectionView()
    }
    
    func setUpTopCollectionView() {
        let topLayout = UICollectionViewFlowLayout()
        topLayout.scrollDirection = .horizontal
        
        topCollectionView = UICollectionView(frame: CGRect(x: 0, y: 120, width: view.bounds.size.width, height: 80), collectionViewLayout: topLayout)
        
        guard let collectionView = topCollectionView else { return }
        
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    
    func setUpBottomCollectionView() {
        let downLayout = UICollectionViewFlowLayout()
        downLayout.scrollDirection = .vertical
        
        bottomCollectionView = UICollectionView(frame: CGRect(x: 0, y: 220, width: view.frame.size.width, height: 600), collectionViewLayout: downLayout)
        
        guard let collectionView = bottomCollectionView else { return }
        
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
}
