//
//  PHAsset.swift
//  HomeTap
//
//  Created by 순진이 on 2022/04/15.
//

import Foundation
import Photos
import PhotosUI

extension PHAsset {
    
    func testFunction(_ result: [PHPickerResult], _ image: UIImage) -> [UIImage] {
        var imageArray: [UIImage] = []
        let identifiers = result.compactMap(\.assetIdentifier)
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
        fetchResult.enumerateObjects { (asset, index, stop) -> Void in
            PHImageManager.default().requestImage(for: asset,
                                                  targetSize: CGSize.init(width: 100, height: 100),
                                                  contentMode: PHImageContentMode.aspectFill,
                                                  options: nil) { (object: UIImage?, _: [AnyHashable : Any]?) in
                
                guard let image = object else { return }
                imageArray.append(image)
            }
        }
        return imageArray
    }
}
