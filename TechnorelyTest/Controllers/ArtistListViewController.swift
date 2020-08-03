//
//  ArtistListViewController.swift
//  TechnorelyTest
//
//  Created by Valeriia Tarasenko on 29.07.2020.
//  Copyright © 2020 Valeriia Tarasenko. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu
import RealmSwift

class ArtistListViewController: BasicViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var settingsBarItem: UIBarButtonItem!
    
    private var artists: [Artist] = []
    private var lastPageAttributes: Attribute?
    private var selectedCountry: Countries = .ukraine
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateView()
        setDropdown()
        getArtists(page: 1)
    }
    
    private func configurateView() {
        tableView.dataSource = self
        tableView.delegate = self
        if dataManager?.manageMode == .dev {
            self.navigationItem.setLeftBarButton(settingsBarItem, animated: true)
        } else {
            self.navigationItem.leftBarButtonItems = nil
        }
    }
    
    private func getArtists(page: Int) {
        dataManager?.getTopArtists(page: page, country: selectedCountry.rawValue) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case let .success(artistData):
                self.artists += artistData.artist
                self.lastPageAttributes = artistData.attribute
                self.tableView.reloadData()
            case let .failure(error):
                self.showErrorMessage(error.localizedDescription)
            }
        }
    }
    
    private func setDropdown() {
        let menuTitle = "Popular Artists \(selectedCountry.rawValue)"
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: view, title: menuTitle, items: Countries.allCases.map { $0.description })
        menuView.arrowTintColor = .black
        self.navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = { [weak self] (indexPath: Int) -> () in
            if Countries.allCases.indices.contains(indexPath) {
                self?.selectedCountry = Countries.allCases[indexPath]
            }
            self?.artists = []
            self?.getArtists(page: 1)
        }
    }
    
    @IBAction private func settingsTap(_ sender: Any) {
        guard let _ = presentViewController(withIdentifier: "Settings", fromNavigation: true) as? SettingsViewController else {
            return
        }
    }
}

extension ArtistListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTableViewCell", for: indexPath) as? ArtistTableViewCell,
            artists.indices.contains(indexPath.row) else { return UITableViewCell() }
        cell.setup(with: artists[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == artists.count - 1,
            let currentPage = lastPageAttributes?.page, let currentPageInt = Int(currentPage),
            let total = lastPageAttributes?.total, let totalInt = Int(total),
            let perPage = lastPageAttributes?.perPage, let perPageInt = Int(perPage),
            (totalInt/perPageInt + 1) > currentPageInt {
            getArtists(page: currentPageInt + 1)
        }
    }
}

extension ArtistListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard artists.indices.contains(indexPath.row) else { return }   
        guard let artistInfoController = presentViewController(withIdentifier: "ArtistInfo", fromNavigation: true) as? ArtistInfoViewController else {
            return
        }
        artistInfoController.update(with: artists[indexPath.row])
    }
}

extension ArtistListViewController {
    enum Countries: String, CaseIterable {
        case ukraine, israel
        
        var description: String {
            return "Popular Artists " + self.rawValue
        }
    }
}
