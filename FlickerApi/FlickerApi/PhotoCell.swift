//
//  PhotoCell.swift
//  FlickerApi
//
//  Created by ayako_sayama on 2017-07-06.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var labe: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        update(with:nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        update(with: nil)
    }
    
    func update(with image:UIImage?){

        if let imageToDisplay = image{
            spinner.stopAnimating()
            cellImageView.image = imageToDisplay
        } else{
            spinner.startAnimating()
            cellImageView.image = nil
        }
    }
    
}
