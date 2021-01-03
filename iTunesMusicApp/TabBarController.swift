//
//  TabBarController.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 23.12.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import UIKit

protocol TabBarControllerDelegate: class {
    func setMinimizedTrackDetailView()
    func setMaximizedTrackDetailView(cellViewModel: CellSearchViewModel.Cell?)
}

class TabBarController: UITabBarController {
    
    //MARK: - Private properties:
    private let searchVC = SearchViewController()
    private let libraryVC = LibraryViewController()
    
    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    
    private let trackDetailView = TrackDetailView()
    
    
    //MARK: - Override methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchVC.tabBarDelegate = self
        
        setupTabBar()
        
        setupTrackDetailView()
    }
    
    //MARK: - Private methods:
    private func setupTabBar() {
        
        tabBar.barTintColor = .secondarySystemBackground
        tabBar.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.3764705882, alpha: 1)
        
        viewControllers = [
            generateViewController(rootViewController: searchVC,
                                   image: #imageLiteral(resourceName: "search"),
                                   title: "Search"),
            generateViewController(rootViewController: libraryVC,
                                   image: #imageLiteral(resourceName: "library"),
                                   title: "Library")
        ]
    }
    
    private func generateViewController(rootViewController: UIViewController,
                                        image: UIImage?,
                                        title: String) -> UIViewController {
        
        let navigationVC =
            UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        
        return navigationVC
    }
    
    private func setupTrackDetailView() {
        
        trackDetailView.tabBarDelegate = self
        trackDetailView.trackMovingDelegate = searchVC
        view.insertSubview(trackDetailView,
                           belowSubview: tabBar)
        
        maximizedTopAnchorConstraint =
            trackDetailView.topAnchor.constraint(equalTo: view.topAnchor,
                                                 constant: view.frame.height)
        minimizedTopAnchorConstraint =
            trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor,
                                                 constant: -64)
        bottomAnchorConstraint =
            trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                    constant: view.frame.height)
        
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            maximizedTopAnchorConstraint,
            bottomAnchorConstraint,
            trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension TabBarController: TabBarControllerDelegate {
    
    func setMaximizedTrackDetailView(cellViewModel: CellSearchViewModel.Cell?) {
        
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.tabBar.alpha = 0
                        self.trackDetailView.mainStackView.alpha = 1
                        self.trackDetailView.miniPlayerView.alpha = 0
        }, completion: nil)
        
        guard let cellViewModel = cellViewModel else { return }
        trackDetailView.set(cellViewModel: cellViewModel)
    }
    
    func setMinimizedTrackDetailView() {
        
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.tabBar.alpha = 1
                        self.trackDetailView.mainStackView.alpha = 0
                        self.trackDetailView.miniPlayerView.alpha = 1
        }, completion: nil)
    }
}
