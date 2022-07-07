//
//  SettingsViewModel.swift
//  ShiftManager_SwiftUI
//
//  Created by Hao Yu Yeh on 2022/7/7.
//

import Combine

class SettingsViewModel: ObservableObject {
    
    
    func addShift() {
        
    }
    
    func addJob() {
        
    }
    
    func getAllJobs() -> [String] {
        let jobs :[String] = ["roll1","roll1","roll1","roll1","roll1",
                              "roll1","roll1","roll1","roll1","roll1",
                              "roll1","roll1","roll1","roll1","roll1",
                              "roll1","roll1","roll1","roll1","roll1"]
        return jobs
    }
    
    func getAllShifts() -> [(Int, String, String)] {
        let shifts = [(1,"open", "7am~5pm"),(2,"close", "8am~8pm"),(3,"general", "8am~5pm")]
        return shifts
    }
}
