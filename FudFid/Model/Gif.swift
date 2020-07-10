//
//  Gif.swift
//  FudFid
//
//  Created by Kate Roberts on 10/07/2020.
//  Copyright © 2020 SaLT for my Squid. All rights reserved.
//

import UIKit
import CloudKit

class Gif: NSObject {
    
    var id: Int!
    var recordID: CKRecord.ID!
    var category: String!
    //var comments: String!
    var gif: URL!
}
