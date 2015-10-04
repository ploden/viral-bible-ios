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
        }
    }
    
    @IBOutlet var verseTextView : UITextView!
    
}
