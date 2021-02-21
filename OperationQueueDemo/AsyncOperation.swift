//
//  AsyncOperation.swift
//  OperationQueueDemo
//
//  Created by Ankita Kalangutkar on 21/02/21.
//  Copyright © 2021 Ankita Kalangutkar. All rights reserved.
//

import Foundation

class PendingOperation {
    lazy var downloadInProgress:[IndexPath: Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download"
        return queue
    }()
}

/*lazy var downloadsInProgress: [IndexPath: Operation] = [:]
lazy var downloadQueue: OperationQueue = {
  var queue = OperationQueue()
  queue.name = "Download queue"
  queue.maxConcurrentOperationCount = 1
  return queue
}()*/
