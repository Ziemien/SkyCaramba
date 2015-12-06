//
//  WitWrapper.swift
//  Sky Caramba
//
//  Created by Mark Larah on 05/12/2015.
//  Copyright © 2015 magicmark. All rights reserved.
//

import Foundation

enum WitState {
    case Off
    case Requesting
}

class WitWrapper {
    
    var audio: NSData?
    var callback: ((string: NSString) -> ())?
    
    init (audio: NSData, callback: (string: NSString) -> ()) {
        self.audio = audio
        self.callback = callback
        startRequest()
    }
    
    var witState = WitState.Off
    
    let endpoint: NSURL = NSURL(string: "https://api.wit.ai/speech?v=20141022")!
    var request: NSMutableURLRequest?
    
    
    func startRequest () {
        witState = .Requesting
        request = NSMutableURLRequest(URL: endpoint)
        request!.HTTPMethod = "POST"
        request!.HTTPBody = audio
        request!.setValue("Bearer CA5Y5ULCQ2QHBDFC5TM42SBCOJ2RXOXS", forHTTPHeaderField: "Authorization")
        request!.setValue("audio/wav", forHTTPHeaderField: "Content-Type")
        
        NSURLConnection.sendAsynchronousRequest(request!, queue: NSOperationQueue(), completionHandler: completion)
    }
    
    func completion (response: NSURLResponse?, data: NSData?, error: NSError?) {
        callback!(string: NSString(data: data!, encoding: NSUTF8StringEncoding)!)
    }
    
}