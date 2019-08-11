//
//  Helpers.swift
//  SlashRSlashSwift
//
//  Created by Spencer Alderson on 2019-08-09.
//  Copyright © 2019 Spencer Alderson. All rights reserved.
//

import UIKit

extension String {
    var isValidURL: Bool {
        guard let url = URL(string: self) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
}

extension UIViewController {
    func showGenericAlert(tittle: String, message: String) {
        let alertController = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
