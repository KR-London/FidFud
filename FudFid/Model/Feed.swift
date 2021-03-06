//
//  Feed.swift
//  StreamLabsAssignment
//
//  Created by Jude on 16/02/2019.
//  Copyright © 2019 streamlabs. All rights reserved.
//

import Foundation
import Firebase

struct Feed: Decodable {
    
    var id: Int
    let url: URL?
    let path: savedContent?
    let text: String?
    let gif: URL?
    let sound: String?
    let image: String?
    let originalFilename: String
    var liked = false
    
    func toAnyObject() -> Any {
        return [
            "name": originalFilename,
            "liked": liked,
        ]
    }
    

}

struct savedContent: Codable{
    var name: String?
    var format: String?
    
    init(filename: String){
        let components = filename.split(separator: ".")
        name = String(components[0])
        format = String(components[1])
    }
}
    
