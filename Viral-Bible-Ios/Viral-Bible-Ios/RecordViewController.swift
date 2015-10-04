//
//  RecordViewController.swift
//  Viral-Bible-Ios
//
//  Created by Philip Loden on 10/3/15.
//  Copyright © 2015 Alan Young. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController, RecordControllerDelegate {

    @IBOutlet var verseLabel : UILabel!
    @IBOutlet var playButton : UIButton!
    @IBOutlet var recordButton : UIButton!
    
    var verse : BibleVerse?
    var recordController : RecordController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.recordController = RecordController()
        self.recordController?.delegate = self
        self.verseLabel.text = self.verse?.verseText
    }
    
    // MARK: IBActions
    
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
    
}
