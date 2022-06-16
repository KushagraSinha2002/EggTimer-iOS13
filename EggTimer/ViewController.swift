//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let eggTimes = ["Soft":3,"Medium":4,"Hard":7]
    
    @IBOutlet weak var Status: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressPercentage: UILabel!
    @IBOutlet weak var timeLeft: UILabel!
    
    var timer = Timer()
    var player: AVAudioPlayer!
    
    var timePassed = 0.0
    var totalTime = 0.0
    
    func playSound() {
        let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
        
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        timer.invalidate()
        self.Status.text = "Preparing"
        //Reset timings
        timePassed = 0.0
        totalTime = 0
        
        // Stop playing audio if previousy running
        if player?.isPlaying == true {
            player?.stop()
        }
        
        let hardness = sender.currentTitle!
        totalTime = Double(eggTimes[hardness]!)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] (Timer) in
            if self.timePassed < self.totalTime {
                self.timePassed += 1
                print("Time Passed = \(timePassed) Seconds")
                self.progressBar.progress = Float(self.timePassed/self.totalTime)
                self.progressPercentage.text = "\(Int((self.timePassed/self.totalTime)*100)) %"
                let (m,s) = secondsToHoursMinutesSeconds(Int(totalTime-timePassed))
                self.timeLeft.text = "Time Left \(m) Min \(s) Sec"
                
            } else {
                Timer.invalidate()
                self.Status.text = "Done"
                playSound()
            }
        }
    }
}
