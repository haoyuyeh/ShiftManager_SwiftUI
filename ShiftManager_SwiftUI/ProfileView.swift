//
//  ProfileView.swift
//  ShiftManager_SwiftUI
//
//  Created by Hao Yu Yeh on 2022/6/30.
//

import SwiftUI

struct ProfileView: View {
    var weekHourLimits = ""
    
    var body: some View {
        GeometryReader{g in
            ZStack{
                staffCardView(staffName: "", bgColor: .black, weekHourLimits: weekHourLimits)
                    .position(x: g.size.width*0.6, y: g.size.height*0.6)
                    .offset(x: 40, y: -60)
                
                staffCardView(staffName: "", bgColor: .green, weekHourLimits: weekHourLimits)
                    .position(x: g.size.width*0.6, y: g.size.height*0.6)
                    .offset(x: 20, y: -30)
                staffCardView(staffName: "Angus", bgColor: .red, weekHourLimits: weekHourLimits)
                    .position(x: g.size.width*0.6, y: g.size.height*0.6)
                
            }
//            staffCardView(staffName: "Angus", weekHourLimits: weekHourLimits)
//                .position(x: g.size.width*0.6, y: g.size.height*0.6)
        }
    }
}

struct staffCardView: View {
    var staffName: String
    var bgColor: Color
    @State var weekHourLimits: String
    var body: some View {
        
        GeometryReader{ geometry in
            VStack(alignment: .leading, spacing: 1) {
               Text(staffName)
                    .bold()
                    .font(.largeTitle)
                    .alignmentGuide(.leading) { d in
                        -geometry.size.width*0.27
                    }
                    .padding([.top, .bottom], 20)
                
                HStack {
                    Text("Weekly Hour Limits:")
                        .font(.body)
                        //.padding(.bottom, 5)
                    TextField("Input Numbers Only", text: $weekHourLimits)
                        .padding(.leading, 5)
                        .border(.black)
                        .onChange(of: weekHourLimits) { newValue in
                            if newValue.range(of: "^[0-9]+$", options: .regularExpression) == nil {
                                weekHourLimits = ""
                            }
                        }
                }
                .padding(.bottom, 10)
                
                
                
                LabelBtnView(label: "Skills")
                let jobs :[String] = ["roll1","roll1","roll1","roll1","roll1",
                    "roll1","roll1","roll1","roll1","roll1",
                                      "roll1","roll1","roll1","roll1","roll1",
                                      "roll1","roll1","roll1","roll1","roll1"]
                jobView(jobTitles: jobs)
//                    .padding(.bottom)
            }
            .frame(maxWidth: geometry.size.width*0.8, maxHeight: geometry.size.height*0.8, alignment: .topLeading)
            .background(bgColor)
            .cornerRadius(20)
            
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
