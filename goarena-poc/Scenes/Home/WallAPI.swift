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
    func getWallService(lockScreen: Bool,
                        pageNumber: Int,
                        succeed: @escaping (WallResponse) -> Void,
                         failed: @escaping (ErrorMessage) -> Void) {
        var headerParams = HTTPHeaders()
        guard let token = TokenManager.shared.token else { return }
        headerParams.add(name: "Authorization", value: "Bearer \(token)")
        
        let parameters: Parameters = [
            "pageNo": pageNumber,
            "pageSize": 20,
            "sortBy": "id",
            "direction": "DESC"
        ]
        
        BaseAPI.shared.request(methotType: .get,
                               params: parameters,
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
        let urlStr = Endpoint.delete.generateURL(URLs.baseURL.rawValue) + "\(id)"
        guard let url = URL(string: urlStr) else { return }
        AF.sessionConfiguration.timeoutIntervalForRequest = 60
        let request =  AF.request(url, method: .delete, headers: headerParams)
       
        request.responseString(completionHandler: { dataResponse in
            if dataResponse.response?.statusCode == 200 {
                HUD.show(.label("Post silindi!"))
                HUD.hide(afterDelay: 1)
                SwiftEventBus.post(SubscribeViewState.FEED_REFRESH.rawValue)
                succeed()
                return
            } else if dataResponse.response?.statusCode == 500 {
                HUD.show(.label("Silme işleminde bir hata oluştu."))
                HUD.hide(afterDelay: 1)
            }
        })

    }
}
