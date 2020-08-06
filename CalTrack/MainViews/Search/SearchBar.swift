//
//  SearchBar.swift
//  CalTrack
//
//  Created by Jalp on 31/10/2019.
//  Copyright © 2019 jdc0rp. All rights reserved.
//

import Foundation
import SwiftUI

//**************** Search Bar ****************\\
struct SearchBar : UIViewRepresentable {
    
    @Binding var text : String
    
    // Bridge class to use UIKit in SwiftUI
    class Coordinator : NSObject, UISearchBarDelegate, UITextFieldDelegate {
        
        @Binding var text : String
        
        // Initialise the text property
        init(text : Binding<String>) {
            _text = text
        }
        
        // Sends the typed query by user to the API
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
            // Only send a request to api if 3 or more characters have been typed
            if (text.count >= 3) {
                NetworkManager.shared.performQuery(query : searchText)
            }
        }
        
        // Dismiss keyboard when search button is clicked
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
            searchBar.showsCancelButton = false
            searchBar.endEditing(true)
        }
    }
    
    // Delegate for Search Bar
    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame : .zero)
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    // Update the text everytime it changes
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
    
}
