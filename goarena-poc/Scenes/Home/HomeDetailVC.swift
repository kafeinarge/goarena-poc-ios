//
//  HomeDetailVC.swift
//  goarena-poc
//
//  Created by serhat akalin on 28.01.2021.
//

import UIKit

class HomeDetailVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var mediaFrameView: UIView!
    @IBOutlet weak var textContentTextView: UITextView!
    @IBOutlet weak var mediaFrameViewHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
   
    }

    func convertBase64StringToImage (imageBase64String: String) -> UIImage {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image ?? UIImage()
    }
}

