//
//  ViewController.swift
//  AVPlayerBuild
//
//  Created by Joe Rocca on 1/14/16.
//  Copyright © 2016 joerocca. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let av = AudioPlayer(audioURL: NSURL(string: "http://jrocca.com/CannedHeat.mp3"))
        av.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(av)
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-60-[av(40)]", options: [], metrics: nil, views: ["av": av]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[av]-|", options: [], metrics: nil, views: ["av": av]))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

