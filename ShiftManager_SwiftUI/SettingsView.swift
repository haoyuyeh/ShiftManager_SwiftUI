//
//  SettingsView.swift
//  ShiftManager_SwiftUI
//
//  Created by Hao Yu Yeh on 2022/6/30.
//

import SwiftUI
import Combine

struct SettingsView: View {
    
    
    var body: some View {
        
        
        
        VStack(alignment: .leading, spacing: 1.0){
            HStack{
                Spacer()
                Text("Settings")
                    .bold()
                    .font(.largeTitle)
                Spacer()
            }
            .padding(.bottom, 10)
            
            LabelBtnView(label: "Job Titles", hasClear: false)
            let jobs :[String] = ["roll1","roll1","roll1","roll1","roll1",
                "roll1","roll1","roll1","roll1","roll1",
                                  "roll1","roll1","roll1","roll1","roll1",
                                  "roll1","roll1","roll1","roll1","roll1"]
            jobView(jobTitles: jobs)
                .padding(.bottom)
            
            
            LabelBtnView(label: "Shifts", hasClear: false)
            let shifts = [(1,"open", "7am~5pm"),(2,"close", "8am~8pm"),(3,"general", "8am~5pm")]
            shiftsView(shifts: shifts)
                .padding(.bottom)
            
            
            var dayLimits = ""
            var shiftsLimits = ["","",""]
            Text("Constrains")
                .bold()
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.horizontal, 5)
                .background(.black)
            constrainsView(shifts: shifts, dayLimits: dayLimits, shiftsLimits: shiftsLimits)
           
            
        }
        .frame( maxHeight: .infinity, alignment: Alignment.topLeading)
        .padding([.top, .leading], 5)
    }
}

struct LabelBtnView: View {
    var label: String
    var hasClear: Bool
    
    var body: some View {
        
        HStack{
            Text(label)
                .bold()
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.horizontal, 5)
                .background(.black)
            Button(action: {
                // show user input prompt
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

struct constrainsView: View {
    var shifts: [(id: Int, name: String, time: String)]
    var dayLimits: String
    var shiftsLimits: [String]
    
    var body: some View {
        Form{
            staffLimitsView(limits: dayLimits, limitLabel: "Daily staff limits:")
            ForEach(shifts, id: \.id) { shift in
                staffLimitsView(limits: shiftsLimits[shift.id-1], limitLabel: "\(shift.name) shift staff limits:")
            }
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
