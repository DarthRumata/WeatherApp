//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Stas Kirichok on 04.06.2023.
//

import UIKit
import SwiftUI

class SearchViewController: UIViewController {
    // TODO: Should be guarded better against crash in prod
    let viewModel: SearchViewModel
    
    private lazy var embedViewController: UIHostingController<SearchContentView> = {
        return UIHostingController(rootView: SearchContentView(viewModel: viewModel))
    }()
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Search"
        
        add(childViewController: embedViewController)
        
        let searchBarItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(handleTapOnClose)
        )
        navigationItem.rightBarButtonItem = searchBarItem
    }
    
    @objc private func handleTapOnClose() {
        viewModel.onTapCloseButton()
    }
}
