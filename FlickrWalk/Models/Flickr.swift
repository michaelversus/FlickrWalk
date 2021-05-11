//
//  Flickr.swift
//  FlickrWalk
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 06/05/2021.
//

import Foundation
import CoreLocation

struct Flickr: Decodable {
    let photos: Photos
    let stat: String

    struct Photos: Decodable {
        let page, pages, perpage: Int
        let total: String
        let photo: [Photo]
    }

    struct Photo: Decodable {
        let id, owner, secret, server: String
        let farm: Int
        let title: String
    }
}

struct FlickrAPI {
    /// more info here
    /// https://www.flickr.com/services/api/flickr.photos.search.html
    struct Constants {
        static let flickrAPI = "d23b67424737910ba8f25f92aec40438"
        static let flickrAPIKey = "api_key"
        static let storeName = "DataStoreModel"
        static let flickrMethod = "flickr.photos.search"
        static let flickrMethodKey = "method"
        static let flickrPerPageKey = "per_page"
        static let flickrPerPage = "1"
        static let flickrLatKey = "lat"
        static let flickrLonKey = "lon"
        static let flickrFormatKey = "format"
        static let flickrJson = "json"
        static let flickrNoJsonCallBackKey = "nojsoncallback"
        static let flickrNoJsonCallBack = "1"
//        static let dataStoreModelName  = "DataStoreModel"
        static let flickRadiusKey = "radius"
        static let flickrRadius = "0.1" // this is Km
        static let baseURLString = "https://api.flickr.com/services/rest"
    }

    static func baseURL() -> URL {
        return URL(string: Constants.baseURLString)!
    }

    static func photoSearchQuery(location: CLLocation) -> [String: String] {
        return [
            Constants.flickrMethodKey: Constants.flickrMethod,
            Constants.flickrAPIKey: Constants.flickrAPI,
            Constants.flickrPerPageKey: Constants.flickrPerPage,
            Constants.flickrLatKey: "\(location.coordinate.latitude)",
            Constants.flickrLonKey: "\(location.coordinate.longitude)",
            Constants.flickrFormatKey: Constants.flickrJson,
            Constants.flickrNoJsonCallBackKey: Constants.flickrNoJsonCallBack,
            Constants.flickRadiusKey: Constants.flickrRadius
        ]
    }

    static func photoURLString(photo: Flickr.Photo) -> String {
        return "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
    }
}
