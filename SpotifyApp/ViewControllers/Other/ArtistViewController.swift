//
//  ArtistViewController.swift
//  SpotifyApp
//
//  Created by Victor Rubenko on 18.03.2022.
//

import UIKit

class ArtistViewController: UIViewController {
    
    private var viewModel: ArtistViewModel!
    private var averageColor: UIColor?
    
    init(id: String) {
        self.viewModel = ArtistViewModel(itemID: id)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetch()
    }
}

