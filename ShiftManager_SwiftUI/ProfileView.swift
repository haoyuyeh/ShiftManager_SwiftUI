//
//  ProfileView.swift
//  ShiftManager_SwiftUI
//
//  Created by Hao Yu Yeh on 2022/6/30.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        GeometryReader{g in
            staffCardView(staffName: "Angus")
                .position(x: g.size.width*0.6, y: g.size.height*0.6)
        }
        
        
//        GeometryReader{geometry in
//            staffCardView()
//                .background(.red)
//            .cornerRadius(10)
//            .frame(width: geometry.size.width*0.5, height: geometry.size.height/2, alignment: Alignment.center)
//
//        }
        
//        VStack(alignment: .leading, spacing: 1.0){
//            LabelBtnView(label: "Job Titles")
//                .frame(width: .infinity, alignment: .leading)
//            let jobs :[String] = ["roll1","roll1","roll1","roll1","roll1",
//                "roll1","roll1","roll1","roll1","roll1",
//                                  "roll1","roll1","roll1","roll1","roll1",
//                                  "roll1","roll1","roll1","roll1","roll1"]
//            jobView(jobTitles: jobs)
//                .padding(.bottom)
//
//
//            LabelBtnView(label: "Shifts")
//                .frame(width: .infinity, height: .infinity, alignment: .leading)
//            let shifts = [(1,"open", "7am~5pm"),(2,"close", "8am~8pm"),(3,"general", "8am~5pm")]
//            shiftsView(shifts: shifts)
//                .padding(.bottom)
//        }
//        .frame( maxHeight: .infinity, alignment: Alignment.topLeading)
//        .padding([.top, .leading], 5)
    }
}

struct staffCardView: View {
    var staffName: String
    
    var body: some View {
        
        GeometryReader{ geometry in
            VStack{
                Text(staffName)
                    .bold()
                    .font(.largeTitle)
                
                
                LabelBtnView(label: "Job Titles")
                let jobs :[String] = ["roll1","roll1","roll1","roll1","roll1",
                    "roll1","roll1","roll1","roll1","roll1",
                                      "roll1","roll1","roll1","roll1","roll1",
                                      "roll1","roll1","roll1","roll1","roll1"]
                jobView(jobTitles: jobs)
//                    .padding(.bottom)
            }
            .frame(width: geometry.size.width*0.8, height: geometry.size.height*0.8)
            .background(.red)
            .cornerRadius(20)
            
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
