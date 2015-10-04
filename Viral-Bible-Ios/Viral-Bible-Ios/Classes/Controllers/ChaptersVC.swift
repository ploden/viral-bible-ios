//
//  ChaptersVC.swift
//  Viral-Bible-Ios
//
//  Created by Philip Loden on 10/4/15.
//  Copyright © 2015 Alan Young. All rights reserved.
//

import UIKit

class ChaptersVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var bibleBook : BibleBook?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let book = self.bibleBook {
            return Int(book.numChapters)
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let aCell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TableViewCell
        
        aCell.titleLabel.text = String(indexPath.row + 1)
        return aCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = VersesDetailVC.VB_instantiateFromStoryboard() as! VersesDetailVC
        vc.bibleBook = self.bibleBook
        vc.chapterNumber = Int16(indexPath.row + 1)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
