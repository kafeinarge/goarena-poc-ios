//
//  WallAPI.swift
//  goarena-poc
//
//  Created by serhat akalin on 27.01.2021.
//

import Foundation
import Alamofire

class WallAPI {
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
}
