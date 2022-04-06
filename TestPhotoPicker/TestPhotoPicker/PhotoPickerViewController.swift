//
//  PhotoPickerViewController.swift
//  TestPhotoPicker
//
//  Created by 순진이 on 2022/04/05.
//

import UIKit


class PhotoPickerViewController: UIViewController {
    typealias ViewModel = PrintingViewModel
    typealias CellData = PhotosCellData
    typealias Const = PhotoPickerViewControllerConstants

    var viewModel: ViewModel!

    // MARK: - subviews

    let photoPickerView: PhotoPickerCollectionView

    var hasCurrentAlbumItemSet: Bool = false
    var hasChanged:Int = -1 {
        didSet {
            if hasChanged > 0 {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        photoPickerView = PhotoPickerCollectionView(with: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func unbind() {
        viewModel.editingItems.remove(observer: self)
        viewModel.currentAlbumPhotos.remove(observer: self)
        viewModel.maxItems.remove(observer: self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unbind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        swipeToPopOff()
        print("PhotoPickerViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true

        self.view.backgroundColor = .systemBackground
        setupNavBarUI()
        setNavBarTitle()
        addSubViews()
        setConstraints()

        bind(to: viewModel)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.photoPickerView.setNeedsLayout()
    }

    private func addSubViews() {
          view.addSubview(photoPickerView)
    }

    private func setConstraints() {
        setPhotoPickerViewConstraints()
    }


    func setPhotoPickerViewConstraints() {
        photoPickerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(44)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
        }
    }

    func swipeToPopOff() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }

    func setupNavBarUI() {
        guard let navigation = navigationController else {
            return
        }
        let bar = navigation.navigationBar

        bar.titleTextAttributes = [.foregroundColor: UIColor.label]
        bar.tintColor = .label

        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Common_Done".localized, style: .done, target: self, action: #selector(self.onDonePressed(sender:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "primaryColor")
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Common_Cancle".localized, style: .plain, target: self, action: #selector(self.onCanclePressed(sender:)))
    }

    @objc func onDonePressed(sender: UIBarButtonItem) {
        unbind()
        viewModel.didPickerDoneButtonPressed()
        self.dismiss(animated: true)
    }

    @objc func onCanclePressed(sender: UIBarButtonItem) {
        unbind()
        self.dismiss(animated: true)
    }

    func setNavBarTitle() {
        self.title = String.init(format: "%d / %d", viewModel.selectedItems.value.count, viewModel.maxItems.value)
    }

}

enum PhotoPickerViewControllerConstants {
    static let selectedItemsNumOfColumn: CGFloat = 4
    static let selectedItemsSpacing: CGFloat = 3
    static let selectedItemsSizeMargin: CGFloat = -5

    static let selectingViewNumOfColumn: CGFloat = 3
}
