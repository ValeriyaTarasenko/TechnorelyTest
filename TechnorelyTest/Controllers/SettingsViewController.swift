//
//  SettingsViewController.swift
//  TechnorelyTest
//
//  Created by Valeriia Tarasenko on 02.08.2020.
//  Copyright © 2020 Valeriia Tarasenko. All rights reserved.
//

import UIKit

class SettingsViewController: BasicViewController {
    
    @IBOutlet private weak var modeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modeSwitch.isOn = dataManager?.getMode() ?? false
    }
    
    @IBAction private func settingsSwitch(_ sender: UISwitch) {
        dataManager?.saveMode(with: sender.isOn)
    }
    
}
