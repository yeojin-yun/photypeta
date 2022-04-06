//
//  Ex_UIImageView.swift
//  GetPhotoFromAlbum
//
//  Created by 순진이 on 2022/04/05.
//

import Foundation
import UIKit
import Photos

extension UIImageView {
    func fetchImage(asset: PHAsset, contentMode: PHImageContentMode, targetSize: CGSize) {
        let options = PHImageRequestOptions()
        options.version = .original
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options) { image, _ in
            guard let image = image else { return }
            self.contentMode = .scaleAspectFill
            self.image = image
        }
    }
}
