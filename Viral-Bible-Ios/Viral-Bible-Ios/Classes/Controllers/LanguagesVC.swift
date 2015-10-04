//
//  LanguagesVC.swift
//
//
//  Created by Alan Young Admin on 10/3/15.
//
//

import Foundation

import UIKit

class LanguagesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var languages = [BibleLanguage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")

        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        APIController.getLanguages { (languages, error) -> () in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                if let languages = languages {
                    self.languages = languages
                }
                self.tableView.reloadData()
            })
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.languages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let aCell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TableViewCell
        
        let lang = self.languages[indexPath.row]
        aCell.titleLabel.text = lang.name
        return aCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedLanguage = self.languages[indexPath.row]

        let vc = VersionsVC.VB_instantiateFromStoryboard() as! VersionsVC
        vc.bibleLanguage = selectedLanguage
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
