//
//  BaseAPI.swift
//  goarena-poc
//
//  Created by serhat akalin on 27.01.2021.
//

import Alamofire
import Foundation
import UIKit
import PKHUD

class ErrorMessage: Codable {
    var error: String = ""
    var message: String = ""
}

public enum URLs: String {
    case baseURL = "http://167.172.180.49:8765"
}

public enum Endpoint: String {
    case contents = "/wall-service/all"
    case upload = "/wall-service/upload"
    case delete = "/wall-service/"
    
    func generateURL(_ baseURL: String) -> String {
        return "\(baseURL)\(self.rawValue)"
    }
}

// MARK: Status
enum StatusType: Int {
    case success
    case warning
    case error
    case inform
    case confirm
    case unknown
}

// MARK: Content Types
enum ApiContentTypeEnum: String {
    case applicationJson = "application/json"
    case textHtml = "text/html"
    case applicationPdf = "application/pdf"
}

// MARK: Timeout
private let timeoutIntervalForRequest: Double = 300

class BaseAPI: SessionDelegate {
    static let shared = BaseAPI()
    private var session: Session?

    private init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutIntervalForRequest
        self.session = Session(configuration: configuration, delegate: self, serverTrustManager: nil)
    }

    func request<S: Codable,F: Codable>(methotType: HTTPMethod,
                                        hasSession: Bool = true,
                                        params: [String: Any]?,
                                        baseURL: String = URLs.baseURL.rawValue,
                                        urlPath: String,
                                        secureURL: Bool = false,
                                        contentType: String = ApiContentTypeEnum.applicationJson.rawValue,
                                        lockScreen: Bool,
                                        headerParams: HTTPHeaders? = nil,
                                        succeed: @escaping (S) -> Void,
                                        failed: @escaping (F) -> Void) {
        guard let session = session else { return }
        if networkIsReachable() {
            if lockScreen {
                DispatchQueue.main.async {
                    HUD.show(.progress)
                }
            }
            var url = baseURL + urlPath
            var bodyParams: [String: Any]?
            if let params = params {
                if methotType == .get {
                    url.append(URLQueryBuilder(params: params).build())
                } else if methotType == .put || methotType == .patch {
                    var tempParams: [String: Any] = [:]
                    for (key, value) in params {
                        if url.contains("{\(key)}") {
                            url = url.replacingOccurrences(of: "{\(key)}", with: "\(value)")
                        } else {
                            tempParams[key] = value
                        }
                    }
                    bodyParams = tempParams
                } else {
                    bodyParams = params
                }
            }
            
            if !secureURL {
                url = url.replacingOccurrences(of: "https", with: "http")
            }
            
            let reqUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let networkRequest = session.request(reqUrl,
                                                 method: methotType,
                                                 parameters: bodyParams,
                                                 encoding: JSONEncoding.default,
                                                 headers: headerParams)
                .validate(contentType: [contentType])
                .validate(statusCode: 200..<600)
            print(session)
            print(reqUrl)
            print(networkRequest)
            handleJsonResponse(dataRequest: networkRequest,
                               hasSession: hasSession,
                               lockScreen: lockScreen,
                               succeed: succeed,
                               failed: failed)
        } else {

        }
    }

    private func handleJsonResponse<S: Codable,F: Codable>(dataRequest: DataRequest,
                                                           hasSession: Bool,
                                                           lockScreen: Bool,
                                                           succeed: @escaping (S) -> Void,
                                                           failed: @escaping (F) -> Void) {
        dataRequest.responseJSON { [weak self] response in
            guard let self = self else { return }
            if lockScreen {
                DispatchQueue.main.async {
                    HUD.hide()
                }
            }

            if (response.response?.statusCode) == 204 {
                self.handleSuccessfulResponseObject(dataRequest: dataRequest, succeed: succeed)
                return
            } else {
                switch response.result {
                case .success:
                    switch self.statusType((response.response?.statusCode ?? 0)) {
                    case .success:
                        self.handleSuccessfulResponseObject(dataRequest: dataRequest, succeed: succeed)
                    case .error:
                        self.handleFailureResponseObject(dataRequest: dataRequest, failed: failed)
                        break
                    default :
                        break
                    }
                case .failure:
                    self.handleFailureResponseObject(dataRequest: dataRequest, failed: failed)
                }
            }
        }
    }

    private func handleSuccessfulResponseObject<S: Codable>(dataRequest: DataRequest,
                                                            succeed: @escaping (S) -> Void) {
        dataRequest.responseData { response in
            if let data = response.data {
                do {
                    let decodedResponse = try JSONDecoder().decode(S.self, from: data)
                    succeed(decodedResponse)
                } catch let error as NSError {
                    print(error.description)
                }
            }
        }
    }

    private func handleFailureResponseObject<F: Codable>(dataRequest: DataRequest,
                                                         failed: @escaping (F) -> Void) {
        dataRequest.responseData { response in
            if let data = response.data {
                do {
                    let decodedResponse = try JSONDecoder().decode(F.self, from: data)
                    failed(decodedResponse)
                } catch let error as NSError {
                    let errorMessage = ErrorMessage()
                    errorMessage.error = "WARNING"
                    errorMessage.message = error.description
                    failed(errorMessage as! F)
                }
            }
        }
    }

    private func statusType(_ statusCode: Int) -> StatusType {
        switch statusCode {
        case 200 ..< 300, 428:
            return .success
        case 300 ..< 400:
            return .warning
        case 400 ..< 600:
            return .error
        default:
            return .unknown
        }
    }

    public func networkIsReachable () -> Bool {
        let networkManager = NetworkReachabilityManager()
        let result = networkManager?.isReachable ?? false
        return result
    }

    public func hasCellularNetwork() -> Bool {
        let networkManager = NetworkReachabilityManager()
        return (networkManager?.isReachableOnCellular ?? false)
    }

}

struct URLQueryBuilder {
    let params: [String: Any]

    func build() -> String {
        guard !params.keys.isEmpty else { return "" }

        var query = ""
        query = params
            .compactMap { item in
                if let doubleValue = item.value as? Double {
                    return "\(item.key)=\(doubleValue)"
                } else {
                    return "\(item.key)=\(item.value)"
                }
        }
        .joined(separator: "&")

        return "?\(query)"
    }

}
