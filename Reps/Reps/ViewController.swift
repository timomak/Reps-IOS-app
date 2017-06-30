//  ViewController.swift
//  Reps
//
//  Created by timofey makhlay on 4/5/17.
//  Copyright © 2017 timofey makhlay. All rights reserved.
//

import UIKit
import Speech
import Intents

public class ViewController: UIViewController, SFSpeechRecognizerDelegate, UITextViewDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var dictatebutton: UIButton!
    @IBOutlet weak var output: UILabel!
    @IBOutlet weak var output2: UILabel!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenu: UIView!
    @IBOutlet weak var Reps: UILabel!
    @IBOutlet weak var sideBar: UIButton!
    @IBOutlet var bgImage: UIView!
    @IBOutlet weak var rightMenu: UIView!
    @IBOutlet weak var dataConstraint: NSLayoutConstraint!
    @IBOutlet weak var dataBar: UIButton!
    @IBOutlet weak var textCenter: NSLayoutConstraint!
    @IBOutlet weak var dictateCenter: NSLayoutConstraint!
    @IBOutlet weak var repsCenter: NSLayoutConstraint!
    @IBOutlet weak var weightInput: UITextField!
    @IBOutlet weak var weightOutput: UILabel!
    
    var menuShowing = false
    var dataShowing = false

    @IBAction func dataButton(_ sender: Any) {

            if (dataShowing)
            {
                dataConstraint.constant = -210
                UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
                textCenter.constant = 0
                UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
                dictateCenter.constant = 0
                UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
                repsCenter.constant = 0
                UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
            }
            else
            {
                dataConstraint.constant = 0
                UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
                textCenter.constant = -210
                UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
                dictateCenter.constant = -210
                UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
                repsCenter.constant = -210
                UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
                
            }
        dataShowing = !dataShowing
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        weightInput.resignFirstResponder()
        return true
    }
    
    @IBAction func enterInput(_ sender: Any) {
        weightOutput.text = weightInput.text! + " Ibs"
        UserDefaults.standard.set( weightOutput.text , forKey: "weight")
        
        view.endEditing(true)
    }
    
    @IBAction func sideBar(_ sender: Any)
    {

            if (menuShowing)
            {
                leadingConstraint.constant = -210
                UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
                textCenter.constant = 0
                UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
                dictateCenter.constant = 0
                UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
                repsCenter.constant = 0
                UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
            }
            else
            {
                leadingConstraint.constant = 0
                UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
                textCenter.constant = 210
                UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
                dictateCenter.constant = 210
                UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
                repsCenter.constant = 210
                UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
            }
        menuShowing = !menuShowing
    }
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private let audioEngine = AVAudioEngine()
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        textview.delegate = self
        weightInput.delegate = self
        weightInput.returnKeyType = UIReturnKeyType.done
        Reps.alpha = 0
        textview.alpha = 0
        dictatebutton.alpha = 0
        sideBar.alpha = 0
        bgImage.alpha = 0
        dataBar.alpha = 0
        
        // Do any additional setup after loading the view, typically from a nib.
        dictatebutton.isEnabled = false
        super.viewDidLoad()
        // Ask permission to access Siri
        INPreferences.requestSiriAuthorization { authorizationStatus in
            switch authorizationStatus {
            case .authorized:
                print("Authorized")
            default:
                print("Not Authorized")
            }
        }
    }
    public func textView(_ textview: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textview.returnKeyType = UIReturnKeyType.done
        if(text == "\n") {
            textview.returnKeyType = UIReturnKeyType.done
            textview.resignFirstResponder()
            return false
        }
        return true
    }
    
    override public func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1, animations: {
            self.bgImage.alpha = 1
        }) { (true) in
            showReps()
            }
        func showReps()
        {
            UIView.animate(withDuration: 1, animations: {
                self.Reps.alpha = 1
            }, completion: { (true) in
                showText()
            })
        }
        
        func showText()
        {
            UIView.animate(withDuration: 1, animations: {
                self.textview.alpha = 1
            }, completion: { (true) in
                UIView.animate(withDuration: 1, animations: {
                    showBottomPart()
                }, completion: { (true) in
                })
            })
        }
        
        func showBottomPart()
        {
            self.dictatebutton.alpha = 1
            self.sideBar.alpha = 1
            self.dataBar.alpha = 1
        }
        
        speechRecognizer.delegate = self
        sideMenu.layer.shadowOpacity = 0.3
        rightMenu.layer.shadowOpacity = 0.3
        
        SFSpeechRecognizer.requestAuthorization
        {
            authStatus in OperationQueue.main.addOperation
            {
                switch authStatus
                {
                case .authorized:
                    self.dictatebutton.isEnabled = true
                    
                case .denied:
                    self.dictatebutton.isEnabled = false
                    self.dictatebutton.setTitle("User denied access to speech recognition.", for: .disabled)
                    
                case .restricted:
                    self.dictatebutton.isEnabled = false
                    self.dictatebutton.setTitle("Speech recognition restricted on device.", for: .disabled)
                    
                case .notDetermined:
                    self.dictatebutton.isEnabled = false
                    self.dictatebutton.setTitle("Speech recognition not yet authorized.", for: .disabled)
                }
            }
            
            
        }
        if let previousWorkout = UserDefaults.standard.object(forKey: "workout") as? String
            {
                output.text = previousWorkout
            }
        
        if let lastWeight = UserDefaults.standard.object(forKey: "weight") as? String
        {
            weightOutput.text = lastWeight
        }
    }
    
    
    private func StartRecording() throws {
        
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SfSpeechAudioBufferRecognitionRequest object")}
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in var isFinal = false
            
            if let result = result {
                self.textview.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.dictatebutton.isEnabled = true
                self.dictatebutton.setTitle("Start Speaking", for: [])
            }
            
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        try audioEngine.start()
        
        textview.text = "Recording your workout!"
        
    }
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            dictatebutton.isEnabled = true
            dictatebutton.setTitle("Start Recording", for: [])
        } else {
            dictatebutton.isEnabled = false
            dictatebutton.setTitle("Recognition not available.", for: .disabled)
        }
        
    }
    
    @IBAction func dictateaction(_ sender: Any) {
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            dictatebutton.isEnabled = false
            dictatebutton.setTitle("Ending...", for: .disabled)
        } else {
            try! StartRecording()
            dictatebutton.setTitle("Stop Recording", for: [])
        }
        output2.text = textview.text
        UserDefaults.standard.set( textview.text , forKey: "workout")
    }
}
