//
//  HomeVC.swift
//  Combine-Tutorial
//
//  Created by Yaşar Duman on 21.12.2023.
//

import UIKit

class HomeVC: UIViewController {
    
    private let ViewModel = HomeVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        view?.backgroundColor = .systemPink
        ViewModel.fetchData()
    }

}
