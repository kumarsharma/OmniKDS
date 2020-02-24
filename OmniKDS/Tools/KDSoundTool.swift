//
//  KDSoundTool.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 06/02/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit
import AVFoundation

let sharedSoundManager = KDSoundTool ()

class KDSoundTool: NSObject {

    
    func playSound(soundName:String){
        
        var soundEffect : AVAudioPlayer?
        let path = Bundle.main.path(forResource: soundName, ofType: "m4r")!
        let url = URL(fileURLWithPath: path)
        do {
            
            soundEffect=try AVAudioPlayer(contentsOf: url)
            soundEffect?.play()
        }catch {
            
        }
    }
    
}
