//
//  Song.swift
//  GeneralMotors
//
//  Created by Royce Reynolds on 10/5/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//

import Foundation

struct Song{
    
    
    
    
    static func parseIntoSong(_ json: AnyObject){
        
        guard let jsonData = json["results"] as? [String:AnyObject] else{return}
        
        
    }
}
