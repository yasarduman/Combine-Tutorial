//
//  HomeVM.swift
//  Combine-Tutorial
//
//  Created by Yaşar Duman on 21.12.2023.
//

import Foundation
import Combine


final class HomeVM {
    private var cancellables: Set<AnyCancellable> = [] // Combine aboneliklerini saklamak için bir küme.
    private let networkManager: any NetworkManagerProtocol = NetworkManager.shared
    var userList: [GetUserResponse]? = []
    var isLoad: Bool = false

    func fetchData() {
        isLoad = true

        // NetworkManager üzerinden veri çekme işlemi
        networkManager.fetchData()

            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("Abonelik tamamlandı.")
                    break
                case .failure(let error):
                    print("Hata oluştu: \(error)")
                    self?.isLoad = false
                }
            } receiveValue: { [weak self] users in // yayıncıdan yeni bir değer geldiğinde çağrılır.
                guard let self = self else { return }

                // Çekilen kullanıcıları listeye ekle
                self.userList?.append(contentsOf: users)
                print("Users: \(self.userList?.count ?? 0)")
                self.isLoad = false
            }
            .store(in: &cancellables)
    }


}
