//
//  VideoCameraViewController.swift
//  LambdaTimeline
//
//  Created by Andrew Dhan on 10/17/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation

class VideoCameraViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            self.setupCaptureSession()
            
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.setupCaptureSession()
                }
            }
            
        case .denied: // The user has previously denied access.
            return
        case .restricted: // The user can't grant access due to restrictions.
            return
        }
        
    }
    //MARK: - IBAction

    @IBAction func toggleRecord(_ sender: Any) {
        
    }
    @IBAction func save(_ sender: Any) {
        
    }
    
    //MARK: - Private Methods
    private func setupCaptureSession(){
        
    }
    
    //MARK: - Properties
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var previewView: VideoCameraPreviewView!
}
