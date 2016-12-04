//
//  BetelController.swift
//  haerry
//
//  Created by Ferdinand Lösch on 03/12/2016.
//  Copyright © 2016 Ferdinand Lösch. All rights reserved.
//

import UIKit
import RestKit
import SpeechToTextV1
import Canvas

class BetelController: UIViewController {
    @IBOutlet weak var myHealth: UIProgressView!
    @IBOutlet weak var opHealth: UIProgressView!
    @IBOutlet weak var spell3: UILabel!
  
    @IBOutlet weak var won: UILabel!
    @IBOutlet weak var view2: CSAnimationView!
    @IBOutlet weak var spell2: UILabel!
    @IBOutlet weak var spell1: UILabel!
    
    weak var timer: Timer!
    

    
    
    
    var speechToText: SpeechToText!
    var speechToTextSession: SpeechToTextSession!
    var isStreaming = false
    
    let SpeechToTextUsername = "3614d082-4160-476e-b443-5f653ad1f0e1"
    let SpeechToTextPassword = "rlmwStMF8ctp"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        speechToText = SpeechToText(
            username: SpeechToTextUsername,
            password: SpeechToTextPassword
        )
        speechToTextSession = SpeechToTextSession(
            username: SpeechToTextUsername,
            password:  SpeechToTextPassword
        )
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        streamMicrophoneBasic()
        
    }
    func animator(view: CSAnimationView) {
        view.duration = 0.3
        view.delay = 0
        view.type = CSAnimationTypeMorph
        view.startCanvasAnimation()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func diss(){
        self.dismiss(animated: true, completion: nil)
        
    }
    public func streamMicrophoneBasic() {
        if !isStreaming {
            
            // update state
            // microphoneButton.setTitle("Stop Microphone", for: .normal)
            isStreaming = true
            
            
            
            // define recognition settings
            var settings = RecognitionSettings(contentType: .opus)
            settings.continuous = true
            settings.interimResults = true
            
            // define error function
            let failure = { (error: Error) in print(error) }
            
            // start recognizing microphone audio
            speechToText.recognizeMicrophone(settings: settings, failure: failure) {
                results in
                
                let string = results.bestTranscript
                
                print(string)
                
                if string.range(of: "casting") != nil {
                    
                    print("transmutation")
                    
                    // Stop the recorder instance
                    self.animator(view: self.view2)
                    self.isStreaming = false
                    self.won.isHidden = false
                    // stop recognizing microphone audio
                    self.speechToText.stopRecognizeMicrophone()
                    self.opHealth.setProgress(0, animated: true)
                    self.myHealth.setProgress(30, animated: true)
                    self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(BetelController.diss), userInfo: nil, repeats: false)
                    self.myCodeSpell(spell: "spell", Channel: "transmutation")

                    self.changeBackgroundColor()
                    
                    
                }
                if string.range(of: "bananas") != nil {
                    
                    print("YES")
                    
                  self.won.isHidden = false
                    self.animator(view: self.view2)
                    self.opHealth.setProgress(0, animated: true)
                    self.myHealth.setProgress(30, animated: true)
                    // Stop the recorder instance
                    self.myCodeSpell(spell: "spell", Channel: "bananas")

                    self.isStreaming = false
                    
                    self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(BetelController.diss), userInfo: nil, repeats: false)

                    // stop recognizing microphone audio
                    self.speechToText.stopRecognizeMicrophone()
                    
                    
                    self.changeBackgroundColor()
                    
                }
                if string.range(of: "strawberries") != nil {
                    
                    print("YES")
                    self.won.isHidden = false
                    // Stop the recorder instance
                    self.animator(view: self.view2)
                    self.isStreaming = false
                  
                    self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(BetelController.diss), userInfo: nil, repeats: false)
                    self.opHealth.setProgress(0, animated: true)
                    self.myHealth.setProgress(30, animated: true)
                    // stop recognizing microphone audio
                    self.speechToText.stopRecognizeMicrophone()
                    self.myCodeSpell(spell: "spell", Channel: "strawberries")
                    
                    self.changeBackgroundColor()
                    
                }
                
                
            }
            
        }
    }
    
    
    func animateSprite(){
        
        
    }
    
    func changeBackgroundColor(){
        
        self.view.backgroundColor = UIColor.red
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(changeBackgroundColor1), userInfo: nil, repeats: true)
    }
    
    func changeBackgroundColor1(){
        
        self.view.backgroundColor = UIColor(red: 38/255, green: 40/255, blue: 40/255, alpha: 1.0)
        
    }
    
    
    
    /**
     This function demonstrates how to use the more advanced
     `SpeechToTextSession` class to transcribe microphone audio.
     
     
     
     
     */
    
    func myCodeSpell(spell: String,Channel: String ) {
        let data = [spell: Channel]
        UIApplication.shared.client.publish(data, toChannel: "events", withCompletion: {(status) in
            
            
        })
        

    }
    

    func streamMicrophoneAdvanced() {
        if !isStreaming {
            
            // update state
            isStreaming = true
            
            // define callbacks
            speechToTextSession.onConnect = { print("connected") }
            speechToTextSession.onDisconnect = { print("disconnected") }
            speechToTextSession.onError = { error in print(error) }
            speechToTextSession.onPowerData = { decibels in print(decibels) }
            speechToTextSession.onMicrophoneData = { data in print("received data") }
            
            
            // define recognition settings
            var settings = RecognitionSettings(contentType: .opus)
            settings.continuous = true
            settings.interimResults = true
            
            // start recognizing microphone audio
            speechToTextSession.connect()
            speechToTextSession.startRequest(settings: settings)
            speechToTextSession.startMicrophone()
            
        } else {
            
            // update state
            
            isStreaming = false
            
            // stop recognizing microphone audio
            speechToTextSession.stopMicrophone()
            speechToTextSession.stopRequest()
            speechToTextSession.disconnect()
        }
    }
    
    
}
