
import Foundation
import UIKit


enum PhotosResult{
    case success([Photo])
    case failure(Error)
}

enum ImageResult{
    case success(UIImage)
    case failure(Error)
}

enum PhotoError: Error{
    case imageCreationError
}


class PhotoStore{
    
     let imageStore = ImageStore()

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    private func processPhotoRequest(data:Data?, error:Error?) -> PhotosResult{
        guard let jsonData = data else{
            return .failure(error!)
        }
        return FlickerApi.photos(fromJSON: jsonData)
    }
    
    private func processImageRequest(data:Data?, error: Error?) -> ImageResult{
        guard let imageData = data,let image = UIImage(data: imageData) else {
            if data == nil {
                return .failure(error!)
            } else {
                return .failure(PhotoError.imageCreationError)
            }
        }
        return.success(image)
    }
    
    //fetches data and stores it in a memory
    func fetchInterestingPhotos(completion: @escaping(PhotosResult) -> Void){
//        let url = FlickerApi.interestingPhotosURL
        
        let url = FlickerApi.recentPhotosURL
        
        let request = URLRequest(url: url)
        
        //we can then create a task with a request: calls a handler in completion: in the handler, data + response + error will return
        
        //when you unwrap a nil value it will give you an error
        
        let task = session.dataTask(with: request){(data, response, error) in
            let result = self.processPhotoRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        
        task.resume()
    }
    
    func fetchImage(for photo:Photo, completion: @escaping (ImageResult) -> Void){
        
        let photoKey = photo.photoID
        if let image = imageStore.image(forKey: photoKey) {
            
            print("caches")
            OperationQueue.main.addOperation {
                completion(.success(image))
            }
            return
        }
        
        let photoURL = photo.remoteURL
        let request = URLRequest(url: photoURL)
        let task = session.dataTask(with: request){
            (data, response, error)in
            let result = self.processImageRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
}
