//
//  ViewController.swift
//  BuildingTabBarVC
//
//  Created by 순진이 on 2022/04/06.
//

import UIKit
import Photos
import PhotosUI

class ViewController: UIViewController {
    
    private var images = [PHAsset]() // Library 속 image 전부 가져옴

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
}

//MARK: -UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == bottomCollectionView) {
            return images.count
        }
        return 10
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
        cell.myImageView.image = UIImage(systemName: "house")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //선택한 셀의 이미지를
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
        cell.contentView.layer.borderWidth = 5
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        print("\(indexPath.item)")

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
extension ViewController {
    func setUpNavigationItem() {
        navigationItem.title = "Test"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(leftBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(rightBarButtonItemTapped(_:)))
    }
    
    
    @objc func leftBarButtonItemTapped(_ sender: UIButton) {
        print("취소")
    }
    
    @objc func rightBarButtonItemTapped(_ sender: UIButton) {
        print("선택")
    }
}
