//
//  VideoCameraViewController.swift
//  LambdaTimeline
//
//  Created by Andrew Dhan on 10/17/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class VideoCameraViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    //MARK: - IBAction
    
    @IBAction func toggleRecord(_ sender: Any) {
        if recordOutput.isRecording{
            recordOutput.stopRecording()
        } else {
            recordOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    //MARK: - AVCaptureFileOutputRecordingDelegate Methods
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.recordButton.setImage(UIImage(named: "Stop"), for: .normal)
        }
        
    }
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            self.recordButton.setImage(UIImage(named: "Record"), for: .normal)
            self.outputFileURL = outputFileURL
            self.performSegue(withIdentifier: "ShowVideoDetail", sender: nil)
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowVideoDetail" {
            guard let destinationVC = segue.destination as? VideoDetailViewController,
                let outputFileURL = outputFileURL else {return}
            destinationVC.videoURL = outputFileURL
            destinationVC.postController = postController
            destinationVC.postsCollectionVC = self.navigationController?.parent as? PostsCollectionViewController
        }
    }
    
    //MARK: - Private Methods
    private func setupCaptureSession(){
        let captureSession = AVCaptureSession()
        captureSession.beginConfiguration()
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                  for: .video, position: .unspecified)
        guard
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
            captureSession.canAddInput(videoDeviceInput)
            else { return }
        captureSession.addInput(videoDeviceInput)
        
        let fileOutput = AVCaptureMovieFileOutput()
        guard captureSession.canAddOutput(fileOutput) else { return}
        captureSession.sessionPreset = .hd1920x1080
        captureSession.addOutput(fileOutput)
        captureSession.commitConfiguration()
        self.captureSession = captureSession
        previewView.videoPreviewLayer.session = captureSession
        self.recordOutput = fileOutput
        
    }
    
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let url = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return url.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
    }
    
    
    
    //MARK: - Properties
    private var outputFileURL: URL?
    private var captureSession:AVCaptureSession!
    private var recordOutput: AVCaptureMovieFileOutput!
    var postController: PostController!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var previewView: VideoCameraPreviewView!
}
