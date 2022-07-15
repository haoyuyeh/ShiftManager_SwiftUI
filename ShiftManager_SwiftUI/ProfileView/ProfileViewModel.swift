//
//  ProfileViewModel.swift
//  ShiftManager_SwiftUI
//
//  Created by Hao Yu Yeh on 2022/7/7.
//
import CoreData
import Combine

class ProfileViewModel: ObservableObject {
    @Published var stores: [Store] = []
    
    let persistenceController = PersistenceController.shared
    var managedObjectContext = PersistenceController.shared.container.viewContext
    
    private var storesName: [String] = []
    
    init() {
        updateStoreLists()
    }
    
    ///***********************************************************
    ///
    /// retrieve all store data from database
    ///
    ///************************************************************
    func updateStoreLists() {
        let storeFetch = Store.fetchRequest()
        do {
            let results = try managedObjectContext.fetch(storeFetch)
            stores = results
            if !stores.isEmpty{
                for store in stores {
                    storesName.append(store.name!)
                }
            }
            
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        
    }
    
    func getAllStores() -> [String] {
        return storesName
    }
    
    func getStaff(index: Int) {
        
    }
    
    func addStaff(info: String) {
        
    }
    
    func addSkill(info: String) {
        
    }
    
    func addDayOff(info: String) {
        
    }
    
    func addWeeklyWorkingHourLimits(info: String) {
        
    }
    
    func clear() {
        
    }
}
