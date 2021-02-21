//
//  TestTableViewController.swift
//  OperationQueueDemo
//
//  Created by Ankita Kalangutkar on 21/02/21.
//  Copyright © 2021 Ankita Kalangutkar. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    let pendingOperations = PendingOperation()
    
    let viewModel = ImageOperationViewModel()
    var photosModel = [ImageRecord]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        viewModel.get("http://www.raywenderlich.com/downloads/ClassicPhotosDictionary.plist") { (photos) in
            self.photosModel = photos
        }
    }
    
    func startDownload(_ photoModel: ImageRecord, at indexPath: IndexPath) {
        guard pendingOperations.downloadsInProgress[indexPath] == nil else {
          return
        }
        
        //2
        let downloader = ImageDownloader(photoModel)
        //3
        downloader.completionBlock = {
          if downloader.isCancelled {
            return
          }
          
          DispatchQueue.main.async {
            self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            self.tableView.reloadRows(at: [indexPath], with: .fade)
          }
        }
        //4
        pendingOperations.downloadsInProgress[indexPath] = downloader
        //5
        pendingOperations.downloadQueue.addOperation(downloader)
        
//        guard pendingOperations.downloadsInProgress[indexPath] == nil else {
//          return
//        }
//        let downloader = ImageDownloader(photoModel)
//        downloader.completionBlock = {
//            if downloader.isCancelled {
//                return
//            }
//        }
//        DispatchQueue.main.async {
//            self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
//            self.tableView.reloadRows(at: [indexPath], with: .fade)
//        }
//
//        pendingOperations.downloadsInProgress[indexPath] = downloader
//        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return photosModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        let photo = photosModel[indexPath.row]
        cell.nameLabel.text = photo.name
        cell.photoImageView.image = photo.image
        switch photo.state {
        case .filtered:
//          indicator.stopAnimating()
            break
        case .failed:
//          indicator.stopAnimating()
          cell.textLabel?.text = "Failed to load"
            break
        case .new:
//          indicator.startAnimating()
          if !tableView.isDragging && !tableView.isDecelerating {
    //        startOperations(for: photoDetails, at: indexPath)
            startDownload(photo, at: indexPath)
          }
        case .downloaded:
//            indicator.stopAnimating()
        break
        }
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
