//
//  Photo.swift
//  FlickerApi
//
//  Created by ayako_sayama on 2017-07-04.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import Foundation


class Photo: Equatable{
    
    //enabled comparing with one Photo to another
    
    let title:String
    let remoteURL: URL
    let photoID: String
    let dateTaken:Date
    
    init(title:String, remoteURL:URL, photoID:String, dateTaken:Date) {
        self.title = title
        self.remoteURL = remoteURL
        self.photoID = photoID
        self.dateTaken = dateTaken
    }
    
    // When you create your own class, xcode does not know how to compare.
    // It will compare the memory address instead of the value
    public static func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.photoID == rhs.photoID
    }
}
