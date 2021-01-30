//
//  NewFeed.swift
//  goarena-poc
//
//  Created by serhat akalin on 29.01.2021.
//

import UIKit
import Mantis

class NewFeedVC: BaseVC<NewFeedViewModel>, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {

    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var toolBarView: UIView!
    private let postTextMaxLength = 1000
    private let postTextAlertThreshold = 950
    var textColor: UIColor = .red
    private var pickerController: UIImagePickerController?

    override func viewDidLoad() {
        super.viewDidLoad()
        onSubscribe()
        pickerController = UIImagePickerController()
        pickerController?.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(cameraChanged), name: NSNotification.Name(rawValue: "AVCaptureDeviceDidStartRunningNotification"), object: nil)
    }

    override func showPicker(source: UIImagePickerController.SourceType) {
        guard let picker = pickerController else { return }
        picker.sourceType = source
        present(picker, animated: true)
    }

    @objc func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        picker.dismiss(animated: true) {
            let config = Mantis.Config()
            let cropViewController = Mantis.cropViewController(image: image,
                config: config)
            cropViewController.modalPresentationStyle = .fullScreen
            cropViewController.delegate = self
            self.present(cropViewController, animated: true)
        }
    }

    @objc
    func cameraChanged(notification: Notification) {
        guard let picker = pickerController else { return }
        if (picker.cameraDevice == UIImagePickerController.CameraDevice.front) {
            picker.cameraViewTransform = .identity
            picker.cameraViewTransform = picker.cameraViewTransform.scaledBy(x: -1, y: 1)
        } else {
            picker.cameraViewTransform = .identity
        }
    }
    @IBAction func cameraAction(_ sender: Any) {
        selectImage()
    }

    @IBAction func approveAction(_ sender: Any) {
        if postTextView.text.isEmpty && imageView.image == nil {
            return
        }
        let image = imageView.image ?? UIImage()
        let data = image.jpegData(compressionQuality: 0.8) ?? Data()
        viewModel.postFeed(data, text: postTextView.text)
    }

    @IBAction func pop(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    private func onSubscribe() {
        SwiftEventBus.onMainThread(self, name: SubscribeViewState.NEW_FEED_SUCCESS.rawValue) { result in
            if let event = result!.object as? Bool {
                if event == true {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        self.pop(self)
                    })
                }
            }
        }
    }

    func updateTextView(textView: UITextView) {
        let count = textView.text.trimmingCharacters(in: .whitespaces).utf16.count
        if (count < postTextAlertThreshold) {
            textColor = UIColor.blue
        } else if (count >= postTextAlertThreshold && count < postTextMaxLength) {
            textColor = UIColor.orange
        } else {
            textColor = UIColor.red
        }

    }

    func textView(postTextView: UITextView, _ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let allowedLength = postTextMaxLength - textView.text.utf16.count + range.length
        if (text.utf16.count > allowedLength) || text == "#" {
            if (text.utf16.count > 1) {
                let limitedString = (text as NSString).substring(to: allowedLength)
                let newText = (textView.text as NSString).replacingCharacters(in: range, with: limitedString)
                textView.text = newText
                updateTextView(textView: postTextView)
            }
            return false
        }
        return true
    }

    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
        self.imageView.image = cropped
        self.dismiss(animated: true)
    }

    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        self.dismiss(animated: true)
    }

}

extension NewFeedVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateTextView(textView: postTextView)
        setTextViewHeight(arg: textView)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }

    func setTextViewHeight(arg: UITextView) {
        guard (toolBarView.frame.origin.y - postTextView.frame.minY - 90.0) < arg.frame.height else { return }
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.isScrollEnabled = true
    }
}