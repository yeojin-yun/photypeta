//
//  MainViewController.swift
//  UIImagePicker
//
//  Created by 순진이 on 2022/04/07.
//

import UIKit

class MainViewController: UIViewController {

    var firstImageView = UIImageView()
    var secondImageView = UIImageView()
    var thirdImageView = UIImageView()
    var forthImageView = UIImageView()
    var fifthImageView = UIImageView()
    
    private var bottomCollectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBottomCollectionView()
        configureUI()
    }
    

    func setUpBottomCollectionView() {
        let topLayout = UICollectionViewFlowLayout()
        topLayout.scrollDirection = .horizontal
        
        bottomCollectionView = UICollectionView(frame: CGRect(x: 0, y: 120, width: view.bounds.size.width, height: 80), collectionViewLayout: topLayout)
        
        guard let collectionView = bottomCollectionView else { return }
        
        //collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }

}
//MARK: -UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    //⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = bottomCollectionView?.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? UICollectionViewCell else { return }
        cell.backgroundColor = .red
        return cell
    }
}

//MARK: -UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
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
        if (collectionView == bottomCollectionView) {
            let size = CGSize(width: view.bounds.size.width/3, height: view.bounds.size.width/3)
            return size
        } else {
            let size = CGSize(width: 80, height: 80)
            return size
        }
    }
}


//MARK: -Set up UI


extension MainViewController {
    final private func configureUI() {
        setAttributes()
        addTarget()
        setConstraints()
    }
    
    final private func setAttributes() {
        
    }
    
    final private func addTarget() {
        
    }
    
    final private func setConstraints() {
        let imageStackView = UIStackView(arrangedSubviews: [firstImageView, secondImageView, thirdImageView, forthImageView, fifthImageView])
        imageStackView.axis = .horizontal
        imageStackView.distribution = .fillEqually
        
        guard let bottomCollectionView = bottomCollectionView else { return }
        
        [imageStackView, bottomCollectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        NSLayoutConstraint.activate([
            imageStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            imageStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            imageStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            bottomCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomCollectionView.topAnchor.constraint(equalTo: imageStackView.bottomAnchor, constant: 50),
            bottomCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
        
    }
}


