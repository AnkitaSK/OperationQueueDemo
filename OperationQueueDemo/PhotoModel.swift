//
//  PhotoModel.swift
//  OperationQueueDemo
//
//  Created by Ankita Kalangutkar on 21/02/21.
//  Copyright © 2021 Ankita Kalangutkar. All rights reserved.
//

import UIKit

class ImageRecord {
    let name: String
    let url: URL
    var state = State.new
    var image = UIImage(named: "images")
    
    init(_ name:String, _ url:URL) {
      self.name = name
      self.url = url
    }
}

//struct ImageRecord: Decodable {
//    var name: String?
//    var url: URL?
////    var state = PhotoRecordState.new
//    var image = UIImage(named: "Placeholder")
//
//
//    enum CodingKeys: String, CodingKey {
//        case name
//        case url
//        case image
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        name = try values.decode(String.self, forKey: .name)
//        url = try values.decode(URL.self, forKey: .url)
//    }
//}


