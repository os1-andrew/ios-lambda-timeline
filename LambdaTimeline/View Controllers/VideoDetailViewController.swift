//
//  VideoDetailViewController.swift
//  LambdaTimeline
//
//  Created by Andrew Dhan on 10/17/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation

class VideoDetailViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
        
        // Do any additional setup after loading the view.
    }
    //MARK: - IBAction
    @IBAction func save(_ sender: Any) {
        //        guard let finishedOutput = finishedOutput,
        //            let finishedOutputURL = finishedOutput.outputFileURL,
        //            let title = titleInput.text,
        //            title != "" else{
        //                presentInformationalAlertController(title: "Uh-oh", message: "Make sure that record a video and add a title before posting.")
        //                return
        //        }
        //
        //        let data = try! Data(contentsOf: finishedOutputURL)
        //        postController.createPost(with: title, ofType: .video, mediaData: data
        //        , ratio: 16/9) { (success) in
        //            DispatchQueue.main.async {
        //                self.presentInformationalAlertController(title: "Error", message: "Unable to create post. Try again.")
        //            }
        //            return
        //        }
    }
    //MARK: - Private Methods
    private func updateViews(){
        guard let videoURL = videoURL, isViewLoaded else {return}
        
        let playerItem = AVPlayerItem(url: videoURL)
        let player = AVQueuePlayer(playerItem: playerItem)
        videoPreviewView.player = player

        videoPreviewView.playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        
        player.play()
        

        
    }
    
    //MARK: - Properties
    var videoURL: URL?
    @IBOutlet weak var videoPreviewView: VideoPlayerView!
    @IBOutlet weak var titleInput: UITextField!
}
