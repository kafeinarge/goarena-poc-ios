//
//  NewFeedViewModel.swift
//  goarena-poc
//
//  Created by serhat akalin on 29.01.2021.
//

import UIKit

class NewFeedViewModel: BaseViewModel {
    var isDownloadedBefore = false
    var lockScreen = false
    var response: UploadResponse?
    var postFeedApi = NewFeedAPI()

    func postFeed(_ data: Data?, text: String?) {
        guard let data = data, let text = text else { return }
        if response != nil {
            isDownloadedBefore = true
        } else {
            lockScreen = true
        }

        postFeedApi.postFeed(lockScreen: lockScreen,
                             data: data,
                             text: text,
                             succeed: handleResponse,
                             failed: handleErrorResponse)

    }

    func handleResponse(response: UploadResponse) {
        self.response = response
    }

    func handleErrorResponse(response: ErrorMessage) {
        print(response.error)
        print(response.message)
    }

}
