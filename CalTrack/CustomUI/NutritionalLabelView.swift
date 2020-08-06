//
//  NutritionalLabelView.swift
//  CalTrack
//
//  Created by Jalp on 06/02/2020.
//  Copyright © 2020 jdc0rp. All rights reserved.
//

import SwiftUI


//**************** Custom View for Nutritional Label ****************\\
struct LabelBP: View {
    //**************** Variables ****************\\
    var name : String = "Fat"
    var nf_value : String = "13.0g"
    var nf_percent : String = "20%"
    var color : Color = .red
    var isEnergy : Bool = false
    var energyKJ : String?
    @State var nutrientDesc : String = ""
    
    var body: some View {
        ZStack {
            if(isEnergy) {
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .strokeBorder(Color("border"), lineWidth: 1, antialiased: true)
                    .frame(width: 105, height: 135)
            } else {
                RoundedRectangle(cornerRadius: 26)
                    .foregroundColor(color)
                    .frame(width: 105, height: 135)
            }
            
            VStack {
                Spacer()
                Text("\(name)")
                    .font(.headline)
                    .foregroundColor(Color("border"))
                Spacer()
                
                Text("\(nf_value)")
                    .font(.subheadline)
                    .foregroundColor(Color("border"))
                Spacer()
                
                if(isEnergy) {
                    Text(energyKJ ?? "Failed")
                } else {
                    Text(nutrientDesc)
                }
                
                Spacer()
                ZStack {
                    if(isEnergy) {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(Color("border"), lineWidth: 1, antialiased: true)
                            .frame(width: 75, height: 25)
                    } else {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .foregroundColor(.white)
                            .frame(width: 75, height: 25)
                    }
                    Spacer()
                    
                    if(isEnergy) {
                        Text("\(nf_percent)")
                            .font(.subheadline)
                            .foregroundColor(Color("border"))
                    } else {
                        Text("\(nf_percent)")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                }
                Spacer()
            }.frame(width: 105, height: 135)
                .onAppear() {
                    if self.color == .red {
                        self.nutrientDesc = "High"
                    } else if self.color == .orange {
                        self.nutrientDesc = "Medium"
                    } else if self.color == .green {
                        self.nutrientDesc = "Low"
                    }
            }
        }
    }
}

//**************** Populates the custom view for Nutritional Label ****************\\
struct NutritionalLabelView: View {
    //**************** Variables ****************\\
    var energyValue : String = "120"
    var energyPercent : String = "10%"
    var energyColor : Color = .white
    var energyJ : String = "12kJ"
    
    var fatValue : String = "1.2g"
    var fatPercent : String = "3%"
    var fatColor : Color = .orange
    
    var saturatesValue : String = "2.4g"
    var saturatesPercent : String = "5%"
    var saturatesColor : Color = .red
    
    var sugarsValue : String = "3.2g"
    var sugarsPercent : String = "2%"
    var sugarsColor : Color = .green
    
    var saltValue : String = "0.3g"
    var saltPercent : String = "<1%"
    var saltColor : Color = .green
    
    // View that displays different nutritional labels
    var body: some View {
        VStack {
            HStack {
                LabelBP(name: "Energy", nf_value: energyValue, nf_percent: energyPercent, color: energyColor, isEnergy: true, energyKJ: energyJ)
                
                LabelBP(name: "Fat", nf_value: fatValue, nf_percent: fatPercent, color: fatColor, isEnergy: false)
                
                LabelBP(name: "Saturates", nf_value: saturatesValue, nf_percent: saturatesPercent, color: saturatesColor, isEnergy: false)
            }
            HStack {
                LabelBP(name: "Sugars", nf_value: sugarsValue, nf_percent: sugarsPercent, color: sugarsColor, isEnergy: false)
                
                LabelBP(name: "Salt", nf_value: saltValue, nf_percent: saltPercent, color: saltColor, isEnergy: false)
            }
        }
    }
}

struct NutritionalLabelView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionalLabelView()
    }
}
