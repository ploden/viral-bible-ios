//
//  NewViewController.swift
//  
//
//  Created by Alan Young Admin on 10/3/15.
//
//

import Foundation

import UIKit


class NewViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var productLabel: UILabel!
    
   // var titleStringViaSegue: String!
    var bibleLanguage: BibleLanguage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.productLabel.text = self.bibleLanguage.name + " " + self.bibleLanguage.languageFamilyCode
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.languages.count
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let aCell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TableViewCell
        
      //  let lang = self.languages[indexPath.row]
      //  aCell.titleLabel.text = lang.name
        return aCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showView", sender:self)
        
    }
    
}
