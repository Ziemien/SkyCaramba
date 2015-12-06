//
//  API.swift
//  Sky Caramba
//
//  Created by Mark Larah on 05/12/2015.
//  Copyright © 2015 magicmark. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol JSONDelegate {
    func callback(json: JSON);
}

class API {
    
    var endpoint = "https://lvhxyllyjg.localtunnel.me/"
    
    init () {
        
    }
    
    func sendOpinion(movie: NSString, opinion: NSString, ctrl: JSONDelegate) {
        Alamofire.request(
            .POST,
            endpoint.stringByAppendingString("ilike"),
            parameters: ["item": movie, "speech" :opinion])
            .responseJSON { response in
                
                let json = JSON(data: response.data!)
                ctrl.callback(json)
        }
    }
    
    func getInitialSuggestion(movie: NSString, ctrl: JSONDelegate) {
        Alamofire.request(
            .POST,
            endpoint.stringByAppendingString("media"),
            parameters: ["item": movie])
            .responseJSON { response in
                
                let json = JSON(data: response.data!)
                ctrl.callback(json)
        }
    }
    
    func getMovieInfo(movie: NSString, ctrl: JSONDelegate) {

        Alamofire.request(
            .POST,
            endpoint.stringByAppendingString("movie"),
            parameters: ["item": movie])
            .responseJSON { response in

                let json = JSON(data: response.data!)
                ctrl.callback(json)
                
        }
    }
    
}