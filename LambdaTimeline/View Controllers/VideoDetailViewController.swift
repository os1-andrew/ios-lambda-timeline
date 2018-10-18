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
        saveButton.isEnabled = true
        updateViews()
        
        // Do any additional setup after loading the view.
    }
    //MARK: - IBAction
    @IBAction func save(_ sender: Any) {
        guard let videoURL = videoURL,
            let title = titleInput.text,
            title != "" else {
                presentInformationalAlertController(title: "Uh-oh", message: "Make sure that record a video and add a title before posting.")
                updateViews()
                return
        }
        
        guard let data = try? Data(contentsOf: videoURL) else {return}
        
        postController.createPost(with: title, ofType: .video, mediaData: data
        , ratio: 9/16) { (success) in
            DispatchQueue.main.async {
                if !success {
                    self.presentInformationalAlertController(title: "Error", message: "Unable to create post. Try again.")
                } else {
                    self.deleteTempVideoFile(at: videoURL)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            
            return
        }
        saveButton.isEnabled = false
        
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
    private func deleteTempVideoFile(at url: URL){
        let fm = FileManager.default
        if (fm.isDeletableFile(atPath: url.path)){
            do{
                try fm.removeItem(at: url)
                print("removed")
            } catch {
                NSLog("Error deleting original file")
            }
            
        }
    }
    
    
    //MARK: - Properties
    var postsCollectionVC: PostsCollectionViewController?
    var videoURL: URL?
    var postController: PostController!
    @IBOutlet weak var videoPreviewView: VideoPlayerView!
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
}
