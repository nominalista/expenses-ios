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
    case BRL = "BRL"
    case BSD = "BSD"
    case BTN = "BTN"
    case BWP = "BWP"
    case BYN = "BYN"
    case BZD = "BZD"
    case CAD = "CAD"
    case CDF = "CDF"
    case CHF = "CHF"
    case CLP = "CLP"
    case CNY = "CNY"
    case COP = "COP"
    case CRC = "CRC"
    case CUP = "CUP"
    case CVE = "CVE"
    case CZK = "CZK"
    case DJF = "DJF"
    case DKK = "DKK"
    case DOP = "DOP"
    case DZD = "DZD"
    case EGP = "EGP"
    case ERN = "ERN"
    case ETB = "ETB"
    case EUR = "EUR"
    case FJB = "FJB"
    case GBP = "GBP"
    case GEL = "GEL"
    case GHS = "GHS"
    case GMD = "GMD"
    case GNF = "GNF"
    case GTQ = "GTQ"
    case GYD = "GYD"
    case HKD = "HKD"
    case HNL = "HNL"
    case HRK = "HRK"
    case HTG = "HTG"
    case HUF = "HUF"
    case IDR = "IDR"
    case ILS = "ILS"
    case INR = "INR"
    case IQD = "IQD"
    case IRR = "IRR"
    case ISK = "ISK"
    case JMD = "JMD"
    case JOD = "JOD"
    case JPY = "JPY"
    case KES = "KES"
    case KGS = "KGS"
    case KHR = "KHR"
    case KMF = "KMF"
    case KPW = "KPW"
    case KRW = "KRW"
    case KWD = "KWD"
    case KYD = "KYD"
    case KZT = "KZT"
    case LAK = "LAK"
    case LBP = "LBP"
    case LKR = "LKR"
    case LRD = "LRD"
    case LSL = "LSL"
    case LTL = "LTL"
    case LYD = "LYD"
    case MAD = "MAD"
    case MDL = "MDL"
    case MGA = "MGA"
    case MKD = "MKD"
    case MMK = "MMK"
    case MNT = "MNT"
    case MRO = "MRO"
    case MUR = "MUR"
    case MVR = "MVR"
    case MWK = "MWK"
    case MXN = "MXN"
    case MYR = "MYR"
    case MZN = "MZN"
    case NAD = "NAD"
    case NGN = "NGN"
    case NIO = "NIO"
    case NOK = "NOK"
    case NPR = "NPR"
    case NZD = "NZD"
    case OMR = "OMR"
    case PAB = "PAB"
    case PEN = "PEN"
    case PGK = "PGK"
    case PHP = "PHP"
    case PKR = "PKR"
    case PLN = "PLN"
    case PYG = "PYG"
    case QAR = "QAR"
    case RON = "RON"
    case RSD = "RSD"
    case RUB = "RUB"
    case RWF = "RWF"
    case SAR = "SAR"
    case SBD = "SBD"
    case SCR = "SCR"
    case SDG = "SDG"
    case SEK = "SEK"
    case SGD = "SGD"
    case SLL = "SLL"
    case SOS = "SOS"
    case SRD = "SRD"
    case SSP = "SSP"
    case STD = "STD"
    case SYP = "SYP"
    case SZL = "SZL"
    case THB = "THB"
    case TJS = "TJS"
    case TMT = "TMT"
    case TND = "TND"
    case TOP = "TOP"
    case TRY = "TRY"
    case TTD = "TTD"
    case TWD = "TWD"
    case TZS = "TZS"
    case UAH = "UAH"
    case UGX = "UGX"
    case USD = "USD"
    case UYU = "UYU"
    case UZS = "UZS"
    case VEF = "VEF"
    case VND = "VND"
    case VUV = "VUV"
    case WST = "WST"
    case XAF = "XAF"
    case XCD = "XCD"
    case XOF = "XOF"
    case YER = "YER"
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
        case .BRL:
            return "Brazil Real"
        case .BSD:
            return "Bahamian Dollar"
        case .BTN:
            return "Bhutanese Ngultrum"
        case .BWP:
            return "Botswana Pula"
        case .BYN:
            return "Belarusian Ruble"
        case .BZD:
            return "Belize Dollar"
        case .CAD:
            return "Canada Dollar"
        case .CDF:
            return "Congolese Franc"
        case .CHF:
            return "Switzerland Franc"
        case .CLP:
            return "Chile Peso"
        case .CNY:
            return "China Yuan"
        case .COP:
            return "Colombia Peso"
        case .CRC:
            return "Costa Rica Colon"
        case .CUP:
            return "Cuban Peso"
        case .CVE:
            return "Cape Verdean Escudo"
        case .CZK:
            return "Czech Koruna"
        case .DJF:
            return "Djiboutian Franc"
        case .DKK:
            return "Denmark Krone"
        case .DOP:
            return "Dominican Republic Peso"
        case .DZD:
            return "Algerian Dinar"
        case .EGP:
            return "Egypt Pound"
        case .ERN:
            return "Eritrean Nakfa"
        case .ETB:
            return "Ethiopian Birr"
        case .EUR:
            return "Euro"
        case .FJB:
            return "Fijian Dollar"
        case .GBP:
            return "British Pound"
        case .GEL:
            return "Georgian Lari"
        case .GHS:
            return "Ghana Cedi"
        case .GMD:
            return "Gambian Dalasi"
        case .GNF:
            return "Guinean Franc"
        case .GTQ:
            return "Guatemalan Quetzal"
        case .GYD:
            return "Guyana Dollar"
        case .HKD:
            return "Hong Kong Dollar"
        case .HNL:
            return "Honduran Lempira"
        case .HRK:
            return "Croatia Kuna"
        case .HTG:
            return "Haitian Gourde"
        case .HUF:
            return "Hungary Forint"
        case .IDR:
            return "Indonesia Rupiah"
        case .ILS:
            return "Israel Shekel"
        case .INR:
            return "India Rupee"
        case .IQD:
            return "Iraqi Dinar"
        case .IRR:
            return "Iranian Rial"
        case .ISK:
            return "Icelandic Króna"
        case .JMD:
            return "Jamaica Dollar"
        case .JOD:
            return "Jordanian Dinar"
        case .JPY:
            return "Japanese Yen"
        case .KES:
            return "Kenyan Shilling"
        case .KGS:
            return "Kyrgyzstani Som"
        case .KHR:
            return "Cambodian Riel"
        case .KMF:
            return "Comorian Franc"
        case .KPW:
            return "North Korean Won"
        case .KRW:
            return "South Korea Won"
        case .KWD:
            return "Kuwaiti Dinar"
        case .KYD:
            return "Cayman Islands Dollar"
        case .KZT:
            return "Kazakhstan Tenge"
        case .LAK:
            return "Laos Kip"
        case .LBP:
            return "Lebanese Pound"
        case .LKR:
            return "Sri Lanka Rupee"
        case .LRD:
            return "Liberia Dollar"
        case .LSL:
            return "Lesotho Loti"
        case .LTL:
            return "Lithuanian Litas"
        case .LYD:
            return "Libyan Dinar"
        case .MAD:
            return "Moroccan Dirham"
        case .MDL:
            return "Moldovan Leu"
        case .MGA:
            return "Malagasy Ariary"
        case .MKD:
            return "Macedonia Denar"
        case .MMK:
            return "Burmese Kyat"
        case .MNT:
            return "Mongolia Tughrik"
        case .MRO:
            return "Mauritanian Ouguiya"
        case .MUR:
            return "Mauritius Rupee"
        case .MVR:
            return "Maldivian Rufiyaa"
        case .MWK:
            return "Malawian Kwacha"
        case .MXN:
            return "Mexico Peso"
        case .MYR:
            return "Malaysia Ringgit"
        case .MZN:
            return "Mozambique Metical"
        case .NAD:
            return "Namibia Dollar"
        case .NGN:
            return "Nigeria Naira"
        case .NIO:
            return "Nicaragua Cordoba"
        case .NOK:
            return "Norway Krone"
        case .NPR:
            return "Nepal Rupee"
        case .NZD:
            return "New Zealand Dollar"
        case .OMR:
            return "Oman Rial"
        case .PAB:
            return "Panamanian Balboa"
        case .PEN:
            return "Peru Sol"
        case .PGK:
            return "Papua New Guinean Kina"
        case .PHP:
            return "Philippines Peso"
        case .PKR:
            return "Pakistan Rupee"
        case .PLN:
            return "Polski Złoty"
        case .PYG:
            return "Paraguay Guarani"
        case .QAR:
            return "Qatar Riyal"
        case .RON:
            return "Romania Leu"
        case .RSD:
            return "Serbia Dinar"
        case .RUB:
            return "Russia Ruble"
        case .RWF:
            return "Rwandan Franc"
        case .SAR:
            return "Saudi Arabia Riyal"
        case .SBD:
            return "Solomon Islands Dollar"
        case .SCR:
            return "Seychellois Rupee"
        case .SDG:
            return "Sudanese Pound"
        case .SEK:
            return "Sweden Krona"
        case .SGD:
            return "Singapore Dollar"
        case .SLL:
            return "Sierra Leonean Leone"
        case .SOS:
            return "Somalia Shilling"
        case .SRD:
            return "Suriname Dollar"
        case .SSP:
            return "South Sudanese Pound"
        case .STD:
            return "São Tomé & Príncipe Dobra"
        case .SYP:
            return "Syrian Pound"
        case .SZL:
            return "Swazi Lilangeni"
        case .THB:
            return "Thailand Baht"
        case .TJS:
            return "Tajikistani Somoni"
        case .TMT:
            return "Turkmenistan Manat"
        case .TND:
            return "Tunisian Dinar"
        case .TOP:
            return "Tongan Pa'anga"
        case .TRY:
            return "Turkish Lira"
        case .TTD:
            return "Trinidad and Tobago Dollar"
        case .TWD:
            return "Taiwan New Dollar"
        case .TZS:
            return "Tanzanian Shilling"
        case .UAH:
            return "Ukraine Hryvnia"
        case .UGX:
            return "Ugandan Shilling"
        case .USD:
            return "United States Dollar"
        case .UYU:
            return "Uruguay Peso"
        case .UZS:
            return "Uzbekistani Som"
        case .VEF:
            return "Venezuela Bolívar"
        case .VND:
            return "Vietnamese Dong"
        case .VUV:
            return "Vanuatu Vatu"
        case .WST:
            return "Samoan Tala"
        case .XAF:
            return "Central African CFA Franc"
        case .XCD:
            return "East Caribbean Dollar"
        case .XOF:
            return "West African CFA Franc"
        case .YER:
            return "Yemen Rial"
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
        case .BRL:
            return "R$"
        case .BSD:
            return "B$"
        case .BTN:
            return "Nu."
        case .BWP:
            return "P"
        case .BYN:
            return "Br"
        case .BZD:
            return "BZ$"
        case .CAD:
            return "$"
        case .CDF:
            return "FC"
        case .CHF:
            return "CHF"
        case .CLP:
            return "$"
        case .CNY:
            return "¥"
        case .COP:
            return "$"
        case .CRC:
            return "₡"
        case .CUP:
            return "$"
        case .CVE:
            return "$"
        case .CZK:
            return "Kč"
        case .DJF:
            return "Fdj"
        case .DKK:
            return "kr"
        case .DOP:
            return "RD$"
        case .DZD:
            return "دج"
        case .EGP:
            return "£"
        case .ERN:
            return "نافكا"
        case .ETB:
            return "Br"
        case .EUR:
            return "€"
        case .FJB:
            return "FJ$"
        case .GBP:
            return "£"
        case .GEL:
            return "₾"
        case .GHS:
            return "¢"
        case .GMD:
            return "D"
        case .GNF:
            return "FG"
        case .GTQ:
            return "Q"
        case .GYD:
            return "$"
        case .HKD:
            return "$"
        case .HNL:
            return "L"
        case .HRK:
            return "kn"
        case .HTG:
            return "G"
        case .HUF:
            return "Ft"
        case .IDR:
            return "Rp"
        case .ILS:
            return "₪"
        case .INR:
            return "₹"
        case .IQD:
            return "ع.د"
        case .IRR:
            return "﷼"
        case .ISK:
            return "kr"
        case .JMD:
            return "J$"
        case .JOD:
            return "د.ا"
        case .JPY:
            return "¥"
        case .KES:
            return "KSh"
        case .KGS:
            return "Лв"
        case .KHR:
            return "៛"
        case .KMF:
            return "CF"
        case .KPW:
            return "₩"
        case .KRW:
            return "₩"
        case .KWD:
            return "د.ك"
        case .KYD:
            return "$"
        case .KZT:
            return "лв"
        case .LAK:
            return "₭"
        case .LBP:
            return "ل.ل."
        case .LKR:
            return "₨"
        case .LRD:
            return "$"
        case .LSL:
            return "M"
        case .LTL:
            return "Lt"
        case .LYD:
            return "ل.د"
        case .MAD:
            return "MAD"
        case .MDL:
            return "MDL"
        case .MGA:
            return "Ar"
        case .MKD:
            return "ден"
        case .MMK:
            return "K"
        case .MNT:
            return "₮"
        case .MRO:
            return "UM"
        case .MUR:
            return "₨"
        case .MVR:
            return "Rf"
        case .MWK:
            return "MK"
        case .MXN:
            return "$"
        case .MYR:
            return "RM"
        case .MZN:
            return "MT"
        case .NAD:
            return "$"
        case .NGN:
            return "₦"
        case .NIO:
            return "C$"
        case .NOK:
            return "kr"
        case .NPR:
            return "₨"
        case .NZD:
            return "$"
        case .OMR:
            return "﷼"
        case .PAB:
            return "B/."
        case .PEN:
            return "S/."
        case .PGK:
            return "K"
        case .PHP:
            return "₱"
        case .PKR:
            return "₨"
        case .PLN:
            return "zł"
        case .PYG:
            return "Gs"
        case .QAR:
            return "﷼"
        case .RON:
            return "lei"
        case .RSD:
            return "Дин."
        case .RUB:
            return "₽"
        case .RWF:
            return "FRw"
        case .SAR:
            return "﷼"
        case .SBD:
            return "Si$"
        case .SCR:
            return "SR"
        case .SDG:
            return "ج.س."
        case .SEK:
            return "kr"
        case .SGD:
            return "$"
        case .SLL:
            return "Le"
        case .SOS:
            return "S"
        case .SRD:
            return "$"
        case .SSP:
            return "£"
        case .STD:
            return "Db"
        case .SYP:
            return "LS"
        case .SZL:
            return "E"
        case .THB:
            return "฿"
        case .TJS:
            return "ЅM"
        case .TMT:
            return "T"
        case .TND:
            return "د.ت"
        case .TOP:
            return "PT"
        case .TRY:
            return "₺"
        case .TTD:
            return "TT$"
        case .TWD:
            return "NT$"
        case .TZS:
            return "TSh"
        case .UAH:
            return "₴"
        case .UGX:
            return "USh"
        case .USD:
            return "$"
        case .UYU:
            return "$"
        case .UZS:
            return "so'm"
        case .VEF:
            return "Bs"
        case .VND:
            return "₫"
        case .VUV:
            return "VT"
        case .WST:
            return "SAT"
        case .XAF:
            return "FCFA"
        case .XCD:
            return "$"
        case .XOF:
            return "CFA"
        case .YER:
            return "﷼"
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
        case .BRL:
            return "🇧🇷"
        case .BSD:
            return "🇧🇸"
        case .BTN:
            return "🇧🇹"
        case .BWP:
            return "🇧🇼"
        case .BYN:
            return "🇧🇾"
        case .BZD:
            return "🇧🇿"
        case .CAD:
            return "🇨🇦"
        case .CDF:
            return "🇨🇩"
        case .CHF:
            return "🇨🇭"
        case .CLP:
            return "🇨🇱"
        case .CNY:
            return "🇨🇳"
        case .COP:
            return "🇨🇴"
        case .CRC:
            return "🇨🇷"
        case .CUP:
            return "🇨🇺"
        case .CVE:
            return "🇨🇻"
        case .CZK:
            return "🇨🇿"
        case .DJF:
            return "🇩🇯"
        case .DKK:
            return "🇩🇰"
        case .DOP:
            return "🇩🇴"
        case .DZD:
            return "🇩🇿"
        case .EGP:
            return "🇬🇪"
        case .ERN:
            return "🇪🇷"
        case .ETB:
            return "🇪🇹"
        case .EUR:
            return "🇪🇺"
        case .FJB:
            return "🇫🇯"
        case .GBP:
            return "🇬🇧"
        case .GEL:
            return "🇬🇪"
        case .GHS:
            return "🇬🇭"
        case .GMD:
            return "🇬🇲"
        case .GNF:
            return "🇬🇳"
        case .GTQ:
            return "🇬🇹"
        case .GYD:
            return "🇬🇾"
        case .HKD:
            return "🇭🇰"
        case .HNL:
            return "🇭🇳"
        case .HRK:
            return "🇭🇷"
        case .HTG:
            return "🇭🇹"
        case .HUF:
            return "🇭🇺"
        case .IDR:
            return "🇮🇩"
        case .ILS:
            return "🇮🇱"
        case .INR:
            return "🇮🇳"
        case .IQD:
            return "🇮🇶"
        case .IRR:
            return "🇮🇷"
        case .ISK:
            return "🇮🇸"
        case .JMD:
            return "🇯🇲"
        case .JOD:
            return "🇯🇴"
        case .JPY:
            return "🇯🇵"
        case .KES:
            return "🇰🇪"
        case .KGS:
            return "🇰🇬"
        case .KHR:
            return "🇰🇭"
        case .KMF:
            return "🇰🇲"
        case .KPW:
            return "🇰🇵"
        case .KRW:
            return "🇰🇷"
        case .KWD:
            return "🇰🇼"
        case .KYD:
            return "🇰🇾"
        case .KZT:
            return "🇰🇿"
        case .LAK:
            return "🇱🇦"
        case .LBP:
            return "🇱🇧"
        case .LKR:
            return "🇱🇰"
        case .LRD:
            return "🇱🇷"
        case .LSL:
            return "🇱🇸"
        case .LTL:
            return "🇱🇹"
        case .LYD:
            return "🇱🇾"
        case .MAD:
            return "🇲🇦"
        case .MDL:
            return "🇲🇩"
        case .MGA:
            return "🇲🇬"
        case .MKD:
            return "🇲🇰"
        case .MMK:
            return "🇲🇲"
        case .MNT:
            return "🇲🇳"
        case .MRO:
            return "🇲🇷"
        case .MUR:
            return "🇲🇺"
        case .MVR:
            return "🇲🇻"
        case .MWK:
            return "🇲🇼"
        case .MXN:
            return "🇲🇽"
        case .MYR:
            return "🇲🇾"
        case .MZN:
            return "🇲🇿"
        case .NAD:
            return "🇳🇦"
        case .NGN:
            return "🇳🇬"
        case .NIO:
            return "🇳🇮"
        case .NOK:
            return "🇳🇴"
        case .NPR:
            return "🇳🇵"
        case .NZD:
            return "🇳🇿"
        case .OMR:
            return "🇴🇲"
        case .PAB:
            return "🇵🇦"
        case .PEN:
            return "🇵🇪"
        case .PGK:
            return "🇵🇬"
        case .PHP:
            return "🇵🇭"
        case .PKR:
            return "🇵🇰"
        case .PLN:
            return "🇵🇱"
        case .PYG:
            return "🇵🇾"
        case .QAR:
            return "🇶🇦"
        case .RON:
            return "🇷🇴"
        case .RSD:
            return "🇷🇸"
        case .RUB:
            return "🇷🇺"
        case .RWF:
            return "🇷🇼"
        case .SAR:
            return "🇸🇦"
        case .SBD:
            return "🇸🇧"
        case .SCR:
            return "🇸🇨"
        case .SDG:
            return "🇸🇩"
        case .SEK:
            return "🇸🇪"
        case .SGD:
            return "🇸🇬"
        case .SLL:
            return "🇸🇱"
        case .SOS:
            return "🇸🇴"
        case .SRD:
            return "🇸🇷"
        case .SSP:
            return "🇸🇸"
        case .STD:
            return "🇸🇹"
        case .SYP:
            return "🇸🇾"
        case .SZL:
            return "🇸🇿"
        case .THB:
            return "🇹🇭"
        case .TJS:
            return "🇹🇯"
        case .TMT:
            return "🇹🇲"
        case .TND:
            return "🇹🇳"
        case .TOP:
            return "🇹🇴"
        case .TRY:
            return "🇹🇷"
        case .TTD:
            return "🇹🇹"
        case .TWD:
            return "🇹🇼"
        case .TZS:
            return "🇹🇿"
        case .UAH:
            return "🇺🇦"
        case .UGX:
            return "🇺🇬"
        case .USD:
            return "🇺🇸"
        case .UYU:
            return "🇺🇾"
        case .UZS:
            return "🇺🇿"
        case .VEF:
            return "🇻🇪"
        case .VND:
            return "🇻🇳"
        case .VUV:
            return "🇻🇺"
        case .WST:
            return "🇼🇸"
        case .XAF:
            return "🌍"
        case .XCD:
            return "🌎"
        case .XOF:
            return "🌍"
        case .YER:
            return "🇾🇪"
        case .ZAR:
            return "🇿🇦"
        case .ZMW:
            return "🇿🇲"
        }
    }
}
