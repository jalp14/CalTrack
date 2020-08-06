//
//  VisualBlur.swift
//  CalTrack
//
//  Created by Jalp on 04/02/2020.
//  Copyright © 2020 jdc0rp. All rights reserved.
//

import SwiftUI

//**************** Provides Visual Blur in a view ****************\\
struct VisualBlur: UIViewRepresentable {
    let blurStyle: UIBlurEffect.Style
    
    func makeUIView(context: UIViewRepresentableContext<VisualBlur>) -> UIView {
        // Transparent Empty View
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        // Blur Effect
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        // Apply blur effect to the view
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        
        // Blur View Constraints
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<VisualBlur>) {
        // Don't know what to do
    }
}

