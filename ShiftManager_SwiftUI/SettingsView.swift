//
//  SettingsView.swift
//  ShiftManager_SwiftUI
//
//  Created by Hao Yu Yeh on 2022/6/30.
//

import SwiftUI
import Combine

struct SettingsView: View {
    @State var isAuto = false
    
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
                    
                    // list all available job positions
                    LabelBtnView(label: "Job Titles", hasClear: false, action: <#() -> Void#>)
                    // data retrieve from core data
                    let jobs :[String] = ["roll1","roll1","roll1","roll1","roll1",
                                          "roll1","roll1","roll1","roll1","roll1",
                                          "roll1","roll1","roll1","roll1","roll1",
                                          "roll1","roll1","roll1","roll1","roll1"]
                    jobView(jobTitles: jobs)
                        .padding(.bottom)
                    
                    // list all shifts
                    LabelBtnView(label: "Shifts", hasClear: false, action: <#() -> Void#>)
                    // retrieve from core data
                    let shifts = [(1,"open", "7am~5pm"),(2,"close", "8am~8pm"),(3,"general", "8am~5pm")]
                    shiftsView(shifts: shifts)
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
                        constrainsView(shifts: shifts, dayLimits: dayLimits, shiftsLimits: shiftsLimits)
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
    var hasClear: Bool
    var action: () -> Void
    var clear:(()->Void)?
    
    var body: some View {
        
        HStack{
            Text(label)
                .bold()
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.horizontal, 5)
                .background(.black)
            Button(action: {
                // show user input prompt to get job's name
                self.action()
            }){
                Image(systemName: "plus")
                    .padding(.trailing, 8)
            }
            if hasClear {
                Button( action: {
                    // clear all contents
                }) {
                    Image(systemName: "clear")
                        .padding(.trailing, 8)
                }
            }
            
            
        }.border(.black)
    }
}
///***********************************************************
///
/// this is a view showing all available job positions
///
/// - jobTitles: list of job positions
///
///************************************************************
struct jobView: View {
    var jobTitles: [String]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing:1){
                ForEach(jobTitles, id : \.self){
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
/// this is a view showing all available shifts
///
/// - shifts: list of shifts
///
///************************************************************
struct shiftsView: View {
    var shifts: [(id: Int, name: String, time: String)]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 1) {
                ForEach(shifts, id: \.id) {shift in
                    VStack{
                        Text(shift.name)
                        Text(shift.time)
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
        staffLimitsView(limits: dayLimits, limitLabel: "Daily staff limits:")
        ForEach(shifts, id: \.id) { shift in
            staffLimitsView(limits: shiftsLimits[shift.id-1], limitLabel: "\(shift.name) shift staff limits:")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct staffLimitsView: View {
    @State  var limits: String
    var limitLabel: String
    
    var body: some View {
        HStack {
            Text(limitLabel)
            TextField("Input Numbers Only", text: $limits)
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
