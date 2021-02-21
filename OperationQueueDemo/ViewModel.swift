//
//  ViewModel.swift
//  OperationQueueDemo
//
//  Created by Ankita Kalangutkar on 21/02/21.
//  Copyright © 2021 Ankita Kalangutkar. All rights reserved.
//

import UIKit

enum State {
  case new, downloaded, filtered, failed
}

class ImageOperationViewModel: NetworkManager {
    func get(_ urlString: String, completion: @escaping ([ImageRecord]) -> Void) {
        self.get(from: URL(string: urlString)!) { (data, error) in
            guard let data = data else { return }
            do {
                let decoder = PropertyListDecoder()
                var photos = [ImageRecord]()
                let serialized = try decoder.decode([String: String].self, from: data)
                for (name, value) in serialized {
                    if let url = URL(string: value) {
                        let photo = ImageRecord(name, url)
                        photos.append(photo)
                    }
                }
                completion(photos)
            } catch {
                print(error)
            }
            
        }
    }
}


class ImageDownloader: Operation {
    var photoRecord: ImageRecord
    
    init(_ photoRecord: ImageRecord) {
      self.photoRecord = photoRecord
    }
    override func main() {
        if isCancelled {
          return
        }
        
        guard let imageData = try? Data(contentsOf: photoRecord.url) else { return }
        
        if isCancelled {
          return
        }
        
        if !imageData.isEmpty {
            let image = UIImage(data:imageData)
            photoRecord.image = image
            photoRecord.state = .downloaded
        } else {
            photoRecord.state = .failed
            photoRecord.image = UIImage(named: "Failed")
        }
    }
}
