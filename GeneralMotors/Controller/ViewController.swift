//
//  ViewController.swift
//  GeneralMotors
//
//  Created by Royce Reynolds on 10/4/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var songs = [Song]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchSongText: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isHidden = true
        searchSongText.delegate = self
                
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //If we touch outside keyboard we want to dismiss it by resigning first responder
        view.endEditing(true)
    }
    
    @IBAction func showButtonTapped(_ sender: Any) {
        displayDataInTable()
        
    }
    
    func clearTableView(){
        //Clear everything from the tableView
        songs.removeAll()
        tableView.separatorStyle = .none
        tableView.reloadData()
        tableView.isHidden = true
    }
    
    func displayDataInTable(){
        //Don't want blank text
        guard let text = searchSongText.text, text.count > 0 else{return}
        
        //Activity spinner
        let activityView = UIActivityIndicatorView()
        activityView.style = .large
        activityView.center = CGPoint(x: tableView.frame.size.width/2, y: tableView.frame.size.height/2)
        activityView.isHidden = false
        activityView.hidesWhenStopped = true
        tableView.addSubview(activityView)
        
        self.tableView.isHidden = false
        activityView.startAnimating()
        
        //Call to get Song data
        let network = NetworkService.sharedInstance()
        network.getSongsFromiTunes(text) { (songs, error) in
            if let error = error{
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    activityView.stopAnimating()
                }
            }else{
                if let returnedSongs = songs{
                    self.songs = returnedSongs
                    //Load tableView with data
                    DispatchQueue.main.async{
                        activityView.stopAnimating()
                        self.searchSongText.resignFirstResponder()
                        self.tableView.separatorStyle = .singleLine
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
}

extension ViewController: UITextFieldDelegate{
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        displayDataInTable()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        clearTableView()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        clearTableView()
        return true
    }
    
}

extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as? SongCell{
            let currentSong = songs[indexPath.row]
            cell.artistName.text = currentSong.artistName
            cell.trackName.text = currentSong.trackName
            cell.trackPrice.text = currentSong.trackPrice
            cell.primaryGenreName.text = currentSong.primaryGenreName
            cell.releaseDate.text = currentSong.releaseDate
            
            return cell
        }
        
        return UITableViewCell()
    }
    
}
