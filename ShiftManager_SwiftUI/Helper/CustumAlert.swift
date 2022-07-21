//
//  CustumAlert.swift
//  ShiftManager_SwiftUI
//
//  Created by Hao Yu Yeh on 2022/7/7.
//

import SwiftUI



struct ShowMsgAlertView: View {
    @Binding var showingAlert: Bool
    
    var message: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
            VStack {
                Text(message)
                    .font(.title)
                    .foregroundColor(.black)
                
                Button("OK") {
                    self.showingAlert.toggle()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(width: 300, height: 200)
    }
}

struct OneInputAlertView: View {
    @State var textEntered: String = ""
    @Binding var showingAlert: Bool
    
    var alertTitle: String
    var placeHolder: String
    var action:(String)->()
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
            VStack {
                Text(alertTitle)
                    .font(.title)
                    .foregroundColor(.black)
                
                TextField(placeHolder, text: $textEntered)
                    .padding(5)
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                
                
                HStack{
                    Button("Cancel") {
                        textEntered = ""
                        self.showingAlert.toggle()
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.red)
                    Button("OK") {
                        action(textEntered)
                        self.showingAlert.toggle()
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(width: 300, height: 200)
    }
}

struct oneInputAndTimeSpanAlertView: View {
    @State var textEntered: String = ""
    @Binding var showingAlert: Bool
    
    var alertTitle: String
    var placeHolder: String
    var action:(String)->()
    @State private var currnetStartDate = Date()
    @State private var currnetEndDate = Date()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
            VStack {
                Text(alertTitle)
                    .font(.title)
                    .foregroundColor(.black)
                
                TextField(placeHolder, text: $textEntered)
                    .padding(5)
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                
                DatePicker("Start Time", selection: $currnetStartDate, displayedComponents: .hourAndMinute)
                DatePicker("End Time", selection: $currnetEndDate,  in: Calendar.current.date(byAdding: .minute,value: 1, to: currnetStartDate)!..., displayedComponents: .hourAndMinute)
                
                HStack{
                    Button("Cancel") {
                        textEntered = ""
                        self.showingAlert.toggle()
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.red)
                    Button("OK") {
                        action(textEntered + "," + TimeFormatter.shared.getTimeString(date: currnetStartDate, timeStyle: .short) + "," +  TimeFormatter.shared.getTimeString(date: currnetEndDate, timeStyle: .short))
                        self.showingAlert.toggle()
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(width: 300, height: 200)
    }
}

struct OneInputAndSelectionAlertView: View {
    @Binding var showingAlert: Bool
    
    var alertTitle: String
    var placeHolder: String
    @State var textEntered: String = ""
    @State var selection: Int = 0
    var optionName: String
    var options: [String]
    @State private var unprocessedMsg: String = ""
    var action:(String)->()
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
            VStack {
                Text(alertTitle)
                    .font(.title)
                    .foregroundColor(.black)
                
                TextField(placeHolder, text: $textEntered)
                    .padding(5)
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                
                // choosing which store you want to manage
                Picker(selection: $selection, label: Text(optionName)) {
                    ForEach(0..<options.count, id:\.self) {
                        Text(options[$0])
                    }
                }
                .pickerStyle(.menu)
                .onChange(of: selection) { _ in
                    unprocessedMsg = textEntered + "," + String(selection)
                }
                
                HStack{
                    Button("Cancel") {
                        textEntered = ""
                        self.showingAlert.toggle()
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.red)
                    Button("OK") {
                        action(unprocessedMsg)
                        self.showingAlert.toggle()
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(width: 300, height: 200)
    }
}
