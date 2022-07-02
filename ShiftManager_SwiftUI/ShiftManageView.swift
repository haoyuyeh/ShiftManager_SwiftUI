//
//  ShiftManageView.swift
//  ShiftManager_SwiftUI
//
//  Created by Hao Yu Yeh on 2022/6/30.
//

import SwiftUI

struct ShiftManageView: View {
    var body: some View {
        GeometryReader{ geo in
            
            ScrollView{
                VStack {
                    HStack{
                        Spacer()
                        Text("Shifts Arrange")
                            .bold()
                            .font(.largeTitle)
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    
                    HStack{
                        Spacer()
                        Text("Mon(20/6)")
                            .frame(maxWidth: geo.size.width*0.4)
                            .border(.red)
                        Text("Hours")
                            .frame(maxWidth: geo.size.width*0.2)
                            .border(.red)
                    }
                    .padding()
                    .border(.black)
                    Group{
                        staffRow()
                            .padding(.bottom,10)
                        staffRow()
                            .padding(.bottom,10)
                        staffRow()
                            .padding(.bottom,10)
                        staffRow()
                            .padding(.bottom,10)
                        staffRow()
                            .padding(.bottom,10)
                        staffRow()
                            .padding(.bottom,10)
                        staffRow()
                            .padding(.bottom,10)
                        staffRow()
                            .padding(.bottom,10)
                        staffRow()
                            .padding(.bottom,10)
                        staffRow()
                            .padding(.bottom,10)
                    }
                    
                }
            }
        }
    }
}

struct staffRow: View {
    @State var jobSelection = 0
    private var jobs = ["roll", "box1", "nigiri"]
    @State var shiftSelection = 0
    private var shifts = ["open", "general", "close"]
    
    var body: some View {
        GeometryReader{ geo in
            HStack(alignment: .center){
                    Spacer()
                Text("Angus")
                    .frame(maxWidth: geo.size.width*0.2)
                
                
                HStack(alignment: .center){
                        Picker(selection: $jobSelection, label: Text("job")) {
                            ForEach(0..<jobs.count, id: \.self) {
                                Text(self.jobs[$0])
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity)
                        
                        Picker(selection: $shiftSelection, label: Text("shift")) {
                            ForEach(0..<shifts.count, id: \.self) {
                                Text(self.shifts[$0])
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: geo.size.width*4)
//                    .border(.green)
                
                Text("10")
                    .frame(maxWidth: geo.size.width*0.2)
//                    .border(.green)
            }
//            .border(.black)
            
        }
    }
}

struct ShiftManageView_Previews: PreviewProvider {
    static var previews: some View {
        ShiftManageView()
    }
}
