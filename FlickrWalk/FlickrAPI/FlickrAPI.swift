//
//  FlickrAPI.swift
//  FlickrWalk
//
//  Created by Karagiorgos, Michalis, Vodafone Greece on 11/05/2021.
//

import Foundation
import CoreLocation

struct FlickrAPI {
    /// more info for the Flickr API here
    /// https://www.flickr.com/services/api/flickr.photos.search.html
    private let baseURLString: String = "https://api.flickr.com/services/rest"
    private let apiKey: String = "d23b67424737910ba8f25f92aec40438"
    private let method: String = "flickr.photos.search"
    private let itemsPerPage: Int = 1
    private let radius: String = "0.1" // this is Km
    private let location: CLLocation

    init(location: CLLocation) {
        self.location = location
    }

    func baseURL() -> URL? {
        return URL(string: baseURLString)
    }

    func photoSearchQuery() -> [String: String] {
        return [
            "method": method,
            "api_key": apiKey,
            "per_page": "\(itemsPerPage)",
            "lat": "\(location.coordinate.latitude)",
            "lon": "\(location.coordinate.longitude)",
            "format": "json",
            "nojsoncallback": "1",
            "radius": radius
        ]
    }
}
