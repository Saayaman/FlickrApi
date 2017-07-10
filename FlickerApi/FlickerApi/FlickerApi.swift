//
//  FlickerApi.swift
//  FlickerApi
//
//  Created by ayako_sayama on 2017-07-04.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import Foundation

enum FlickrError: Error{
    case invalidJSONData
}

enum Method:String{
    case interestingPhotos = "flickr.interestingness.getList"
    case recentPhotos = "flickr.photos.getRecent"
}

struct FlickerApi {
    
    //static because it is a type variable: can access without instance
    private static let baseURLString =  "https://api.flickr.com/services/rest"

    private static func getApi() -> String{
        guard let api = KeyManager.getValue(key: "apiKey") as? String else {
            return ""
        }
        return api
    }
    
    private static let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
        return formatter
    }()
    
    //This is additional prarameters
    static var interestingPhotosURL: URL{
        return flickrURL(method: .interestingPhotos, parameters: ["extras":"url_s,date_taken"])
    }
    
    static var recentPhotosURL: URL{
        return flickrURL(method: .recentPhotos, parameters: ["extras":"url_s,date_taken"])
    }

    
    
    private static func flickrURL(method: Method, parameters: [String:String]?) -> URL{
        
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method" : method.rawValue,
            "format" : "json",
            "api_key": getApi(),
            "nojsoncallback": "1"
        ]
        
        for (key,value) in baseParams{
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters{
            for (key, value) in additionalParams{
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        
        components.queryItems = queryItems
        
        print("URL: \(components.url!)")
        return components.url!
    }
    
    
    static func photos(fromJSON data:Data) -> PhotosResult{
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonDictionary = jsonObject as? [AnyHashable:Any],
            let photos = jsonDictionary["photos"] as? [String: Any],
                let photoArray = photos["photo"] as? [[String:Any]] else{
                    return .failure(FlickrError.invalidJSONData)
            }
            var finalPhotos = [Photo]()
            for photoJSON in photoArray{
                if let photo = photo(fromJSON: photoJSON){
                    finalPhotos.append(photo)
                }
            }
            
            if finalPhotos.isEmpty && !photoArray.isEmpty{
                //not able to parse any of the photos
                // JSON format is wrong?
                return .failure(FlickrError.invalidJSONData)
            }
            
            print("finalPhotos: \(finalPhotos)")
            
            return .success(finalPhotos)
        } catch let error{
            return .failure(error)
        }
    }
    
    static func photo(fromJSON json: [String:Any]) -> Photo? {
        guard let photoID = json["id"] as? String,
        let title = json["title"] as? String,
        let dateString = json["datetaken"] as? String,
        let photoURLString = json["url_s"] as? String,
        let url = URL(string: photoURLString),
            let dateTaken = dateFormatter.date(from: dateString) else{
                return nil
        }
        return Photo(title: title, remoteURL: url, photoID: photoID, dateTaken: dateTaken)
    }
    
}
