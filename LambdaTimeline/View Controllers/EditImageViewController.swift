//
//  EditImageViewController.swift
//  LambdaTimeline
//
//  Created by Andrew Dhan on 10/16/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class EditImageViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard isViewLoaded else {NSLog("View not loaded"); return}
        
        imageView.image = image
    }
    
    //MARK: - IBActions
    @IBAction func addVintageEffect(_ sender: UISegmentedControl) {
        let index = vintageSegmentControl.selectedSegmentIndex
        switch index {
        case 1:
            vintageFilter = CIFilter(name: "CIPhotoEffectChrome")!
        case 2:
            vintageFilter = CIFilter(name: "CIPhotoEffectInstant")!
        case 3:
            vintageFilter = CIFilter(name: "CIPhotoEffectTransfer")!
        default:
            vintageFilter = nil
        }
        updateImage()
    }
    @IBAction func makeChanges(_ sender: UISlider) {
        updateImage()
    }
    @IBAction func saveChanges(_ sender: Any) {
        guard let image = imageView.image else {return}
        delegate?.finishImageEdit(image: image)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //MARK: - Methods
    
    private func updateImage(){
        guard let image = image else {return}
        imageView.image = filterImage(image: image)
    }
    private func filterImage(image:UIImage) -> UIImage?{
        guard let cgImage = image.cgImage else {return nil}
        let ciImage = CIImage(cgImage: cgImage)
        
        var outputImage:CIImage? = ciImage
        if vintageFilter != nil {
            vintageFilter!.setValue(outputImage, forKey: kCIInputImageKey)
            outputImage = vintageFilter!.outputImage
        }
        vibranceFilter.setValue(outputImage, forKey: kCIInputImageKey)
        vibranceFilter.setValue(vibranceSlider.value, forKey: "inputAmount")
        vignetteFilter.setValue(vibranceFilter.outputImage, forKey: kCIInputImageKey)
        vignetteFilter.setValue(IntensitySlider.value, forKey: "inputIntensity")
        vignetteFilter.setValue(radiusSlider.value, forKey: "inputRadius")
        
        guard let outputCIImage = vignetteFilter.outputImage,
            let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {return nil}
        
        return UIImage(cgImage: outputCGImage)
        
    }
    //MARK: - Properties
    var image: UIImage?
    weak var delegate: EditImageVCDelegate?
    
    private let context = CIContext(options: nil)
    
    private var vintageFilter: CIFilter?
    private let vibranceFilter = CIFilter(name: "CIVibrance")!
    private let vignetteFilter = CIFilter(name: "CIVignetteEffect")!
    
    @IBOutlet weak var vintageSegmentControl: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var vibranceSlider: UISlider!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var IntensitySlider: UISlider!
}

protocol EditImageVCDelegate: class{
    func finishImageEdit(image: UIImage)
}
