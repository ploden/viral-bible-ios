//
//  VersesDetailVC.swift
//  Viral-Bible-Ios
//
//  Created by Philip Loden on 10/4/15.
//  Copyright © 2015 Alan Young. All rights reserved.
//

import UIKit

class VersesDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var chapterNumber : Int16!
    var bibleBook : BibleBook!
    var bibleVerses : [BibleVerse]?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: "VerseTVCell", bundle: nil), forCellReuseIdentifier: "VerseTVCell")

        APIController.getVerses(self.bibleBook, chapterID: chapterNumber) { (verses, error) -> () in
            NSOperationQueue.mainQueue().addOperationWithBlock({
                if let verses = verses {
                    self.bibleVerses = verses
                }
                self.tableView.reloadData()
            })
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // the more accurate the estimate the better the scrolling
        return 44.0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let verses = self.bibleVerses {
            return verses.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tvc = self.tableView.dequeueReusableCellWithIdentifier("VerseTVCell", forIndexPath: indexPath) as! VerseTVCell
        
        if let verses = self.bibleVerses {
            let verse = verses[indexPath.row]
            tvc.verseTextView.text = verse.verseText
        }
        return tvc
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            if let verses = self.bibleVerses {
                let selectedVerse = verses[indexPath.row]
                
                let vc = RecordVC.VB_instantiateFromStoryboard() as! RecordVC
                vc.bibleVerse = selectedVerse
                let nc = UINavigationController(rootViewController: vc)
                
                self.presentViewController(nc, animated: true, completion: nil)
            }
        }
    }

}
