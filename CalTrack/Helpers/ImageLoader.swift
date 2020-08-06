//
//  ImageLoader.swift
//  CalTrack
//
//  Created by Jalp on 30/04/2020.
//  Copyright © 2020 jdc0rp. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

// **************** Class loads images from remote URL and passes it back to the observing variable **************** \\
class ImageLoader : ObservableObject {
    var didChage = PassthroughSubject<Data, Never>()
    
    // Notify other subscriber classes when the URL is fetched
    @Published var data = Data() {
        didSet {
            didChage.send(data)
        }
    }
    
    init(imageURL : String) {
        guard let url = URL(string : imageURL) else { return }
        // Load the image asynchronously
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }.resume()
    }
}
