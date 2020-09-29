//
//  Colors.swift
//  With a Plan
//
//  Created by mac on 22.09.2020.
//  Copyright © 2020 Oleg Stasiw. All rights reserved.
//

import UIKit

enum MyColors: CaseIterable {
    case colbat
    case cerulean
    case blueOne
    case lightBlue
    case superLightBlue
    case blueTwo
    case blueliht
    case sapphire
    case teal
    case ocean
    case sharmrock
    case emerald
    case parakeet
    case mokhito
    case lime
    case crocodile
    case mint
    case blonde
    case yellow
    case banana
    case fire
    case orange
    case ginger
    case red
    case rose
    case candy
    case ruby
    case watermelone
    case flamingo
    case pink
    case hotpink
    case iris
    case purple
    case jam
    case salt
    case cream
    case snow
    case mimt
    case lace
    case frost
}

extension MyColors {
    var value: UIColor {
        get {
            switch self {
            case .lightBlue:
                return UIColor.init(red: 0.19, green: 0.73, blue: 0.98, alpha: 1)
            case .superLightBlue:
                return UIColor.init(red: 0, green: 0.81, blue: 1, alpha: 1)
            case .blueliht:
                return UIColor.init(red: 0, green: 1, blue: 1, alpha: 1)
            case .blueOne:
                return UIColor.init(red: 0.5, green: 0.71, blue: 1, alpha: 1)
            case .blueTwo:
                return UIColor.init(red: 0.21, green: 0.88, blue: 1, alpha: 1)
            case .sapphire:
                return UIColor.init(red: 0.06, green: 0.56, blue: 0.62, alpha: 1)
            case .cerulean:
                return UIColor.init(red: 0.07, green: 0.51, blue: 0.93, alpha: 1)
            case .colbat:
                return UIColor.init(red: 0, green: 0.27, blue: 0.93, alpha: 1)
            case .teal:
                return UIColor.init(red: 0, green: 0.68, blue: 0.78, alpha: 1)
            case .ocean:
                return UIColor.init(red: 0, green: 0.52, blue: 0.59, alpha: 1)
            case .sharmrock:
                return UIColor.init(red: 0, green: 0.76, blue: 0.59, alpha: 1)
            case .emerald:
                return UIColor.init(red: 0, green: 0.57, blue: 0.24, alpha: 1)
            case .parakeet:
                return UIColor.init(red: 0, green: 0.89, blue: 0.37, alpha: 1)
            case .mokhito:
                return UIColor.init(red: 0, green: 0.89, blue: 0.67, alpha: 1)
            case .lime:
                return UIColor.init(red: 0.28, green: 0.95, blue: 0.18, alpha: 1)
            case .crocodile:
                return UIColor.init(red: 0.24, green: 0.42, blue: 0.13, alpha: 1)
            case .mint:
                return UIColor.init(red: 0.41, green: 0.95, blue: 0.82, alpha: 1)
            case .blonde:
                return UIColor.init(red: 0.93, green: 1, blue: 0.56, alpha: 1)
            case .yellow:
                return UIColor.init(red: 1, green: 1, blue: 0.31, alpha: 1)
            case .banana:
                return UIColor.init(red: 1, green: 1, blue: 0.53, alpha: 1)
            case .fire:
                return UIColor.init(red: 1, green: 0.74, blue: 0.37, alpha: 1)
            case .orange:
                return UIColor.init(red: 1, green: 0.52, blue: 0.23, alpha: 1)
            case .ginger:
                return UIColor.init(red: 0.74, green: 0.38, blue: 0.26, alpha: 1)
            case .red:
                return UIColor.init(red: 1, green: 0.38, blue: 0.35, alpha: 1)
            case .rose:
                return UIColor.init(red: 1, green: 0.21, blue: 0.35, alpha: 1)
            case .candy:
                return UIColor.init(red: 1, green: 0.26, blue: 0.02, alpha: 1)
            case .ruby:
                return UIColor.init(red: 0.64, green: 0, blue: 0, alpha: 1)
            case .watermelone:
                return UIColor.init(red: 1, green: 0.35, blue: 0.67, alpha: 1)
            case .flamingo:
                return UIColor.init(red: 1, green: 0.58, blue: 0.67, alpha: 1)
            case .pink:
                return UIColor.init(red: 0.96, green: 0.62, blue: 0.92, alpha: 1)
            case .hotpink:
                return UIColor.init(red: 1, green: 0.16, blue: 0.70, alpha: 1)
            case .iris:
                return UIColor.init(red: 0.82, green: 0.44, blue: 1, alpha: 1)
            case .purple:
                return UIColor.init(red: 0.53, green: 0.35, blue: 1, alpha: 1)
            case .jam:
                return UIColor.init(red: 0.62, green: 0.37, blue: 0.65, alpha: 1)
            case .salt:
                return UIColor.init(red: 0.84, green: 0.78, blue: 0.94, alpha: 1)
            case .cream:
                return UIColor.init(red: 0.88, green: 0.91, blue: 0.81, alpha: 1)
            case .snow:
                return UIColor.init(red: 0.71, green: 0.90, blue: 1, alpha: 1)
            case .mimt:
                return UIColor.init(red: 0.71, green: 1, blue: 1, alpha: 1)
            case .lace:
                return UIColor.init(red: 0.76, green: 0.80, blue: 0.93, alpha: 1)
            case .frost:
                return UIColor.init(red: 0.74, green: 0.92, blue: 0.93, alpha: 1)

            }

        }
    }
}
