//
//  WeatherDisplayViewController.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 02.06.2023.
//

import UIKit
import SwiftUI

class WeatherDisplayViewController: UIViewController {
    let viewModel: WeatherDisplayViewModel
    
    private lazy var embedViewController: UIHostingController<WeatherDisplayContentView> = {
        return UIHostingController(rootView: WeatherDisplayContentView(viewModel: viewModel))
    }()
    
    init(viewModel: WeatherDisplayViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Current Weather"
        
        add(childViewController: embedViewController)
        
        let searchBarItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(handleTapOnSearch)
        )
        navigationItem.rightBarButtonItem = searchBarItem
    }
    
    @objc private func handleTapOnSearch() {
        viewModel.onTapSearchButton()
    }
}

