//
//  VersionsVC.swift
//  
//
//  Created by Alan Young Admin on 10/3/15.
//
//

import Foundation

import UIKit

class VersionsVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var versions: [BibleVersion]?
    var bibleLanguage: BibleLanguage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        if let lang = self.bibleLanguage {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)

            APIController.getVersions(lang) { (versions, error) -> () in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    
                    if let versions = versions {
                        self.versions = versions
                    }
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let versions = self.versions {
            return versions.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let aCell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TableViewCell
        
        if let versions = self.versions {
            let version = versions[indexPath.row]
            aCell.titleLabel.text = version.name
        }
        
        return aCell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let versions = self.versions {
            let selectedVersion = versions[indexPath.row]
            
            let vc = BooksVC.VB_instantiateFromStoryboard() as! BooksVC
            vc.bibleVersion = selectedVersion
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
