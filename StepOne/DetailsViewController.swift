//
//  ViewController.swift
//  StepOne
//
//  Created by WeAreOpenSource.me on 24/04/2015.
//  Copyright (c) 2015 WeAreOpenSource.me rights reserved.
//

// tuto : http://jamesonquave.com/blog/developing-ios-8-apps-using-swift-animations-audio-and-custom-table-view-cells/

import UIKit
import MediaPlayer

class DetailsViewController: UIViewController, APIControllerProtocol {
    
    /*************************************************/
    // Main
    /*************************************************/
    
    // Boulet
    /*************************/
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tracksTableView: UITableView!
    @IBOutlet var myView: UIView!
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    // Var
    /*************************/
    var album: Album?
    var tracks = [Track]()
    lazy var api : APIController = APIController(delegate: self)
    var mediaPlayer: MPMoviePlayerController = MPMoviePlayerController()
    
    // init
    /*************************/
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Base
    /*************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        // custom
        // ---------------------
        // back button text
        let backButton = UIBarButtonItem(
            title: "",
            style: UIBarButtonItemStyle.Plain,
            target: nil,
            action: nil
        );
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        // ---------------------
        
        // get data
        titleLabel.text = self.album?.title
        artistLabel.text = self.album?.artistName
        genreLabel.text = self.album?.primaryGenreName

        albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album!.largeImageURL)!)!)
        // Load in tracks
        if self.album != nil {
            api.lookupAlbum(self.album!.collectionId)
        }
        
        
        // animation
        // ---------------------
        // img
        albumCover.alpha = 0
        UIView.animateWithDuration(0.3, delay: 0.5,
            options: nil, animations: {
                self.albumCover.alpha = 1
            }, completion: nil)
        
        // slide & alpha labels
        titleLabel.alpha = 0.3
        titleLabel.center.x += view.bounds.width
        UIView.animateWithDuration(0.3, delay: 0.3,
            options: nil, animations: {
                self.titleLabel.center.x -= self.view.bounds.width
            }, completion: { _ in
                UIView.animateWithDuration(0.3, delay: 0,
                    options: nil, animations: {
                        self.titleLabel.alpha = 1
                    }, completion: nil)
        })
        artistLabel.alpha = 0.3
        artistLabel.center.x += view.bounds.width
        UIView.animateWithDuration(0.3, delay: 0.4,
            options: nil, animations: {
                self.artistLabel.center.x -= self.view.bounds.width
            }, completion: { _ in
                UIView.animateWithDuration(0.3, delay: 0,
                    options: nil, animations: {
                        self.artistLabel.alpha = 1
                    }, completion: nil)
        })
        genreLabel.alpha = 0.3
        genreLabel.center.x += view.bounds.width
        UIView.animateWithDuration(0.3, delay: 0.4,
            options: nil, animations: {
                self.genreLabel.center.x -= self.view.bounds.width
            }, completion: { _ in
                UIView.animateWithDuration(0.3, delay: 0,
                    options: nil, animations: {
                        self.genreLabel.alpha = 1
                    }, completion: nil)
        })
        // ---------------------
    }
    
    // TableView
    /*************************/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TrackCell") as! TrackCell
        let track = tracks[indexPath.row]
        cell.titleLabel.text = track.title
        cell.playIcon.text = "▶︎"
        
        // custom
        // ---------------------
        cell.titleLabel?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
        cell.titleLabel?.textColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        cell.playIcon?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
        cell.playIcon?.textColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.4)
        
        let customColorView = UIView()
        customColorView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
        cell.selectedBackgroundView = customColorView
        // ---------------------

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var track = tracks[indexPath.row]
        mediaPlayer.stop()
        mediaPlayer.contentURL = NSURL(string: track.previewUrl)
        mediaPlayer.play()
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TrackCell {
            cell.playIcon.text = "◼︎"
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
    /*************************************************/
    // Functions
    /*************************************************/

    func didReceiveAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tracks = Track.tracksWithJSON(results)
            self.tracksTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
}