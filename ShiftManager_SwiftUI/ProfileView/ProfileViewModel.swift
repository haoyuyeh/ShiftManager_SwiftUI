//
//  ProfileViewModel.swift
//  ShiftManager_SwiftUI
//
//  Created by Hao Yu Yeh on 2022/7/7.
//
import CoreData
import Combine

enum ProfileViewState {
    case noStore
    case noStaff
    case greenLight
}

class ProfileViewModel: ObservableObject {
    @Published var stores: [Store] = []
    @Published var profileViewState: ProfileViewState = .noStore
    
    let persistenceController = PersistenceController.shared
    var managedObjectContext = PersistenceController.shared.container.viewContext
    
    private var currentStore: Store? = nil
    private var storesName: [String] = []
    private var staffs: [Staff] = []
    private var jobs: [Job] = []
    private var shifts: [Shift] = []
    
    init() {
        updateStoreLists()
        checkProfileViewState()
    }
    
    func checkProfileViewState() {
        if stores.isEmpty {
            profileViewState = .noStore
        }else if staffs.isEmpty {
            profileViewState = .noStaff
        }else {
            profileViewState = .greenLight
        }
    }
    
    ///***********************************************************
    ///
    /// retrieve all store data from database
    ///
    ///************************************************************
    func updateStoreLists() {
        let storeFetch = Store.fetchRequest()
        storeFetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            let results = try managedObjectContext.fetch(storeFetch)
            stores = results
            if !stores.isEmpty{
                for store in stores {
                    storesName.append(store.name!)
                }
                updateCurrentStore(index: 0)
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    func updateCurrentStore(index: Int) {
        currentStore = stores[index]
        staffs = currentStore?.employees?.allObjects as! [Staff]
        jobs = currentStore?.jobs?.allObjects as! [Job]
        shifts = currentStore?.shifts?.allObjects as! [Shift]
    }
    
    func getAllStores() -> [String] {
        return storesName
    }
    
    func getStaff(index: Int) -> Staff {
        switch index {
        case 0...:
            if staffs.isEmpty {
                let nilStaff = Staff(context: persistenceController.container.viewContext)
                nilStaff.name = "Adding Staff first!!!"
                return nilStaff
            }else {
                return staffs[getCorrectStaffBoundary(index: index)]
            }
        default:
            let nilStore = Staff(context: persistenceController.container.viewContext)
            nilStore.name = "Adding Store first!!!"
            return nilStore
        }
        
    }
    
    func getCorrectStaffBoundary(index: Int) -> Int {
        return index % staffs.count
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
