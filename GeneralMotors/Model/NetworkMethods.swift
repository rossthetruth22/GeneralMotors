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
        
        let parameters = ["term":search] as [String:AnyObject]
        
        getDataMethod(parameters: parameters) { (result, error) in
            if let error = error{
                completionHandlerForSongs(nil, error)
            }else{
                guard let result = result else{
                    completionHandlerForSongs(nil, MyErrors.dataError)
                    return
                }
                
                let returnSongs = Song.parseIntoSong(result)
                print(returnSongs)
                completionHandlerForSongs(returnSongs, nil)
            }
        }
        
    }
    
}
