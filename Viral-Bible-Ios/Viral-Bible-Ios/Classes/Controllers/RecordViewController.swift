//
//  RecordVC.swift
//  Viral-Bible-Ios
//
//  Created by Philip Loden on 10/3/15.
//  Copyright © 2015 Alan Young. All rights reserved.
//

import UIKit

class RecordVC: UIViewController, RecordControllerDelegate {

    @IBOutlet var verseLabel : UILabel!
    @IBOutlet var playButton : UIButton!
    @IBOutlet var recordButton : UIButton!
    
    var uploadBarButtonItem : UIBarButtonItem!
    
    var bibleVerse : BibleVerse?
    var recordController : RecordController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.uploadBarButtonItem = UIBarButtonItem(title: "Upload", style: UIBarButtonItemStyle.Done, target: self, action: Selector("uploadBarButtonItemTouched:"))
        self.uploadBarButtonItem.enabled = false
        self.navigationItem.rightBarButtonItem = self.uploadBarButtonItem

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: Selector("cancelBarButtonItemTouched:"))

        self.recordController = RecordController()
        self.recordController?.delegate = self
        self.verseLabel.text = self.bibleVerse?.verseText
    }
    
    // MARK: IBActions
    
    @IBAction func uploadBarButtonItemTouched(sender: AnyObject?) {
        self.upload()
    }

    @IBAction func cancelBarButtonItemTouched(sender: AnyObject?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func playButtonTouched(sender: AnyObject?) {
        var title : String?
        
        if let
            player = self.recordController?.audioPlayer
            where player.playing
        {
            self.recordController?.stopPlaying()
            title = "Play"
            self.recordButton.enabled = true
        } else {
            recordController?.startPlaying()
            title = "Stop"
            self.recordButton.enabled = false
        }
        self.playButton.setTitle(title, forState: .Normal)
    }

    @IBAction func recordButtonTouched(sender: AnyObject?) {
        var title : String?
        
        if let
            recorder = self.recordController?.recorder
            where recorder.recording
        {
            self.recordController?.stopRecording()
            title = "Record"
            self.playButton.enabled = true
            self.uploadBarButtonItem.enabled = true
        } else {
            self.recordController?.startRecording()
            title = "Stop"
            self.playButton.enabled = false
        }
        self.recordButton.setTitle(title, forState: .Normal)
    }
    
    // MARK: RecordControllerDelegate
    
    func recordControllerDidFinishPlaying(recordController: RecordController) {
        self.playButton.setTitle("Play", forState: .Normal)
        self.recordButton.enabled = true
    }
    
    // MARK: Helper methods
    
    func upload() {
        if let
            verse = self.bibleVerse,
            url = self.recordController?.fileURL
        {
            APIController.uploadRecording(verse.bibleBook, chapterID: verse.chapterID, fileURL: url, completion: { (error) -> () in
                
            })
        }
    }
    
    // MARK: NSObject
    
    deinit {
        if let record = self.recordController {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(record.fileURL.absoluteString)
            } catch {
                
            }
        }
    }
    
}
