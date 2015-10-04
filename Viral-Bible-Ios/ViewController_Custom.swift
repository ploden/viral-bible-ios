//
//  ViewController_Custom.swift
//
//
//  Created by Alan Young Admin on 10/3/15.
//
//

import Foundation

import UIKit

class ViewController_Custom: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var languages = [BibleLanguage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.'
        
        APIController.getLanguages { (languages, error) -> () in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
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
        self.performSegueWithIdentifier("showView", sender:self)
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender:
        AnyObject?)
    {
        if (segue.identifier == "showView")
        {
            // upcoming is set to NewViewController (.swift)
            var upcoming: NewViewController = segue.destinationViewController
                as! NewViewController
            // indexPath is set to the path that was tapped
            if let indexPath = self.tableView.indexPathForSelectedRow {
                // titleString is set to the title at the row in the objects array.
                let titleString = self.languages[indexPath.row].name
                // the titleStringViaSegue property of NewViewController is set.
                //upcoming.titleStringViaSegue = titleString
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
    }
    
}
