//
//  AppAppearance.swift
//  Optima Coding Challenge
//
//  Created by Sukhpreet  Deol on 8/30/17.
//  Copyright © 2017 Sukhpreet  Deol. All rights reserved.
//

import UIKit

struct AppAppearance {
    
    static func setDefaultAppearance() {
        
        let attributedNavTitle = [ NSAttributedStringKey.foregroundColor:UIColor.black , NSAttributedStringKey.font:UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular) ]
        let attributedBarButton = [ NSAttributedStringKey.foregroundColor:UIColor.darkGray , NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light) ]
        
        UIBarButtonItem.appearance().setTitleTextAttributes(attributedBarButton, for: .normal)
        UINavigationBar.appearance().barStyle = .default
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().titleTextAttributes = attributedNavTitle
        UINavigationBar.appearance().shadowImage = UIImage()
        
    }
    
}
