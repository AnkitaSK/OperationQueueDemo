//
//  ViewModel.swift
//  OperationQueueDemo
//
//  Created by Ankita Kalangutkar on 21/02/21.
//  Copyright © 2021 Ankita Kalangutkar. All rights reserved.
//

import UIKit

class ImageOperationViewModel: NetworkManager {
    func get(_ urlString: String, completion: @escaping ([ImageRecord]) -> Void) {
        self.get(from: URL(string: urlString)!) { (data, error) in
            guard let data = data else { return }
//            let decoder = JSONDecoder()
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


class ImageAsyncOperation: Operation {
//    let queue = OperationQueue()
    
    let imageOperation: ImageRecord
    
    init(_ imageOperation: ImageRecord) {
      self.imageOperation = imageOperation
    }
    
    enum State: String {
        case Ready, Executing, Finished
        
        fileprivate var keyPath: String {
            return rawValue
        }
    }
    
    var state = State.Ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet{
            willChangeValue(forKey: oldValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
    }
    
//    func asyncAdd(_ lhs: Int, _ rhs: Int, completion: @escaping(Int) -> ()) {
//        queue.addOperation {
//            completion(lhs + rhs)
//        }
//    }
    
    override func main() {
//        asyncAdd(sumOperation.lhs, sumOperation.rhs) { (result) in
//            self.sumOperation.result = result
//            self.state = .Finished
//        }
    }
}

extension ImageAsyncOperation {
    override var isReady: Bool {
        return super.isReady && state == .Ready
    }
    
    override var isExecuting: Bool {
        return state == .Executing
    }
    
    override var isFinished: Bool {
        return state == .Finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func start() {
        if isCancelled {
            state = .Finished
            return
        }
        main()
        state = .Executing
    }
    
    override func cancel() {
        state = .Finished
    }
}
