//
//  PhotoSelectCollectionView+Extension.swift
//  Photypeta
//
//  Created by 순진이 on 2022/04/08.
//

import UIKit

extension PhotoSelectViewController: UICollectionViewDelegateFlowLayout {
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CollectionViewFlowLayoutType(.photos, frame: view.frame).sizeForItem
  }

  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return CollectionViewFlowLayoutType(.photos, frame: view.frame).sectionInsets
  }

  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return CollectionViewFlowLayoutType(.photos, frame: view.frame).sectionInsets.left
  }
}
