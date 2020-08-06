//
//  ListView.swift
//  CalTrack
//
//  Created by Jalp on 31/10/2019.
//  Copyright © 2019 jdc0rp. All rights reserved.
//

import SwiftUI
import Combine

//**************** Displays a list with search bar ****************\\
struct ListView: View {
    //**************** Variables ****************\\
    @EnvironmentObject var session: SessionStore
    @ObservedObject var networkManager = NetworkManager.shared
    @State var term : String = ""
    @State var selectedFoodType = 1
    
    
    var body: some View {
        NavigationView {
            // List view that shows the result of search with food items
            List {
                SearchBar(text : $term)
                // Segmented Controls : Common or Branded Food Types
                Picker(selection: $selectedFoodType, label: Text("")) {
                    Text("Branded").tag(0)
                    Text("Common").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
                // Check the food type : Branded or Common
                if (selectedFoodType == 0) {
                    ForEach(networkManager.brandedProducts, id : \.food_name) { food in
                        BrandedTableList(brandedProduct : food)
                    }
                } else {
                    ForEach(networkManager.commonProducts, id : \.food_name) { food in
                        CommonTableList(commonProduct: food) 
                    }
                }
            }.navigationBarTitle(Text("Search"))
        }
    }
}

//**************** List that shows branded food item ****************\\
struct BrandedTableList : View {
    //**************** Variables ****************\\
    var brandedProduct : Branded
    @EnvironmentObject var session: SessionStore
    @ObservedObject var networkManager = NetworkManager.shared
    @State var isShowingFoodDetailView = false
    @State var isShowingItemDetailView = false
    
    var body: some View {
        HStack {
            ImageView(imageURL: brandedProduct.photo.thumb, vWidth: 90, vHeight: 90)
            Text(brandedProduct.food_name)
        }
        .onTapGesture() {
            print(self.brandedProduct.nix_item_id)
            self.networkManager.getBrandedFoodItemDetails(food_name: self.brandedProduct.nix_item_id, callback: {
                self.isShowingFoodDetailView.toggle()
            })
            
        }.sheet(isPresented: $isShowingFoodDetailView, content: {FoodDetailedView().environmentObject(self.session)})
            // Context Menu
            .contextMenu {
                Button(action: {
                    // View More
                    self.isShowingItemDetailView.toggle()
                }) {
                    HStack {
                        Text("View More")
                        Image(systemName: "doc.text.magnifyingglass")
                    }
                }.sheet(isPresented: $isShowingItemDetailView, content: {
                    ItemDetailView(itemImageURL: self.brandedProduct.photo.thumb, itemName: self.brandedProduct.food_name)
                })
        }
    }
}

//**************** List that shows common food item ****************\\
struct CommonTableList : View {
//**************** Variables ****************\\
    @EnvironmentObject var session: SessionStore
    @ObservedObject var networkManager = NetworkManager.shared
    @State var isShowingFoodDetailView = false
    @State var isShowingItemDetailView = false
    var commonProduct : Common
    
    var body: some View {
        HStack {
            ImageView(imageURL: commonProduct.photo.thumb, vWidth: 90, vHeight: 90)
            Text(commonProduct.food_name)
            
        }.onTapGesture() {
            print(self.commonProduct.food_name)
            self.networkManager.getCommonFoodItemDetails(food_name: self.commonProduct.food_name, callback: {
                self.isShowingFoodDetailView.toggle()
            })
            
        }.sheet(isPresented: $isShowingFoodDetailView, content: {FoodDetailedView().environmentObject(self.session)})
            .contextMenu {
                // Show a bigger preview of the food item
                Button(action: {
                    // View More
                    self.isShowingItemDetailView.toggle()
                }) {
                    HStack {
                        Text("View More")
                        Image(systemName: "doc.text.magnifyingglass")
                    }
                }.sheet(isPresented: $isShowingItemDetailView, content: {
                    ItemDetailView(itemImageURL: self.commonProduct.photo.thumb, itemName: self.commonProduct.food_name)
                })
        }
    }
}

//**************** Shows a bigger preview of the selected item ****************\\
struct ItemDetailView : View {
    var itemImageURL : String
    var itemName : String
    var body: some View {
        ZStack {
            VStack {
                ImageView(imageURL: itemImageURL, vWidth: 300, vHeight: 300)
                    .cornerRadius(20)
                    .padding()
                    .shadow(color: Color("textfield"), radius: 20, x: 0, y: 10)
                Text(itemName)
                    .fontWeight(Font.Weight.heavy)
                    .font(Font.system(size: 20))
                    .padding()
            }
        }.cornerRadius(20)
            .padding()
            .shadow(color: Color("textfield"), radius: 20, x: 10, y: 10)
    }
    
}

//**************** Resize the loaded image for List View ****************\\
struct ImageView : View {
//**************** Variables ****************\\
    @ObservedObject var imageLoader : ImageLoader
    var width : CGFloat = 90
    var height : CGFloat = 90
    
    init(imageURL : String, vWidth : CGFloat, vHeight : CGFloat) {
        imageLoader = ImageLoader(imageURL : imageURL)
        width = vWidth
        height = vHeight
    }
    
    var body: some View {
        Image(uiImage : ((imageLoader.data.count == 0) ? UIImage(named : "noimage")!
            : UIImage(data : imageLoader.data)!))
            .resizable()
            .frame(width: width, height: height)
            .cornerRadius(10)
    }
}

// Preview Provider
struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}




