//
//  ChooseModeViewController.swift
//  TechnorelyTest
//
//  Created by Valeriia Tarasenko on 02.08.2020.
//  Copyright © 2020 Valeriia Tarasenko. All rights reserved.
//

import UIKit

class ChooseModeViewController: BasicViewController {
    @IBAction private func devModeTap(_ sender: Any) {
        dataManager?.changeManageMode(to: .dev)
        presentArtists()
    }
    
    @IBAction private func prodModeTap(_ sender: Any) {
        dataManager?.changeManageMode(to: .prod)
        presentArtists()
    }
    
    private func presentArtists() {
        let storyboard = UIStoryboard(name: "Main" , bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "ArtistListViewController") as? ArtistListViewController else { return }
        let navController = UINavigationController(rootViewController: controller)
        navController.modalPresentationStyle = .fullScreen
        navController.navigationBar.barTintColor = dataManager?.manageMode == .dev ? .red : .blue
        view.window?.rootViewController = navController
    }
}
