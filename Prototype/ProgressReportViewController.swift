//
//  ProgressReportViewController.swift
//  Prototype
//
//  Created by Victor Hugo Carvalho Barros on 2017-11-14.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import UIKit
import Kinvey

class ProgressReportViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    lazy var dataStore = DataStore<Book50k>.collection(.sync, deltaSet: true, autoPagination: true)
    var request: BaseRequest?
    
    @IBAction func downloadFile(_ sender: Any) {
        let file = File {
            $0.fileId = "a7aef65b-1015-46d5-ada2-b64b5360902d"
        }
        self.label.text = "Loading..."
        request = FileStore().download(file, options: nil) {
            switch $0 {
            case .success(let file, let data):
                self.label.text = "File: \(file.fileId!)\nData: \(data.count)"
            case .failure(let error):
                self.label.text = "Error: \(error)"
            }
        }
        request?.progress.addObserver(self, forKeyPath: "fractionCompleted", options: [.initial, .new], context: nil)
    }
    
    @IBAction func pull50kRecords(_ sender: Any) {
        Kinvey.sharedClient.logNetworkEnabled = true
        self.label.text = "Loading..."
        request = dataStore.pull(options: nil) { (result: Result<AnyRandomAccessCollection<Book50k>, Swift.Error>) in
            switch result {
            case .success(let books):
                self.label.text = "\(books.count) Books"
            case .failure(let error):
                self.label.text = "Error: \(error)"
            }
        }
        request?.progress.addObserver(self, forKeyPath: "fractionCompleted", options: [.initial, .new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "fractionCompleted",
            let progress = object as? Progress,
            progress == request?.progress
        {
            DispatchQueue.main.async {
                self.progressView.progress = Float(progress.fractionCompleted)
            }
        }
    }
    
}
