//
//  HomeVM.swift
//  goarena-poc
//
//  Created by serhat akalin on 27.01.2021.
//

import UIKit

class HomeViewModel: BaseViewModel {
    var isDownloadedBefore = false
    var lockScreen = false
    var response: [Content]?
    var wallApi = WallAPI()
    var pageNumber = 0

    func getContents() {
        getUserDefaults()
        if response != nil {
            isDownloadedBefore = true
        } else {
            lockScreen = true
        }

        wallApi.getWallService(lockScreen: lockScreen,
            pageNumber: pageNumber,
            succeed: handleResponse,
            failed: handleErrorResponse)

    }
    
    func deletePost(_ postId: Int?) {
        wallApi.deleteFeed(lockScreen: lockScreen,
                           postId: postId,
                           succeed:  handleDeleteResponse,
                           failed: handleErrorResponse)
    }

    func handleResponse(response: WallResponse) {
        self.response = response.content
        let id = self.response?.first?.user?.id
        TokenManager.shared.saveUser(id)
        SwiftEventBus.post(SubscribeViewState.FEED_STATE.rawValue, sender: response)
    }

    func handleErrorResponse(response: ErrorMessage) {
        print(response.error)
        print(response.message)
    }
    
    func handleDeleteResponse() {}

    func saveImagesToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(response) {
            UserDefaults.standard.set(encoded, forKey: "wallContents")
        }
    }

    func getUserDefaults() {
        if let jsonData = UserDefaults.standard.value(forKey: "wallContents") as? Data,
            let obj = try? JSONDecoder().decode([Content].self, from: jsonData) {
            response = obj
        }
    }
}
