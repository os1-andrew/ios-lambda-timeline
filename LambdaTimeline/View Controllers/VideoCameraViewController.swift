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
    @IBAction func save(_ sender: Any) {
        guard let finishedOutput = finishedOutput,
            let finishedOutputURL = finishedOutput.outputFileURL,
            let title = titleInput.text,
        title != "" else{
                presentInformationalAlertController(title: "Uh-oh", message: "Make sure that record a video and add a title before posting.")
                return
        }

        let data = try! Data(contentsOf: finishedOutputURL)
        postController.createPost(with: title, ofType: .video, mediaData: data
        , ratio: 16/9) { (success) in
            DispatchQueue.main.async {
                self.presentInformationalAlertController(title: "Error", message: "Unable to create post. Try again.")
            }
            return
        }
        
    }
    //MARK: - AVCaptureFileOutputRecordingDelegate Methods
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.recordButton.setImage(UIImage(named: "Record"), for: .normal)
        }
        
    }
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            self.recordButton.setImage(UIImage(named: "Stop"), for: .normal)
            self.finishedOutput = output
        }
    }
    
    //MARK: Methods to be deleted
    private func saveVideo(url: URL){
        PHPhotoLibrary.requestAuthorization { (status) in
            guard status == .authorized else {return}
            PHPhotoLibrary.shared().performChanges({
                PHAssetCreationRequest.creationRequestForAssetFromVideo(atFileURL: url)
            }, completionHandler: { (success, error) in
                if let error = error {
                    NSLog("Error saving video: \(error)")
                    return
                }
                self.deleteTempVideoFile(at: url)
            })
        }
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
    private var finishedOutput: AVCaptureFileOutput?
    private var captureSession:AVCaptureSession!
    private var recordOutput: AVCaptureMovieFileOutput!
    var postController: PostController!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var previewView: VideoCameraPreviewView!
}
