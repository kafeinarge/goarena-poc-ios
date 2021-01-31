//
//  LoginViewModel.swift
//  goarena-poc
//
//  Created by serhat akalin on 31.01.2021.
//

import Foundation

class LoginViewModel: BaseViewModel {
    var isDownloadedBefore = false
    var lockScreen = false
    var loginApi = LoginAPI()
    var response: LoginResponse?
    
    func getContents(_ username: String?, _ password: String?) {
        if response != nil {
            isDownloadedBefore = true
        } else {
            lockScreen = true
        }

        loginApi.login(lockScreen: lockScreen,
                       username: username ?? "",
                       password: password ?? "",
                       succeed: handleResponse,
                       failed: handleErrorResponse)
        

    }

    func handleResponse(response: LoginResponse) {
        self.response = response
        SwiftEventBus.post(SubscribeViewState.LOGIN_SUCCESS.rawValue, sender: response)
    }

    func handleErrorResponse(response: ErrorMessage) {
        SwiftEventBus.post(SubscribeViewState.LOGIN_FAILURE.rawValue)
    }
}
