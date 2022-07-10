//
//  SettingsView.swift
//  ShiftManager_SwiftUI
//
//  Created by Hao Yu Yeh on 2022/6/30.
//

import SwiftUI
import Combine

struct SettingsView: View {
    @StateObject var settingsViewModel = SettingsViewModel()
    
    @State private var storeSelection = 0
    @State private var isAuto = false
    
    var body: some View {
        
        VStack{
            // Page title
            HStack{
                Spacer()
                Text("Settings")
                    .bold()
                    .font(.largeTitle)
                Spacer()
            }
            .padding(.bottom, 10)
            Form{
                VStack(alignment: .leading, spacing: 1.0){
                    
                    // list all stores under managing
                    LabelBtnView(label: "Store", plusBtnDisabled: false, hasClear: false, textFieldPlaceHolder: "Store Name", action: settingsViewModel.addStore)
                    oneRowDisplayView(data: settingsViewModel.getAllStores())
                        .padding(.bottom)
                    
                    Picker(selection: $storeSelection, label: Text("Store")) {
                        ForEach(0..<settingsViewModel.getAllStores().count, id:\.self) {
                            Text(settingsViewModel.getAllStores()[$0])
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: storeSelection) { _ in
                        settingsViewModel.setCurrentStore(index: storeSelection)
                    }
                    
                    // list all available job positions
                    LabelBtnView(label: "Jobs", plusBtnDisabled: !settingsViewModel.hasStore(), hasClear: false, textFieldPlaceHolder: "Job Name", action: settingsViewModel.addJob)
                    oneRowDisplayView(data: settingsViewModel.getAllJobs())
                        .padding(.bottom)
                    
                    // list all shifts
                    LabelBtnView(label: "Shifts", plusBtnDisabled: !settingsViewModel.hasStore(), hasClear: false, textFieldPlaceHolder: "Shift Name", action: settingsViewModel.addShift)
                    twoRowDisplayView(data: settingsViewModel.getAllShifts())
                        .padding(.bottom)
                    
                    // list all constrains for auto shifts arrangement
                    
                    Toggle("Auto Shifts Arrange", isOn: $isAuto)
                    var dayLimits = ""
                    var shiftsLimits = ["","",""]
                    if isAuto {
                        Text("Constrains")
                            .bold()
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding(.horizontal, 5)
                            .background(.black)
                        constrainsView(shifts: settingsViewModel.getAllShifts(), dayLimits: dayLimits, shiftsLimits: shiftsLimits)
                    }
                }
            }
            .frame( maxHeight: .infinity, alignment: Alignment.topLeading)
            .padding([.top, .leading], 5)
        }
        
    }
}
///***********************************************************
///
/// this is a view with a plus button
///
/// - label: name of the view
/// - hasClear: determine the view has a clear button or not
/// - action: the function will be activated when the plus button is pressed
/// - clear: clear all the data which is added by the plus button
///
///************************************************************
struct LabelBtnView: View {
    var label: String
    var plusBtnDisabled: Bool
    var hasClear: Bool = false
    var textFieldPlaceHolder: String
    var action: (String) -> Void
    
    @State private var textEntered = ""
    @State private var showingAlert = false
    
    var body: some View {
        HStack{
            Text(label)
                .bold()
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.horizontal, 5)
                .background(.black)
                .onTapGesture {
                    
                }
            Button(action: {
                // show alert to get input from user, then do whatever you want for the plus button
                self.showingAlert.toggle()
                self.textEntered = ""
            }){
                Image(systemName: "plus")
                    .padding(.trailing, 8)
            }
            .disabled(plusBtnDisabled)
            .fullScreenCover(isPresented: $showingAlert) {
                self.showingAlert.toggle()
            } content: {
                OneInputAlertView(textEntered: $textEntered, showingAlert: $showingAlert, alertTitle: "Adding...", placeHolder: textFieldPlaceHolder, action: action)
            }


            // should show another view
            NavigationLink(destination: OneInputAlertView(textEntered: $textEntered, showingAlert: $showingAlert, alertTitle: label, placeHolder: textFieldPlaceHolder, action: action), isActive: $showingAlert){EmptyView()}
            if hasClear {
                Button( action: {
                    // clear all contents

                }) {
                    Image(systemName: "clear")
                        .padding(.trailing, 8)
                }
            }
        }
    }
}
///***********************************************************
///
/// this is a view displaying a row of input data
///
/// - data: list of data for displaying
///
///************************************************************
struct oneRowDisplayView: View {
    var data: [String]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing:1){
                ForEach(data, id : \.self){
                    Text($0)
                        .padding(.all, 5.0)
                        .border(.black)
                }
            }
        }
    }
}
///***********************************************************
///
/// this is a view displaying two rows of input data
///
/// - data: list of data for displaying
///
///************************************************************
struct twoRowDisplayView: View {
    var data: [(id: Int, row1: String, row2: String)]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 1) {
                ForEach(data, id: \.id) {input in
                    VStack{
                        Text(input.row1)
                        Text(input.row2)
                    }
                    .padding()
                    .border(.black)
                }
            }
        }
    }
}
///***********************************************************
///
/// showing some constrains needed to be filled for enabling the auto shifts arrange
/// function
///
/// - label: name of the view
/// - hasClear: determine the view has a clear button or not
/// - action: the function will be activated when the plus button is pressed
/// - clear: clear all the data which is added by the plus button
///
///************************************************************
struct constrainsView: View {
    var shifts: [(id: Int, name: String, time: String)]
    var dayLimits: String
    var shiftsLimits: [String]
    
    var body: some View {
        staffLimitsView(limits: dayLimits, limitLabel: "Daily HR limits:")
        ForEach(shifts, id: \.id) { shift in
            staffLimitsView(limits: shiftsLimits[shift.id-1], limitLabel: "\(shift.name) shift HR limits:")
        }
    }
}

struct staffLimitsView: View {
    @State  var limits: String
    var limitLabel: String
    
    var body: some View {
        HStack {
            Text(limitLabel)
            TextField("Numbers Only", text: $limits)
                .padding(.leading)
                .border(.black)
                .padding()
                .onChange(of: limits) { newValue in
                    if newValue.range(of: "^[0-9]+$", options: .regularExpression) == nil {
                        limits = ""
                    }
                }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
