//
//  Image.swift
//  Expenses
//
//  Created by Nominalista on 05/02/2022.
//

import SwiftUI
import UIKit

extension Image {
    
    static var appIcon: Image {
        Image(uiImage: .image(named: "AppIcon"))
    }
    
    static var imgLogo: Image {
        Image(uiImage: .image(named: "img_logo"))
    }
    
    static var imgLogoPro: Image {
        Image(uiImage: .image(named: "img_logo_pro"))
    }
    
    static var imgLogoTransparent: Image {
        Image(uiImage: .image(named: "img_logo_transparent"))
    }
    
    static var icApple24pt: Image {
        Image(uiImage: .icon(named: "ic_apple_24pt", renderingMode: .alwaysOriginal))
    }
    
    static var icArrowBack24pt: Image {
        Image(uiImage: .icon(named: "ic_arrow_back_24pt"))
    }
    
    static var icArrowDropDown24pt: Image {
        Image(uiImage: .icon(named: "ic_arrow_drop_down_24pt"))
    }
    
    static var icCheck24pt: Image {
        Image(uiImage: .icon(named: "ic_check_24pt"))
    }
    
    static var icChevronRight24pt: Image {
        Image(uiImage: .icon(named: "ic_chevron_right_24pt"))
    }
    
    static var icClose24pt: Image {
        Image(uiImage: .icon(named: "ic_close_24pt"))
    }
    
    static var icDelete24pt: Image {
        Image(uiImage: .icon(named: "ic_delete_24pt"))
    }
    
    static var icExpense24pt: Image {
        Image(uiImage: .icon(named: "ic_expense_24pt"))
    }
    
    static var icGoogle24pt: Image {
        Image(uiImage: .icon(named: "ic_google_24pt", renderingMode: .alwaysOriginal))
    }
    
    static var icPerson24pt: Image {
        Image(uiImage: .icon(named: "ic_person_24pt"))
    }
    
    static var icPeople24pt: Image {
        Image(uiImage: .icon(named: "ic_people_24pt"))
    }
    
    static var icSearch24pt: Image {
        Image(uiImage: .icon(named: "ic_search_24pt"))
    }
    
    static var icWallet24pt: Image {
        Image(uiImage: .icon(named: "ic_wallet_24pt"))
    }
}

extension UIImage {
    
    static func image(named: String, renderingMode: RenderingMode = .alwaysOriginal) -> UIImage {
        UIImage(named: named)?.withRenderingMode(renderingMode) ?? UIImage()
    }
    
    static func icon(named: String, renderingMode: RenderingMode = .alwaysTemplate) -> UIImage {
        UIImage(named: named)?.withRenderingMode(renderingMode) ?? UIImage()
    }
}

