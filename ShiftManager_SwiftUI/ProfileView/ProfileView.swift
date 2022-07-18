//
//  ProfileView.swift
//  ShiftManager_SwiftUI
//
//  Created by Hao Yu Yeh on 2022/6/30.
//

import SwiftUI

struct ProfileView: View {
    @StateObject  var profileViewModel = ProfileViewModel()
    
    var body: some View {
        switch profileViewModel.profileViewState {
        case .noStore:
            Text("Adding a store first!!!")
                .font(.largeTitle)
                .foregroundColor(.red)
        case .noStaff:
            VStack{
                HeaderView(viewModel: profileViewModel)
                Spacer()
                Text("Adding a staff first!!!")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                Spacer()
            }
        case .greenLight:
            VStack{
                HeaderView(viewModel: profileViewModel)
                StaffsView(viewModel: profileViewModel)
            }
        }
    }
}

struct HeaderView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var storeSelection = 0
    @State private var showingAlert = false
    var body: some View {
        HStack{
            Picker(selection: $storeSelection, label: Text("Store")) {
                ForEach(0..<viewModel.getAllStores().count, id:\.self) {
                    Text(viewModel.getAllStores()[$0])
                }
            }
            .pickerStyle(.menu)
            .onChange(of: storeSelection) { newValue in
                viewModel.updateCurrentStore(index: storeSelection)
            }
            .padding(.leading, 10)
            Spacer()
            Text("Profile")
                .bold()
                .font(.largeTitle)
            Spacer()
            Button(action: {
                // input staff name and the store he belongs to
                showingAlert.toggle()
            }){
                Image(systemName: "person.fill.badge.plus")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .aspectRatio(contentMode: .fill)
            }
            .padding([.top, .bottom, .trailing], 10)
            .fullScreenCover(isPresented: $showingAlert) {
            } content: {
                OneInputAlertView(showingAlert: $showingAlert, alertTitle: "Adding...", placeHolder: "Staff's name", action: viewModel.addStaff)
//                OneInputAndSelectionAlertView(showingAlert: $showingAlert, alertTitle: "Adding...", placeHolder: "Staff's name", optionName: "Belong to", options: viewModel.getAllStores(), action: viewModel.addStaff)
            }
            
        }
    }
}

struct StaffsView: View {
    @ObservedObject var viewModel: ProfileViewModel

    @State private var currentStaff = 0
    
    var body: some View {
        VStack{
            GeometryReader{g in
                ZStack{
                    staffCardView(profileViewModel: viewModel, staff: nil, bgColor: .black)
                        .position(x: g.size.width*0.6, y: g.size.height*0.7)
                        .offset(x: 40, y: -60)
                    
                    staffCardView(profileViewModel: viewModel, staff: nil, bgColor: .gray)
                        .position(x: g.size.width*0.6, y: g.size.height*0.7)
                        .offset(x: 20, y: -30)
                    
                    staffCardView(profileViewModel: viewModel, staff: viewModel.getStaff(index: currentStaff), bgColor: .red)
                        .position(x: g.size.width*0.6, y: g.size.height*0.7)
                }
            }
        }
    }
}


struct staffCardView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var staff: Staff?
    var bgColor: Color
    @State var weekHourLimits: String = ""
    
    var body: some View {
        
        GeometryReader{ geometry in
            if let staff = staff {
                VStack(alignment: .leading, spacing: 1) {
                    HStack{
                        Spacer()
                        Text(staff.name!)
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
                    
                    LabelBtnView(label: "Skills", plusBtnDisabled: false, hasClear: false, textFieldPlaceHolder: "Skill Name", alertType: .inputText, action: profileViewModel.addSkill)
                    let jobs :[String] = ["roll1","roll1","roll1","roll1","roll1",
                                          "roll1","roll1","roll1","roll1","roll1",
                                          "roll1","roll1","roll1","roll1","roll1",
                                          "roll1","roll1","roll1","roll1","roll1"]
                    oneRowDisplayView(data: jobs)
                        .padding(.bottom)
                    
                    LabelBtnView(label: "Day Off", plusBtnDisabled: false, hasClear: false, textFieldPlaceHolder: "day off", alertType: .inputTextAndTimeSpan, action: profileViewModel.addDayOff)
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

//struct multipleSelectionView: View {
//    var options: [String]
//
//    var body: some View {
//
//    }
//}


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
