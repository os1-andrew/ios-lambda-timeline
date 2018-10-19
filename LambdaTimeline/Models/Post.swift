//
//  Post.swift
//  LambdaTimeline
//
//  Created by Spencer Curtis on 10/11/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import FirebaseAuth
import MapKit

enum MediaType: String {
    case image
    case video
}

class Post: NSObject{
    
    init(title: String, geoTag: CLLocationCoordinate2D?, mediaType: MediaType, mediaURL: URL, ratio: CGFloat? = nil, author: Author, timestamp: Date = Date()) {
        self.mediaURL = mediaURL
        self.geoTag = geoTag
        self.ratio = ratio
        self.mediaType = mediaType
        self.author = author
        self.comments = [Comment(text: title, author: author)]
        self.timestamp = timestamp
    }
    
    init?(dictionary: [String : Any?], id: String) {
        guard let mediaURLString = dictionary[Post.mediaKey] as? String,
            let mediaURL = URL(string: mediaURLString),
            let mediaTypeString = dictionary[Post.mediaTypeKey] as? String,
            let mediaType = MediaType(rawValue: mediaTypeString),
            let authorDictionary = dictionary[Post.authorKey] as? [String: Any],
            let author = Author(dictionary: authorDictionary),
            let timestampTimeInterval = dictionary[Post.timestampKey] as? TimeInterval,
            let captionDictionaries = dictionary[Post.commentsKey] as? [[String: Any]] else { return nil }
       
        if let geoLongitude = dictionary[Post.geoLongitudeKey] as? Double,
            let geoLatitude = dictionary[Post.geoLatitudeKey] as? Double {
        self.geoTag = CLLocationCoordinate2D(latitude: geoLatitude, longitude: geoLongitude)
        }
        self.geoTag = nil
        self.mediaURL = mediaURL
        self.mediaType = mediaType
        self.ratio = dictionary[Post.ratioKey] as? CGFloat
        self.author = author
        self.timestamp = Date(timeIntervalSince1970: timestampTimeInterval)
        self.comments = captionDictionaries.compactMap({ Comment(dictionary: $0) })
        self.id = id
    }
    
    var dictionaryRepresentation: [String : Any?] {
        var dict: [String: Any?] = [Post.mediaKey: mediaURL.absoluteString,
                                    Post.geoLongitudeKey: geoTag?.longitude,
                                   Post.geoLatitudeKey: geoTag?.latitude,
                                   Post.mediaTypeKey: mediaType.rawValue,
                                   Post.commentsKey: comments.map({ $0.dictionaryRepresentation }),
                                   Post.authorKey: author.dictionaryRepresentation,
                                   Post.timestampKey: timestamp.timeIntervalSince1970]
        
        guard let ratio = self.ratio else { return dict }
        
        dict[Post.ratioKey] = ratio
        
        return dict
    }
    // MARK: - Properties
    var geoTag: CLLocationCoordinate2D?
    var mediaURL: URL
    let mediaType: MediaType
    let author: Author
    let timestamp: Date
    var comments: [Comment]
    var id: String?
    var ratio: CGFloat?
    
    var title: String? {
        return comments.first?.text
    }
    
    static private let geoLongitudeKey = "geoLongitude"
    static private let geoLatitudeKey = "geoLatitude"
    static private let mediaKey = "media"
    static private let ratioKey = "ratio"
    static private let mediaTypeKey = "mediaType"
    static private let authorKey = "author"
    static private let commentsKey = "comments"
    static private let timestampKey = "timestamp"
    static private let idKey = "id"
}
