//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Segun Famisa on 31/12/2016.
//  Copyright © 2016 Segun Famisa. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!

    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // disable stop recording button
        stopRecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func recordAudio(_ sender: Any) {
        setupViewState(true)
        
        let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let fileName = "recording.wav"
        let pathArray = [directoryPath, fileName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    
    }

    @IBAction func stopRecording(_ sender: Any) {
        setupViewState(false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            showRecordErrorAlert()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    /*
     * shows an alert when an error occurs with the recording
     */
    func showRecordErrorAlert() {
        let alertController = UIAlertController(title: "Unable to record", message: "",
                                                preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    /**
     * sets the view properties for the corresponding state: recording or not
     */
    func setupViewState(_ isRecording: Bool) {
        setRecordingLabelText(isRecording)
        setButtonsStates(isRecording)
    }
    
    /*
     * sets the appropriate recording label text depending on whether or not a recording is going on
     */
    func setRecordingLabelText(_ isRecording: Bool) {
        if (isRecording) {
            recordingLabel.text = "Recording in Progress"
        } else {
            recordingLabel.text = "Tap to Record"
        }
    }
    
    /*
     * sets the appropriate states for the buttons depending
     */
    func setButtonsStates(_ isRecording: Bool) {
        recordButton.isEnabled  = !isRecording
        stopRecordingButton.isEnabled = isRecording
    }
}

