//
//  DeltaSetViewController.swift
//  Prototype
//
//  Created by Victor Hugo Carvalho Barros on 2017-11-14.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import UIKit
import Kinvey

class DeltaSetViewController: UITableViewController {

    lazy var dataStore = DataStore<Book>.collection(.sync)
    var books: AnyRandomAccessCollection<Book> = AnyRandomAccessCollection([])
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        Kinvey.sharedClient.logNetworkEnabled = true
        dataStore.sync(options: nil) { (result: Result<(UInt, AnyRandomAccessCollection<Book>), [Swift.Error]>) in
            switch result {
            case .success(let count, let books):
                print("Count: \(count)")
                print("\(books.count) Book(s)")
            case .failure(let error):
                print("Error: \(error)")
            }
            self.tableView.reloadData()
            sender.endRefreshing()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let request: AnyRequest<Result<AnyRandomAccessCollection<Book>, Swift.Error>> = dataStore.find(Query(), options: nil, completionHandler: nil)
        request.wait()
        switch request.result! {
        case .success(let books):
            self.books = books
            return Int(books.count)
        case .failure(let error):
            print("Error: \(error)")
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let book = books[indexPath.row]
        cell.textLabel?.text = book.title
        return cell
    }

}
