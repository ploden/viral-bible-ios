//
//  VerseTVCell.swift
//  Viral-Bible-Ios
//
//  Created by Philip Loden on 10/4/15.
//  Copyright © 2015 Alan Young. All rights reserved.
//

import UIKit

class VerseTVCell: UITableViewCell {

    var bibleVerse : BibleVerse? {
        didSet {
            self.verseTextView.text = self.bibleVerse?.verseText
            if let
                recordings = self.bibleVerse?.recordings
                where recordings.count > 0
            {
                self.verseTextView.textColor = .blackColor()
            } else {
                self.verseTextView.textColor = .grayColor()
            }
        }
    }
    
    @IBOutlet var verseTextView : UITextView!
    
}
