//
//  NetworkManager.swift
//  Combine-Tutorial
//
//  Created by Yaşar Duman on 21.12.2023.
//

import Combine
import Foundation
import Alamofire

// MARK: - Network Manager Protocol

/// `NetworkManager` protokolü, genel bir ağ işlemlerini yönetmek için kullanılır.
protocol NetworkManagerProtocol {
    associatedtype ResultType: Decodable
    func fetchData<T: Decodable>() -> AnyPublisher<[T], Error>
}

// MARK: - Network Manager

/// Ağ işlemlerini yöneten sınıf.
final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    
    typealias ResultType = GetUserResponse
    
    private init(){}
    
      // MARK: - Public Methods
      
      /// Genel ağ işlemlerini başlatan metod.
      /// - Returns: Ağ işlemlerinin sonucunu yayınlayan bir AnyPublisher.
    
    func fetchData<T: Decodable>() -> AnyPublisher<T, Error> {
        return Future { promise in
            AlamofireService.shared.requestGetUsers().responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        promise(.success(decodedData))
                    } catch {
                        promise(.failure(error))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main) //???
        .eraseToAnyPublisher()
    }

  }


// MARK: - User Response Structures

/// Kullanıcı verilerini temsil eden ana yapı.
struct GetUserResponse: Codable {
    let id: Int
    let name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
}

// MARK: - Address
struct Address: Codable {
    let street, suite, city, zipcode: String
    let geo: Geo
}

// MARK: - Geo
struct Geo: Codable {
    let lat, lng: String
}

// MARK: - Company
struct Company: Codable {
    let name, catchPhrase, bs: String
}




