

import UIKit


class ImageStore{
    
    //chas will automaticaly remove object
    
    let cache = NSCache<NSString, UIImage>()
    
    func setImage(_ image:UIImage, forkey key: String){
        cache.setObject(image, forKey: key as NSString)
    }
    
    func image(forKey key:String)-> UIImage?{
        return cache.object(forKey: key as NSString)
    }

    func deleteImage(forkey key: String){
        cache.removeObject(forKey: key as NSString)
    }
}
