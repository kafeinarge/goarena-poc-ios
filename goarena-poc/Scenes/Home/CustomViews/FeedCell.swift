//
//  FeedCell.swift
//  goarena-poc
//
//  Created by serhat akalin on 28.01.2021.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var cardBackgroundView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userSubtitleLabel: UILabel!
    @IBOutlet weak var approvalStatusFrameView: UIView!
    @IBOutlet weak var approvalStatusImageView: UIImageView!
    @IBOutlet weak var approvalStatusViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            approvalStatusViewHeightConstraint.constant = 0
        }
    }
    
    @IBOutlet weak var approvalStatusLabel: UILabel!
    @IBOutlet weak var textContentTextView: UITextView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var mediaFrameView: UIView!
    @IBOutlet weak var mediaFrameViewHeightConstraint: NSLayoutConstraint!
    var post: Content?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.cardBackgroundView.clipsToBounds = true
        self.cardBackgroundView.layer.cornerRadius = 25
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3.0)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        layer.backgroundColor = UIColor.clear.cgColor

        usernameLabel.addTapGesture(target: self, action: #selector(profileTapped(_:)))
        userSubtitleLabel.addTapGesture(target: self, action: #selector(profileTapped(_:)))
        profileImageView.addTapGesture(target: self, action: #selector(profileTapped(_:)))
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.layer.masksToBounds = true
    }

    func setup(_ post: Content) {
        self.post = post
        cardBackgroundView.backgroundColor = UIColor.init(hexString: "#FECB00")

        self.usernameLabel.text = (post.user?.name)! + " " + (post.user?.surname)!
        self.userSubtitleLabel.text = post.user?.title
       
        if let content = post.text {
            self.textContentTextView.text = "\(content)"
        }
        
        feedImageView.image = convertBase64StringToImage(imageBase64String: post.preview ?? "")
    }
    
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image ?? UIImage()
    }


    @objc func profileTapped(_ sender: Any) {

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
