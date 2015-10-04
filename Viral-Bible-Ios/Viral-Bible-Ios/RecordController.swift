//
//  RecordController.swift
//  Viral-Bible-Ios
//
//  Created by Philip Loden on 10/3/15.
//  Copyright © 2015 Alan Young. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class RecordController : NSObject, AVAudioRecorderDelegate {
  
  lazy var recorderSettings : [String : AnyObject] = {
    var rec = [String : AnyObject]()
    rec[AVFormatIDKey] = UInt32(kAudioFormatLinearPCM) as? AnyObject
    rec[AVSampleRateKey] = UInt32(44100.0) as? AnyObject
    rec[AVNumberOfChannelsKey] = UInt32(2) as? AnyObject
    rec[AVLinearPCMBitDepthKey] = UInt32(16) as? AnyObject
    rec[AVLinearPCMIsBigEndianKey] = UInt32(0) as? AnyObject
    rec[AVLinearPCMIsFloatKey] = UInt32(0) as? AnyObject
    return rec
    }()
  
  func startRecording() {
    let audioSession = AVAudioSession.sharedInstance()
    
    do {
      try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
      try audioSession.setActive(true)
      
      let audioFileName = "recordingTestFile"
      let fileURL = (UIApplication.sharedApplication().delegate as! AppDelegate).applicationDocumentsDirectory().URLByAppendingPathComponent("/\(audioFileName).caf")
      
      let recorder = try AVAudioRecorder(URL: fileURL, settings: self.recorderSettings)
      recorder.delegate = self
      recorder.prepareToRecord()
      recorder.meteringEnabled = true
      recorder.recordForDuration(60)
    } catch {
      print("ICH BIN KAPUT")
    }
  }
  
  func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
    
  }
  
}