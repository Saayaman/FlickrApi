
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
    
    //fetches data and stores it in a memory
    func fetchInterestingPhotos(completion: @escaping(PhotosResult) -> Void){
//        let url = FlickerApi.interestingPhotosURL
        
        let url = FlickerApi.recentPhotosURL
        
        let request = URLRequest(url: url)
        
        //we can then create a task with a request: calls a handler in completion: in the handler, data + response + error will return
        
        //when you unwrap a nil value it will give you an error
        
        let task = session.dataTask(with: request){(data, response, error) in
            let result = self.processPhotoRequest(data: data, error: error)
            completion(result)
        }
        
        task.resume()
    }
}
