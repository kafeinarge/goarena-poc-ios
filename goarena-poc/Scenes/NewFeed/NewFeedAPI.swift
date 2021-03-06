//
//  NewFeedAPI.swift
//  goarena-poc
//
//  Created by serhat akalin on 29.01.2021.
//

import Foundation
import Alamofire
import PKHUD

class NewFeedAPI {
    private var uploadRequest: UploadRequest?
    func postFeed(lockScreen: Bool,
                        data: Data,
                        text: String,
                        succeed: @escaping (UploadResponse) -> Void,
                         failed: @escaping (ErrorMessage) -> Void) {
        var headerParams = HTTPHeaders()
        guard let token = TokenManager.shared.token else { return }
        headerParams.add(name: "Authorization", value: "Bearer \(token)")
        headerParams.add(name: "Accept", value: "*/*")

        let urlStr = Endpoint.upload.generateURL(URLs.baseURL.rawValue)
        
        guard let url = URL(string: urlStr) else { return }
        AF.sessionConfiguration.timeoutIntervalForRequest = 60
        uploadRequest = AF.upload(multipartFormData: { multipartFormData in
            HUD.show(.progress)
            multipartFormData.append(data, withName: "file", fileName: "resim1.jpg")
            if let text = text.data(using: .utf8, allowLossyConversion: false) {
                multipartFormData.append(text, withName: "text")
            }
            headerParams.add(name: "Content-Type", value: multipartFormData.contentType)
        }, to: url, method: .put, headers: headerParams)
        .responseString(completionHandler: { dataResponse in
            HUD.hide()
            switch dataResponse.response?.statusCode {
            case 200:
                HUD.show(.label("Başarıyla gönderildi!"))
                HUD.hide(afterDelay: 1)
                SwiftEventBus.post(SubscribeViewState.NEW_FEED_SUCCESS.rawValue, sender: true)
            case 500, 404, 415:
                HUD.show(.label("Bilinmeyen bir hata oluştu."))
                HUD.hide(afterDelay: 1)
            case .none: break
            case .some(_): break
            }
        })
    }

    func updateFeed(lockScreen: Bool,
                    postId: Int? = nil,
                    text: String,
                        succeed: @escaping (UploadResponse) -> Void,
                         failed: @escaping (ErrorMessage) -> Void) {
        var headerParams = HTTPHeaders()
        guard let token = TokenManager.shared.token else { return }
        headerParams.add(name: "Authorization", value: "Bearer \(token)")
        headerParams.add(name: "Content-Type", value: "application/json")
        headerParams.add(name: "Accept", value: "*/*")
        let parameters: Parameters = [
            "text": text
        ]
        
        guard let id = postId else { return }
        BaseAPI.shared.request(methotType: .put,
                               params: parameters,
                               baseURL: URLs.baseURL.rawValue,
                               urlPath: Endpoint.deleteOrUpdate.rawValue + "\(id)",
                               lockScreen: lockScreen,
                               headerParams: headerParams,
                               succeed: succeed,
                               failed: failed)

    }
    
    func cancelRequest() {
        if !(uploadRequest?.isCancelled ?? true) {
            uploadRequest?.cancel()
        }
    }
}
