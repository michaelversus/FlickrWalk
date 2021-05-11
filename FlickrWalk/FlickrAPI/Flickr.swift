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

extension Flickr.Photo {
    var urlString: String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
    }
}
