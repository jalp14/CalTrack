//
//  DailyOverviewView.swift
//  CalTrack
//
//  Created by Jalp on 13/03/2020.
//  Copyright © 2020 jdc0rp. All rights reserved.
//

import Foundation
import SwiftUI


//**************** Referenced : https://exyte.com/blog/swiftui-tutorial-replicating-activity-application?utm_source=reddit&utm_medium=referral&utm_campaign=website_blog ****************\\
//**************** Circular Progress Bar ****************\\
struct CiruclarProgress : View {
    @State var show = false
    var body: some View {
        Circle()
            .trim(from: show ? 0.1 : 0.99, to: 1)
            .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
            .rotationEffect(.degrees(90))
            .rotation3DEffect(Angle(degrees: 100), axis: (x: 0, y: 1, z: 0))
            .frame(width: 100, height: 100)
            .animation(.easeOut)
            .onTapGesture {
                self.show.toggle()
        }
    }
}

//**************** Background for Circular Progress ****************\\
struct CircularBackgroundView: Shape {
    var thicc: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.width / 2, y: rect.height / 2),
            radius: rect.width / 2 - thicc,
            startAngle: Angle(degrees: 0),
            endAngle: Angle(degrees: 360),
            clockwise: false
        )
        return path
            .strokedPath(.init(lineWidth: thicc, lineCap: .round, lineJoin: .round))
    }
}

//**************** Shape for the circular progress ****************\\
struct CircularShape: Shape {
    var currentProgress: Double
    var thicc: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.width / 2, y: rect.height / 2),
            radius: rect.width / 2 - thicc,
            startAngle: Angle(degrees: 0),
            endAngle: Angle(degrees: 360 * (currentProgress / 100)),
            clockwise: false
        )
        
        return path
            .strokedPath(.init(lineWidth: thicc, lineCap: .round, lineJoin: .round))
    }
    // Animate the circular progress view
    var animatableData: Double {
        get { return currentProgress }
        set { currentProgress = newValue }
    }
}

//**************** Animated Circualr Progress Bar ****************\\
struct CircleView: View {
    //**************** Variables ****************\\
    @State var currentProgress: Double = 0 {
        didSet {
            // Animate everytime the value changes
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(self.animation) {
                    self.currentProgress = self.percentage
                }
            }
        }
    }
    var bkColor: Color
    var startColor: Color
    var endColor: Color
    var thicc: CGFloat
    var animation: Animation {
        Animation.easeInOut(duration: 0.9)
    }
    @Binding var percentage: Double
    
    var body: some View {
        let gradient = AngularGradient(gradient: Gradient(colors: [startColor, endColor]), center: .center, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360 * self.currentProgress))
        return ZStack {
            CircularBackgroundView(thicc: thicc)
                .fill(bkColor)
            CircularShape(currentProgress: currentProgress, thicc: thicc)
                .fill(gradient)
                .rotationEffect(.init(degrees: -90))
                .shadow(radius: 2)
                .drawingGroup()
                
                .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(self.animation) {
                            self.currentProgress = self.percentage
                        }
                    }
            }
        }
    }
}

//**************** Show the calorific progress of a user ****************\\
struct DailyOverView : View {
    @State var initial: CGFloat = 0.0
    @State var value: CGFloat = 0.0
    @Binding var intake: Double
    @Binding var caloriesBurned: Int
    @Binding var goalSetToday: Double
    @Binding var goalRatio : Double
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                
                Text("Calories Intake : \(self.intake.format(f: ".2")) kCAL")
                    .font(.body)
                    .bold()
                
                Text("Calories Burned : \(self.caloriesBurned.format(f: ".2")) kCAL")
                    .font(.body)
                    .bold()
                
                Text("Goal Set : \(self.goalSetToday.format(f: ".2")) kCAL")
                    .font(.body)
                    .bold()
                
            }
            ZStack {
                Text("\((self.goalRatio).format(f: ".2"))%")
                    .font(.body)
                    .bold()
                CircleView(currentProgress: goalRatio, bkColor: Color("ringbk"), startColor: Color("ringst"), endColor: Color("ringed"), thicc: 19.0, percentage: self.$goalRatio)
                    .frame(width: 130, height: 130)
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}

