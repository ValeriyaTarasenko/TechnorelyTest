//
//  BasicViewController.swift
//  TechnorelyTest
//
//  Created by Valeriia Tarasenko on 29.07.2020.
//  Copyright © 2020 Valeriia Tarasenko. All rights reserved.
//

import UIKit
import Alamofire

class BasicViewController: UIViewController {
    var dataManager: DataManager? = DIContainer.defaultResolver.resolve(DataManager.self)!

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    func showErrorMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    func showConfirmationAlert(title: String?,
                               message: String? = nil,
                               buttonFirstTitle: String? = "OK",
                               buttonFirstStyle: UIAlertAction.Style = .default,
                               buttonSecondTitle: String? = "Cancel",
                               buttonSecondStyle: UIAlertAction.Style = .default,
                               firstAction: (() -> Void)? = nil,
                               secondAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonFirstTitle, style: buttonFirstStyle) { _ in
            if let action = firstAction { action() }
        })
        alert.addAction(UIAlertAction(title: buttonSecondTitle, style: buttonSecondStyle) { _ in
            if let action = secondAction { action() }
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    @discardableResult func presentViewController(withIdentifier identifier: String, storyboardIdentifier: String? = nil, fromNavigation: Bool = false) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardIdentifier ?? identifier, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        guard fromNavigation else {
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true, completion: nil)
            return controller
        }
        if let navigationController = navigationController {
            navigationController.pushViewController(controller, animated: true)
        }
        else {
            let navigationController = UINavigationController(rootViewController: controller)
            present(navigationController, animated: true)
        }
        return controller
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
