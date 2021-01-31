//
//  FilterVC.swift
//  goarena-poc
//
//  Created by serhat akalin on 1.02.2021.
//

import UIKit
import PKHUD

class FilterVC: BaseVC<FilterViewModel> {
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage!
    var original: UIImage!
    let context = CIContext(options: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        original = image
        imageView.image = image
    }

    @IBAction func filter1Action(_ sender: Any) {
        let inputImage = original ?? UIImage()
        if let currentFilter = CIFilter(name: "CISepiaTone") {
            HUD.show(.progress)
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter.setValue(0.5, forKey: kCIInputIntensityKey)

            if let output = currentFilter.outputImage {
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    let processedImage = UIImage(cgImage: cgimg)
                    image = processedImage
                    imageView.image = image
                }
            }
            HUD.hide()
        }
    }


    @IBAction func filter2Action(_ sender: Any) {
        let inputImage = original ?? UIImage()
        if let currentFilter = CIFilter(name: "CIBloom") {
            HUD.show(.progress)
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter.setValue(0.5, forKey: kCIInputIntensityKey)
            currentFilter.setValue(5.0, forKey: kCIInputIntensityKey)

            if let output = currentFilter.outputImage {
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    let processedImage = UIImage(cgImage: cgimg)
                    image = processedImage
                    imageView.image = image
                }
            }
            HUD.hide()
        }
    }

    @IBAction func pop(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func ok(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                SwiftEventBus.post(SubscribeViewState.NEW_FEED_FILTER_OK.rawValue, sender: self.image)
            })
    }
}
