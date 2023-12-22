//
//  AlamofireService.swift
//  Combine-Tutorial
//
//  Created by Yaşar Duman on 21.12.2023.
//

import Foundation
import Alamofire


final class AlamofireService {
    // Singleton örnek
    static let shared = AlamofireService()
    
    private init() {}
    
    // MARK: - Default Request
    
    /// Bir HTTP isteği oluşturmak için varsayılan URLRequest'i döner.
    /// - Parameters:
    ///   - url: İstek atılacak URL
    ///   - method: İstek atılan metodun tipi (GET, POST vb.)
    ///   - params: İstek atılan metodun body içerisine gönderilecek parametreler
    /// - Returns: Oluşturulan URLRequest
    func getDefaultRequest(url: String,
                           method: HTTPMethod,
                           params: [String: AnyObject] = [:]) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData // -> Cache politikası
        request.timeoutInterval = 120.0 // -> İstek zaman aşımı
        request.method = method
        if !params.isEmpty {
            // Eğer bu fonksiyona bir parametre gönderiliyorsa, bunu body içerisine ekliyoruz.
            request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        }
        return request
    }
    
    // MARK: - Default URL Component
    
    /// Proje içindeki URL'leri standart bir şekilde oluşturmak için URLComponents döner.
    /// - Returns: Oluşturulan URLComponents
    func getURLComponent() -> String {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https" // -> URL şeması
        urlComponents.host = "jsonplaceholder.typicode.com" // -> Base URL
        urlComponents.path = "/users" // -> Endpoint
        // Servislerinize query parametresi ekleyebilirsiniz.
//        urlComponents.queryItems = [URLQueryItem(name: "page", value: "1")]
        print("AlamofireService--> \(urlComponents.string!) adresine istek atılıyor...")
        return urlComponents.string!
    }
    
    // MARK: - Methods
    
    /// Kullanıcı verilerini çekmek için HTTP GET isteği atan bir DataRequest döner.
    /// - Returns: Oluşturulan DataRequest
    public func requestGetUsers() -> DataRequest {
        let request = self.getDefaultRequest(url: self.getURLComponent(),
                                             method: .get)
        return AF.request(request)
    }
}
