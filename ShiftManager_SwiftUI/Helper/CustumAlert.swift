//
//  CustumAlert.swift
//  ShiftManager_SwiftUI
//
//  Created by Hao Yu Yeh on 2022/7/7.
//

import SwiftUI

enum AlertType {
    case oneTextField
    case oneTextAndTimeSpan
}

struct CustumAlert: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CustumAlert_Previews: PreviewProvider {
    static var previews: some View {
        CustumAlert()
    }
}


struct OneInputAlertView: View {
    @Binding var textEntered: String
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
    @Binding var textEntered: String
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
