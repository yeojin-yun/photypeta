//
//  HomeViewController.swift
//  Photypeta
//
//  Created by 순진이 on 2022/04/08.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "사진선택", style: .plain, target: self, action: #selector(selcetPhotoRightBarButtonTapped(_:)))
    }
    

    @objc func selcetPhotoRightBarButtonTapped(_ sender: UIButton) {
        navigationController?.pushViewController(PhotoSelectViewController(), animated: true)
    }

}
