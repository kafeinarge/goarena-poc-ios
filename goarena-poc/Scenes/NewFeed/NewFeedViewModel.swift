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

    func postFeed(_ data: Data?, text: String?, _ postId: Int?, _ update: Bool?) {
        guard let data = data, let text = text,
              let postId = postId, let update = update
              else { return }
        if response != nil {
            isDownloadedBefore = true
        } else {
            lockScreen = true
        }

        if update != true {
            postFeedApi.postFeed(lockScreen: lockScreen,
                                 data: data,
                                 text: text,
                                 succeed: handleResponse,
                                 failed: handleErrorResponse)

        } else {
            postFeedApi.updateFeed(lockScreen: lockScreen,
                                 postId: postId,
                                 text: text,
                                 succeed: handleUpdateResponse,
                                 failed: handleErrorResponse)
        }
    }

    func handleResponse(response: UploadResponse) {
        self.response = response
    }
    
    func handleUpdateResponse(response: UploadResponse) {
        self.response = response
        SwiftEventBus.post(SubscribeViewState.NEW_FEED_SUCCESS.rawValue, sender: true)
    }

    func handleErrorResponse(response: ErrorMessage) {
        print(response.error)
        print(response.message)
    }

}
