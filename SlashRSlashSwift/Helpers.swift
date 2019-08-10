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
