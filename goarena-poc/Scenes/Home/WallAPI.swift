//
//  WallAPI.swift
//  goarena-poc
//
//  Created by serhat akalin on 27.01.2021.
//

import Foundation
import Alamofire
import PKHUD

class WallAPI {
    private var uploadRequest: UploadRequest?
    func getWallService(lockScreen: Bool,
                        succeed: @escaping (WallResponse) -> Void,
                         failed: @escaping (ErrorMessage) -> Void) {
        var headerParams = HTTPHeaders()
        headerParams.add(name: "Authorization", value: "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ1c2VyIiwiZXhwIjoxNjEyNzExNjk1fQ.lWxP3tRGMEgHh74aWRv6dQW_3HjnoiO4BcMavJuUFG4iFQZIzoxJKEkE7i8lJdXb_gyLOrr8LwTH9JHmG6je1w")
     //   headerParams.add(name: "Accept", value: "*/*")
        BaseAPI.shared.request(methotType: .get,
                               params: nil,
                               baseURL: URLs.baseURL.rawValue,
                               urlPath: Endpoint.contents.rawValue,
                               lockScreen: lockScreen,
                               headerParams: headerParams,
                               succeed: succeed,
                               failed: failed)
    }
    
   
    func deleteFeed(lockScreen: Bool,
                    postId: Int? = nil,
                        succeed: @escaping () -> Void,
                         failed: @escaping (ErrorMessage) -> Void) {
        var headerParams = HTTPHeaders()
        headerParams.add(name: "Authorization", value: "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ1c2VyIiwiZXhwIjoxNjEyNzExNjk1fQ.lWxP3tRGMEgHh74aWRv6dQW_3HjnoiO4BcMavJuUFG4iFQZIzoxJKEkE7i8lJdXb_gyLOrr8LwTH9JHmG6je1w")
        headerParams.add(name: "Accept", value: "*/*")
        
        guard let id = postId else { return }
        let urlStr = Endpoint.delete.generateURL(URLs.baseURL.rawValue) + String(id)
        guard let url = URL(string: urlStr) else { return }

        AF.sessionConfiguration.timeoutIntervalForRequest = 60
        AF.request(url, method: .delete, headers: headerParams)
        .responseString(completionHandler: { dataResponse in
            switch dataResponse.result {
            case .success(_):
                HUD.show(.label("Post silindi!"))
                HUD.hide(afterDelay: 1)
                SwiftEventBus.post(SubscribeViewState.FEED_DELETED.rawValue)
            case .failure(_):
                HUD.show(.label("Bir hata oluştu. \n \(dataResponse.result)"))
                HUD.hide(afterDelay: 1)
            }
        })

    }
    
    func cancelRequest() {
        if !(uploadRequest?.isCancelled ?? true) {
            uploadRequest?.cancel()
        }
    }
}
