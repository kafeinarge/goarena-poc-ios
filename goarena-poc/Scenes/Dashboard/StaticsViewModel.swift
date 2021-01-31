//
//  StaticsViewModel.swift
//  goarena-poc
//
//  Created by serhat akalin on 30.01.2021.
//

import Foundation

class StaticsViewModel: BaseViewModel {
    var isDownloadedBefore = false
    var lockScreen = false
    var staticApi = StaticAPI()
    var response: [SumContent]?
    var month = 0
    var year = 2020
    
    func getContents() {
        if response != nil {
            isDownloadedBefore = true
        } else {
            lockScreen = true
        }

        staticApi.getStaticService(lockScreen: lockScreen,
            filter: [year, month],
            succeed: handleResponse,
            failed: handleErrorResponse)
    }

    func handleResponse(response: Summary) {
        self.response = response.content
        SwiftEventBus.post(SubscribeViewState.STATISTIC_STATE.rawValue, sender: response)
    }

    func handleErrorResponse(response: ErrorMessage) {
        print(response.error)
        print(response.message)
    }
}
