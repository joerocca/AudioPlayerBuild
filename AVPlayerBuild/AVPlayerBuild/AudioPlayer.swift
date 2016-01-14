//
//  AVPlayer.swift
//  AVPlayerBuild
//
//  Created by Joe Rocca on 1/14/16.
//  Copyright © 2016 joerocca. All rights reserved.
//

import UIKit
import AVFoundation


class AudioPlayer: UIView {

    
    //MARK: UI Element Vars
    
    let playButton: UIButton = {
        
        let playButton = UIButton()
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setTitle("Play", forState: .Normal)
        playButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        playButton.setTitleColor(UIColor(white: 0.0, alpha: 0.2), forState: .Highlighted)
        return playButton
    }()
    
    
    var durationLabel: UILabel = {
        
        let durationLabel = UILabel()
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.text = "-0:00"
        durationLabel.textAlignment = .Center
        durationLabel.font = UIFont.systemFontOfSize(10.0)
        durationLabel.textColor = UIColor.whiteColor()
        return durationLabel
    }()
    
    
    let timeElapsedLabel: UILabel = {
        
        let timeElapsedLabel = UILabel()
        timeElapsedLabel.translatesAutoresizingMaskIntoConstraints = false
        timeElapsedLabel.text = "0:00"
        timeElapsedLabel.textAlignment = .Center
        timeElapsedLabel.font = UIFont.systemFontOfSize(10.0)
        timeElapsedLabel.textColor = UIColor.whiteColor()
        return timeElapsedLabel
    }()
    
    
    let scrubber: UISlider = {
        
        let scrubber = UISlider()
        scrubber.translatesAutoresizingMaskIntoConstraints = false
        scrubber.minimumTrackTintColor = UIColor.whiteColor()
        scrubber.setThumbImage(UIImage(named: "sliderThumb"), forState: .Normal)
        return scrubber
    }()
    
    
    //MARK: Vars
    
    
    var player: AVPlayer?
    var isPaused: Bool = false
    var updateTimer: NSTimer?

    
    //MARK: Initialization
    
    init(frame: CGRect, audioURL: NSURL!)
    {
        
        super.init(frame: frame)
        
        self.configureViews()
        self.configureConstraints()
        self.configureAudioPlayer(audioURL)
    
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: Audio Player Configuration
    
    private func configureViews()
    {
        self.backgroundColor = UIColor.lightGrayColor()
        
        self.playButton.addTarget(self, action: "playPauseToggle", forControlEvents: .TouchUpInside)
        self.addSubview(self.playButton)

        self.addSubview(self.durationLabel)
        
        
        self.addSubview(self.timeElapsedLabel)
        
        
        self.scrubber.addTarget(self, action: "scrubberValueChanged:", forControlEvents: .ValueChanged)
        self.addSubview(self.scrubber)
        
        
    }
    
    private func configureConstraints()
    {
        
        let viewDict = ["playButton": playButton, "scrubber": scrubber, "durationLabel": durationLabel, "timeElapsedLabel": timeElapsedLabel]
        
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[playButton]-|", options: [], metrics: nil, views: viewDict))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[playButton]-10-[timeElapsedLabel(35)]-10-[scrubber]-10-[durationLabel(35)]-10-|", options: [], metrics: nil, views: viewDict))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[scrubber]-|", options: [], metrics: nil, views: viewDict))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[durationLabel]-|", options: [], metrics: nil, views: viewDict))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[timeElapsedLabel]-|", options: [], metrics: nil, views: viewDict))
    }
    
    private func configureAudioPlayer(audioURL: NSURL!)
    {
        let playerItem = AVPlayerItem(URL: audioURL)
        
        let durationInSeconds = Float(playerItem.asset.duration.seconds)
        
        self.scrubber.maximumValue = durationInSeconds
        
        self.durationLabel.text = "-\(self.formatSeconds(durationInSeconds))"
        
        self.player = AVPlayer(playerItem: playerItem)
        
        self.player?.pause()
    
    }
    
    
    //MARK: Audio Player Actions
    
    
    func playPauseToggle()
    {
        self.updateTimer?.invalidate()
        self.updateTimer = nil
        
        if !isPaused
        {
            self.playButton.setTitle("Pause", forState: .Normal)
            
            self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTime", userInfo: nil, repeats: true)
            
            self.player?.play()
            
            self.isPaused = true
        }
        else
        {
            self.playButton.setTitle("Play", forState: .Normal)
            
            self.player?.pause()
            
            self.isPaused = false
        }
    }
    
    
    func scrubberValueChanged(sender: UISlider)
    {
        print(sender.value)
        self.player?.seekToTime(CMTime(seconds: Double(sender.value), preferredTimescale: 1))
        
        
    }
    
    
    //MARK: Audio Player Updates
    
    func updateTime()
    {
        self.scrubber.setValue(Float(self.player!.currentTime().seconds), animated: true)
        self.durationLabel.text = "-\(self.formatSeconds(Float(self.player!.currentItem!.asset.duration.seconds - self.player!.currentTime().seconds)))"
        self.timeElapsedLabel.text = self.formatSeconds(Float(self.player!.currentTime().seconds))
    }
    
    
    
    //MARK: Extras
    
    func formatSeconds(seconds: Float) -> String
    {
        let minutes = floor(roundf(seconds)/60)
        let seconds = roundf(seconds) - (minutes * 60)
        
        let roundedMinutes = lroundf(minutes)
        let roundedSeconds = lroundf(seconds)
        
        
        let time = String(format: "%d:%02d", arguments: [roundedMinutes, roundedSeconds])
        
        return time
    }
    
    
}
