//
//  BooksVC.swift
//  Viral-Bible-Ios
//
//  Created by Philip Loden on 10/4/15.
//  Copyright © 2015 Alan Young. All rights reserved.
//

import UIKit

class BooksVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var bibleVersion : BibleVersion?
    var books : [BibleBook]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")

        if let version = self.bibleVersion {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)

            APIController.getBooks(version) { (books, error) -> () in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.books = books
                    self.tableView.reloadData()
                })
            }
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let books = self.books {
            return books.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let aCell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TableViewCell
        
        if let books = self.books {
            let book = books[indexPath.row]
            aCell.titleLabel.text = book.bookName
        }
        return aCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let books = self.books {
            let selectedBook = books[indexPath.row]
            
            let vc = ChaptersVC.VB_instantiateFromStoryboard() as! ChaptersVC
            vc.bibleBook = selectedBook
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
