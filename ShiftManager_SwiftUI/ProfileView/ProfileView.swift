//
//  ProfileView.swift
//  ShiftManager_SwiftUI
//
//  Created by Hao Yu Yeh on 2022/6/30.
//

import SwiftUI

struct ProfileView: View {
    var weekHourLimits = ""
    @StateObject  var profileViewModel = ProfileViewModel()
    
    @State private var hasStore = false
   
    var body: some View {
        
        VStack{
            HStack{
                Spacer()
                Text("Profile")
                    .bold()
                    .font(.largeTitle)
                Spacer()
                Button(action: {
                    
                }){
                    Image(systemName: "person.fill.badge.plus")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .aspectRatio(contentMode: .fill)
                }
                .padding([.top, .bottom, .trailing], 10)
            }
            
            
            GeometryReader{g in
                ZStack{
                    staffCardView(profileViewModel: profileViewModel, staffName: "", bgColor: .black, weekHourLimits: weekHourLimits, hasStore: true, isEmpty: true)
                        .position(x: g.size.width*0.6, y: g.size.height*0.7)
                        .offset(x: 40, y: -60)
                    
                    staffCardView(profileViewModel: profileViewModel, staffName: "", bgColor: .gray, weekHourLimits: weekHourLimits, hasStore: true, isEmpty: true)
                        .position(x: g.size.width*0.6, y: g.size.height*0.7)
                        .offset(x: 20, y: -30)
                    staffCardView(profileViewModel: profileViewModel, staffName: "Angus", bgColor: .red, weekHourLimits: weekHourLimits, hasStore: true, isEmpty: false)
                        .position(x: g.size.width*0.6, y: g.size.height*0.7)
                    
                }
            }
        }
    }
}

struct staffCardView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var staffName: String
    var bgColor: Color
    @State var weekHourLimits: String
    var hasStore: Bool
    var isEmpty: Bool
    
    var body: some View {
        
        GeometryReader{ geometry in
            if !isEmpty {
                VStack(alignment: .leading, spacing: 1) {
                    HStack{
                        Spacer()
                        Text(staffName)
                             .bold()
                             .font(.largeTitle)
                             .padding([.top, .bottom], 20)
                        Spacer()
                    }
                        
                    
                   
                    
                    HStack {
                        Text("Weekly Hour Limits:")
                            .font(.body)
                            .padding(.leading, 5)
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
                    
                    LabelBtnView(label: "Skills", plusBtnDisabled: !hasStore, hasClear: false, textFieldPlaceHolder: "Skill Name", alertType: .oneTextField, action: profileViewModel.addSkill)
                    let jobs :[String] = ["roll1","roll1","roll1","roll1","roll1",
                        "roll1","roll1","roll1","roll1","roll1",
                                          "roll1","roll1","roll1","roll1","roll1",
                                          "roll1","roll1","roll1","roll1","roll1"]
                    oneRowDisplayView(data: jobs)
                        .padding(.bottom)
                    
                    LabelBtnView(label: "Day Off", plusBtnDisabled: !hasStore, hasClear: false, textFieldPlaceHolder: "day off", alertType: .oneTextAndTimeSpan, action: profileViewModel.addDayOff)
                    let dayOffs = [(1,"20/6", nil),(2,"23/6", "12pm~12pm")]

                    dayOffView(dayOffs: dayOffs)
                }
                .frame(maxWidth: geometry.size.width*0.7, maxHeight: geometry.size.height*0.6, alignment: .topLeading)
                .background(bgColor)
                .cornerRadius(20)
            }else {
                Text("")
                    .frame(maxWidth: geometry.size.width*0.7, maxHeight: geometry.size.height*0.6, alignment: .topLeading)
                    .background(bgColor)
                    .cornerRadius(20)
            }
        }
        
    }
}

struct dayOffView: View {
    var dayOffs: [(id: Int, date: String, time: String?)]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 1) {
                ForEach(dayOffs, id: \.id) {dayOff in
                    VStack{
                        Text(dayOff.date)
                        if let time = dayOff.time {
                            Text(time)
                        }
                    }
                    .frame(width: 100, height: 40)
                    .padding()
                    .border(.black)
//                    Divider()
                }
                Spacer()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
