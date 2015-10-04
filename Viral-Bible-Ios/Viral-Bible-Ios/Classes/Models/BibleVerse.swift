//
//  BibleVerse.swift
//  Viral-Bible-Ios
//
//  Created by Philip Loden on 10/3/15.
//  Copyright © 2015 Alan Young. All rights reserved.
//

import Foundation

struct BibleVerse {
  
  let bibleBook : BibleBook
  let chapterID : Int16
  let verseText : String
  let bibleVerseID : Int16
    let recordings : [BibleVerseRecording]?
}