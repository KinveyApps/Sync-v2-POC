//
//  SynchronousViewController.swift
//  Prototype
//
//  Created by Victor Hugo Carvalho Barros on 2017-11-14.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import UIKit
import Kinvey

class SynchronousViewController: UIViewController {
    
    lazy var dataStore = DataStore<Book>.collection(.sync)
    
    @IBAction func find(_ sender: Any) {
        let request: AnyRequest<Result<AnyRandomAccessCollection<Book>, Swift.Error>> = dataStore.find(Query(), options: nil, completionHandler: nil)
        request.wait()
        switch request.result! {
        case .success(let books):
            print("\(books.count) Book(s)")
        case .failure(let error):
            print("Error: \(error)")
        }
    }
    
}
