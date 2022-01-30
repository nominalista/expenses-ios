//
//  UserDefaults+selectedWalletID.swift
//  Expenses
//
//  Created by Nominalista on 06/01/2022.
//

import Foundation

extension UserDefaults {
    @objc var selectedWalletID: String? {
        get { string(forKey: "selectedWalletID") }
        set { set(newValue, forKey: "selectedWalletID") }
    }
}
