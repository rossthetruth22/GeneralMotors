//
//  NetworkMethods.swift
//  GeneralMotors
//
//  Created by Royce Reynolds on 10/6/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//

import Foundation

extension NetworkService{
    
    enum MyErrors:LocalizedError{
        
        case dataError
        
        var errorDescription: String?{
            switch self{
            case .dataError:
                return "Problem with data"
            }
        }
    }
    
    func getSongsFromiTunes(_ search: String, completionHandlerForSongs: @escaping (_ songs: [Song]?, _ error: Error?) -> Void ){
        
        //Method for searching iTunes data
        let parameters = ["term":search] as [String:AnyObject]
        
        getDataMethod(parameters: parameters) { (result, error) in
            //Check for error
            if let error = error{
                completionHandlerForSongs(nil, error)
            }else{
                //If for some unknown reason we can't unwrap
                guard let result = result else{
                    completionHandlerForSongs(nil, MyErrors.dataError)
                    return
                }
                
                //Convert JSON into Songs we can use
                let returnSongs = Song.parseIntoSong(result)
                completionHandlerForSongs(returnSongs, nil)
            }
        }
        
    }
    
}
