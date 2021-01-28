//
//  HomeVM.swift
//  goarena-poc
//
//  Created by serhat akalin on 27.01.2021.
//

import UIKit
import Combine

protocol ViewModelData {}

class BaseVC<VM>: UIViewController where VM: BaseViewModel {
    lazy var viewModel: VM = VM()
    var data: ViewModelData?
    private var stateObserver: NSObjectProtocol?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.observeViewStateChanges()
    }

    deinit {
        guard let stateObserver = stateObserver else { return }
        NotificationCenter.default.removeObserver(stateObserver, name: viewModel.stateChanged, object: nil)
    }

    private func observeViewStateChanges() {
        stateObserver = NotificationCenter.default.addObserver(forName: viewModel.stateChanged,
                                                               object: nil,
                                                               queue: nil) { [weak self] note in
            guard let state = note.userInfo?["state"] as? ViewState else { return }
            self?.onStateChanged(state)
        }
    }
    
    func onStateChanged(_ state: ViewState) {
        fatalError("onStateChanged: Not implemented.")
    }
    
    func showPicker(source: UIImagePickerController.SourceType) {
        fatalError("showPicker: Not implemented.")
    }
    
    func showAlert(title: String? = "WARNING", message: String? = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithCancel(title: String? = "WARNING", message: String? = "", handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        alertController.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension BaseVC {
    func selectImage() {
        let alertController = UIAlertController(title: "", message: "Please select an image", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
            self?.showPicker(source: .photoLibrary)
        })
        alertController.addAction(UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            #if targetEnvironment(simulator)
            self?.showCameraNotSupported()
            #else
            self?.showPicker(source: .camera)
            #endif
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alertController.dismiss(animated: true)
        })
        present(alertController, animated: true)
    }
    
    private func showCameraNotSupported() {
        let controller = UIAlertController(title: "Error", message: "Simulator doesn't support camera!", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default) { action in
            controller.dismiss(animated: true)
        })
        present(controller, animated: true)
    }
}
