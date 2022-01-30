//
//  Currency.swift
//  Expenses
//
//  Created by Nominalista on 04/12/2021.
//

import Foundation

enum Currency: String, Codable, CaseIterable {
    
    case AED = "AED"
    case AFN = "AFN"
    case ALL = "ALL"
    case AMD = "AMD"
    case AOA = "AOA"
    case ARS = "ARS"
    case AUD = "AUD"
    case AZN = "AZN"
    case BAM = "BAM"
    case BBD = "BBD"
    case BDT = "BDT"
    case BGN = "BGN"
    case BHD = "BHD"
    case BIF = "BIF"
    case BMD = "BMD"
    case BND = "BND"
    case BOB = "BOB"
    case PLN = "PLN"
    case USD = "USD"
    case ZAR = "ZAR"
    case ZMW = "ZMW"
    
    var code: String { rawValue }
    
    var name: String {
        switch self {
        case .AED:
            return "Emirati Dirham"
        case .AFN:
            return "Afghanistan Afghani"
        case .ALL:
            return "Albanian Lek"
        case .AMD:
            return "Armenian Dram"
        case .AOA:
            return "Angolan Kwanza"
        case .ARS:
            return "Argentine Peso"
        case .AUD:
            return "Australian Dollar"
        case .AZN:
            return "Azerbaijani Manat"
        case .BAM:
            return "Bosnia & Herzegovina Convertible Mark"
        case .BBD:
            return "Barbadian Dollar"
        case .BDT:
            return "Bangladeshi Taka"
        case .BGN:
            return "Bulgarian Lev"
        case .BHD:
            return "Bahraini Dinar"
        case .BIF:
            return "Burundian Franc"
        case .BMD:
            return "Bermuda Dollar"
        case .BND:
            return "Brunei Dollar"
        case .BOB:
            return "Bolivian Boliviano"
        case .PLN:
            return "Polski Złoty"
        case .USD:
            return "United States Dollar"
        case .ZAR:
            return "South Africa Rand"
        case .ZMW:
            return "Zambian Kwacha"
        }
    }
    
    var symbol: String {
        switch self {
        case .AED:
            return "د.إ"
        case .AFN:
            return "؋"
        case .ALL:
            return "L"
        case .AMD:
            return "֏"
        case .AOA:
            return "Kz"
        case .ARS:
            return "$"
        case .AUD:
            return "$"
        case .AZN:
            return "m"
        case .BAM:
            return "KM"
        case .BBD:
            return "$"
        case .BDT:
            return "Tk"
        case .BGN:
            return "лв"
        case .BHD:
            return "BD"
        case .BIF:
            return "FBu"
        case .BMD:
            return "$"
        case .BND:
            return "$"
        case .BOB:
            return "Bs"
        case .USD:
            return "$"
        case .PLN:
            return "zł"
        case .ZAR:
            return "R"
        case .ZMW:
            return "ZK"
        }
    }
    
    var flag: String {
        switch self {
        case .AED:
            return "🇦🇪"
        case .AFN:
            return "🇦🇫"
        case .ALL:
            return "🇦🇱"
        case .AMD:
            return "🇦🇲"
        case .AOA:
            return "🇦🇴"
        case .ARS:
            return "🇦🇷"
        case .AUD:
            return "🇦🇺"
        case .AZN:
            return "🇦🇿"
        case .BAM:
            return "🇧🇦"
        case .BBD:
            return "🇧🇸"
        case .BDT:
            return "🇧🇩"
        case .BGN:
            return "🇧🇬"
        case .BHD:
            return "🇧🇭"
        case .BIF:
            return "🇧🇮"
        case .BMD:
            return "🇧🇲"
        case .BND:
            return "🇧🇳"
        case .BOB:
            return "🇧🇴"
        case .USD:
            return "🇺🇸"
        case .PLN:
            return "🇵🇱"
        case .ZAR:
            return "🇿🇦"
        case .ZMW:
            return "🇿🇲"
        }
    }
}
