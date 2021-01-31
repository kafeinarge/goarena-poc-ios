//
//  LoginVC.swift
//  goarena-poc
//
//  Created by serhat akalin on 31.01.2021.
//

import UIKit
import PKHUD

class LoginVC: BaseVC<LoginViewModel> {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        onSubscribe()
        username.text = "user"
        password.text = "user"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !TokenManager.shared.token!.isEmpty {
            navHome()
        }
    }

    private func navHome() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else { return }
        guard let nc = self.navigationController else { return }
        nc.pushViewController(vc, animated: true)
    }
    
    private func onSubscribe() {
        SwiftEventBus.onMainThread(self, name: SubscribeViewState.LOGIN_SUCCESS.rawValue) { result in
            if let event = result!.object as? LoginResponse {
                if event.token != nil {
                    HUD.hide()
                    TokenManager.shared.save(event.token)
                    self.navHome()
                }
            }
        }
        
        SwiftEventBus.onMainThread(self, name: SubscribeViewState.LOGIN_FAILURE.rawValue) { result in
            HUD.hide()
            HUD.show(.label("Kullanıcı adı veya şifre yanlış."))
            HUD.hide(afterDelay: 2)
        }
    }

    @IBAction func loginTapped(_ sender: Any) {
        if let username = username.text, let password = password.text {
            if username.isEmpty || password.isEmpty {
                HUD.show(.label("Tüm alanları doldurunuz."))
                HUD.hide(afterDelay: 1)
            } else {
                HUD.show(.progress)
                viewModel.getContents(username, password)
            }
        }
    }

}

