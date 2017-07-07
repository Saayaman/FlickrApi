//
//  PhotoDataSource.swift
//  FlickerApi
//
//  Created by ayako_sayama on 2017-07-06.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit

class PhotoDataSource: NSObject, UICollectionViewDataSource {

    var photoList = [Photo]()
    let cellIdentifier = "photoCell"

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,for:indexPath) as! PhotoCell
        
        let urlImage = photoList[indexPath.row].remoteURL
        let data = try! Data(contentsOf: urlImage)
        
        let image = UIImage(data: data)
        cell.cellImageView.image = image
        
        print(data)
        return cell
    }
}
