//
//  Logic.swift
//  Sky Caramba
//
//  Created by Mark Larah on 05/12/2015.
//  Copyright © 2015 magicmark. All rights reserved.
//

import Foundation

enum LogicState {
    case Waiting
    case Talking
    case Working
}

class Logic {
    
    var logicState = LogicState.Waiting
    
    var recorder = Recorder()
    var witWrapper: WitWrapper? = nil
    var api = API()
    
    var singleton:Logic? = nil;
    
    init () {
        recorder.delegate = self
    }
    
    func shared() -> Logic  {
        if self.singleton == nil {
            self.singleton = Logic()
        }
        
        return self.singleton!;
    }
    
    func buttonClicked () {
        
        if recorder.recorderState == .Requesting {
            return ;
        }
        
        if recorder.recorderState == .Off {
            recorder.record()
        } else if recorder.recorderState == .Listening {
            recorder.stop()
        }
        
    }
    
}


extension Logic: RecorderDelegate {
    func gotAudio (data: NSData) {
        witWrapper = WitWrapper(audio: data, callback: { result in
            print(result)
        })
    }
}