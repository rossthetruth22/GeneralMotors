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
        
        //Loop through each dictionary to extract Song data
        for song in jsonData{
            guard let artistName = song["artistName"] as? String,
            let trackName = song["trackName"] as? String,
            let releaseDate = song["releaseDate"] as? String,
            let primaryGenreName = song["primaryGenreName"] as? String,
            let trackPrice = song["trackPrice"] as? Double else{
                continue
            }
            
            //Convert releaseDate to a nicer looking date
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            let dateObject = dateFormatter.date(from: releaseDate)!
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            let formattedDate = dateFormatter.string(from: dateObject)
            
            //Create Song
            let currentSong = Song(artistName: artistName, trackName: trackName, releaseDate: formattedDate, primaryGenreName: primaryGenreName, trackPrice: "$\(trackPrice)")
            
            returnSongs.append(currentSong)
        }
        
        return returnSongs
    }
}
