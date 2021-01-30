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
        headerParams.add(name: "Authorization", value: "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ1c2VyIiwiZXhwIjoxNjEyNzExNjk1fQ.lWxP3tRGMEgHh74aWRv6dQW_3HjnoiO4BcMavJuUFG4iFQZIzoxJKEkE7i8lJdXb_gyLOrr8LwTH9JHmG6je1w")
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
            case 500, 404:
                HUD.show(.label("Bilinmeyen bir hata oluştu."))
                HUD.hide(afterDelay: 1)
            case .none: break
            case .some(_): break
            }
        })

    }
    
    func cancelRequest() {
        if !(uploadRequest?.isCancelled ?? true) {
            uploadRequest?.cancel()
        }
    }
}
