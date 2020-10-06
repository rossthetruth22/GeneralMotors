//
//  Song.swift
//  GeneralMotors
//
//  Created by Royce Reynolds on 10/5/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//

import Foundation

struct Song{
    
    var artistName: String
    var trackName: String
    var releaseDate: String
    var primaryGenreName: String
    var trackPrice: String
    
    
    init(artistName: String, trackName: String, releaseDate: String, primaryGenreName: String, trackPrice: String){
        self.artistName = artistName
        self.trackName = trackName
        self.releaseDate = releaseDate
        self.primaryGenreName = primaryGenreName
        self.trackPrice = trackPrice
    }
    
    
    static func parseIntoSong(_ json: AnyObject) -> [Song]{
        
        guard let jsonData = json["results"] as? [[String:AnyObject]] else{return [Song]()}
        
        var returnSongs = [Song]()
        for song in jsonData{
            guard let artistName = song["artistName"] as? String,
            let trackName = song["trackName"] as? String,
            let releaseDate = song["releaseDate"] as? String,
            let primaryGenreName = song["primaryGenre"] as? String,
                let trackPrice = song["trackPrice"] as? String else{
                    continue
            }
            
            let currentSong = Song(artistName: artistName, trackName: trackName, releaseDate: releaseDate, primaryGenreName: primaryGenreName, trackPrice: trackPrice)
            returnSongs.append(currentSong)
        }
        
        return returnSongs
    }
}
