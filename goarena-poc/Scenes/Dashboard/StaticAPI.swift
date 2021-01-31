//
//  StaticAPI.swift
//  goarena-poc
//
//  Created by serhat akalin on 30.01.2021.
//

import Foundation
import Alamofire

class StaticAPI {
    func getStaticService(lockScreen: Bool,
                        filter: [Int],
                        succeed: @escaping (Summary) -> Void,
                         failed: @escaping (ErrorMessage) -> Void) {
        var headerParams = HTTPHeaders()
        guard let token = TokenManager.shared.token else { return }
        headerParams.add(name: "Authorization", value: "Bearer \(token)")
        let month = filter[1]
        let parameters: Parameters = [
            "year": filter[0],
            "month": month + 1
        ]
        
        BaseAPI.shared.request(methotType: .get,
                               params: parameters,
                               baseURL: URLs.baseURL.rawValue,
                               urlPath: Endpoint.dashboard.rawValue,
                               lockScreen: lockScreen,
                               headerParams: headerParams,
                               succeed: succeed,
                               failed: failed)
    }
}
