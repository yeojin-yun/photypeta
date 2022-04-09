//
//  UIImageView+Extension.swift
//  UIImagePicker
//
//  Created by 순진이 on 2022/04/08.
//

import UIKit
import Photos

extension UIImageView {
    
    func fetchImageAsset(_ asset: PHAsset?, targetSize size: CGSize, contentMode: PHImageContentMode = .aspectFill, options: PHImageRequestOptions? = nil, completionHandler: ((Bool) -> Void)?) {
        
        //가져온 에셋을 옵셔널 바인딩
        guard let asset = asset else {
            completionHandler?(false)
            return
        }
        
        //받아온 이미지를 이미지뷰에 표시
        let resultHandler: (UIImage?, [AnyHashable: Any]?) -> Void = { image, info in
            self.image = image
            completionHandler?(true)
        }
        
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: size,
            contentMode: contentMode,
            options: options,
            resultHandler: resultHandler)
    }
}
