//
//  ActivityIndicator.swift
//  CalTrack
//
//  Created by Jalp on 13/03/2020.
//  Copyright © 2020 jdc0rp. All rights reserved.
//

import Foundation
import SwiftUI

//**************** Shows the native indicator view ****************\\
class ActivityIndicator: UIViewController {
//**************** Variables ****************\\
    var indicator = UIActivityIndicatorView(style: .large)
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.9)
        // Disable autoresizing
        indicator.translatesAutoresizingMaskIntoConstraints = false
        // Start the animation
        indicator.startAnimating()
        
        // Disable autoresizing
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the view
        view.insertSubview(blurView, at: 0)
        view.addSubview(indicator)
        
        // Constraints to display it center
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        blurView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        blurView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
