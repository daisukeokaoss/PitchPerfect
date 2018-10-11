//
//  ViewController.swift
//  PitchPerfect
//
//  Created by 岡大輔 on 2018/10/03.
//  Copyright © 2018年 岡大輔. All rights reserved.
//

import UIKit

import AVFoundation

class RecordSoundViewController: UIViewController ,AVAudioRecorderDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
    }
    
    @IBOutlet var RecordingButton: UIButton!
    @IBOutlet var StopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet var recordingLabel: UILabel!
    
    //MARK: Record Audio
    @IBAction func RecordAudio(_ sender: UIButton) {
        recordingLabel.text = "Recording in progress"
        StopRecordingButton.isEnabled = true
        RecordingButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

        

    //MARK:Stop Recording
    @IBAction func stopRecording(_ sender: UIButton) {
        RecordingButton.isEnabled = true
        StopRecordingButton.isEnabled = false
        recordingLabel.text = "Tap to record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
    }
    
    //MARK:audio Recorder did Finish Recording
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "StopRecording", sender: audioRecorder.url)
        }
    }

    //MARK:prepar for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StopRecording"{
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.RecordedAudioURL = recordedAudioURL
        }
    }
}

