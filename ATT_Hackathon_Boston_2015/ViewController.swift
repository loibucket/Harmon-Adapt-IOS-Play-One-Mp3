//
//  ViewController.swift
//  ATT_Hackathon_Boston_2015
//
//  Created by loichengllc on 7/11/15.
//  Copyright (c) 2015 Loi Cheng LLC. All rights reserved.
//

import UIKit

let kLicenseKeyGlobal = "2FA8-2FD6-C27D-47E8-A256-D011-3751-2BD6"

class ViewController: UIViewController, HKWPlayerEventHandlerDelegate, HKWDeviceEventHandlerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("initializing")
        HKWControlHandler.sharedInstance().initializeHKWirelessController(kLicenseKeyGlobal)
        println("initialized")
        
        HKWDeviceEventHandlerSingleton.sharedInstance().delegate = self
        HKWPlayerEventHandlerSingleton.sharedInstance().delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if !HKWControlHandler.sharedInstance().initializing() && !HKWControlHandler.sharedInstance().isInitialized() {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                if HKWControlHandler.sharedInstance().initializeHKWirelessController(kLicenseKeyGlobal) != 0 {
                    println("initializeHKWirelessControl failed : invalid license key")
                    return
                }
                println("initializeHKWirelessCont   \\\rol - OK");
            })
        }
        
        // add the speaker the current playback session
        var varDeviceId : CLongLong = 182794263804080
        while (!HKWControlHandler.sharedInstance().addDeviceToSession(varDeviceId)){
            println("Not Connected")
            sleep(2)
            println("Rescan")
            HKWControlHandler.sharedInstance().refreshDeviceInfoOnce()
            println("Devices Found")
            println(HKWControlHandler.sharedInstance().getDeviceCount())
            println("Attempting to Connect")
        }
        
        println("Connected")

        playSong()

    }
    
    func playSong(){
        while (!HKWControlHandler.sharedInstance().isPlaying()){
            println("Not Playing")
            sleep(2)
            println("Attempting to Replay")
            // play audio file
            
            let assetUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("mp3file", ofType: "mp3")!)
            HKWControlHandler.sharedInstance().playCAF(assetUrl, songName: "song", resumeFlag: false)
        }
        HKWControlHandler.sharedInstance().setVolume(50)
        println("Playing")
    }
    
    func hkwPlayEnded() {
        println("Play Ended")
        println("Replay")
        playSong()
    }
    
    func hkwDeviceStateUpdated(deviceId: Int64, withReason reason: Int) {
        //println("Device State Updated")
    }
    
    func hkwErrorOccurred(errorCode: Int, withErrorMessage errorMesg: String!) {
        println("Error: \(errorMesg)")
    }
    
}

