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
            
            VStack{
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
                    Text("Mon (20/6)")
                        .frame(maxWidth: geo.size.width*0.4)
                    Text("Hours")
                        .frame(maxWidth: geo.size.width*0.2)
                }
                .padding()
                .border(.black)
                
                staffRow()
            }
            
            
        }
    }
}

struct staffRow: View {
    @State var jobSelection = ""
    
    var body: some View {
        GeometryReader{ geo in
            HStack{
                Spacer()
                Text("Angus")
                    .frame(maxWidth: geo.size.width*0.2)
               
                .frame(maxWidth: geo.size.width*0.2)
                Text("10")
                    .frame(maxWidth: geo.size.width*0.2)
            }
            .border(.black)
        }
    }
}

struct ShiftManageView_Previews: PreviewProvider {
    static var previews: some View {
        ShiftManageView()
    }
}
