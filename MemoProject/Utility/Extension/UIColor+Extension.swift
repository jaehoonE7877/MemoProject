//
//  UIColor.swift
//  MemoProject
//
//  Created by Seo Jae Hoon on 2022/09/05.
//

import UIKit

extension UIColor {
    static var defaultBackgroundColor: UIColor {
            if #available(iOS 13, *) {
                return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                    if traitCollection.userInterfaceStyle == .light {
                        return .darkGray
                    } else {
                        return systemGray6
                    }
                }
            } else {
                return .systemBackground
            }
        }
    static var defaultTextColor: UIColor {
            if #available(iOS 13, *) {
                return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                    if traitCollection.userInterfaceStyle == .light {
                        return .white
                    } else {
                        return .white
                    }
                }
            } else {
                return .black
            }
        }
}
