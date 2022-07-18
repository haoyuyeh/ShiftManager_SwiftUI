//
//  SettingsViewModel.swift
//  ShiftManager_SwiftUI
//
//  Created by Hao Yu Yeh on 2022/7/7.
//
import CoreData
import Combine


class SettingsViewModel: ObservableObject {
    @Published var stores: [Store] = []
    
    var currentStore: Store? = nil
    @Published var currentJobs: [Job] = []
    @Published var currentShifts: [Shift] = []
    
    let persistenceController = PersistenceController.shared
    var managedObjectContext = PersistenceController.shared.container.viewContext
    
    
    init() {
        updateStoreLists()
        if !stores.isEmpty {
            updateCurrentStore(index: 0)
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
           } catch let error as NSError {
               print("Fetch error: \(error) description: \(error.userInfo)")
           }
    }
    ///***********************************************************
    ///
    ///
    ///
    ///************************************************************
    func updateCurrentStore(index: Int) {
        self.currentStore = stores[index]
        currentJobs = currentStore?.jobs?.allObjects as! [Job]
        currentShifts = currentStore?.shifts?.allObjects as! [Shift]
    }
    
    func addStore(storeName: String) {
        let store = Store(context: managedObjectContext)
        store.uuid = UUID()
        store.name = storeName
        persistenceController.save()
        stores.append(store)
    }
    
    func addShift(info: String) {
        let shiftInfos = info.split(separator: ",")
        let shift = Shift(context: managedObjectContext)
        shift.uuid = UUID()
        shift.belongTo = currentStore
        shift.name = String(shiftInfos[0])
        shift.start = TimeFormatter.shared.dateFormatter.date(from: String(shiftInfos[1]))
        shift.end = TimeFormatter.shared.dateFormatter.date(from: String(shiftInfos[2]))
        persistenceController.save()
        currentShifts.append(shift)
    }
    
    func addJob(jobName: String) {
        let job = Job(context: managedObjectContext)
        job.uuid = UUID()
        job.name = jobName
        job.belongTo = currentStore
        persistenceController.save()
        currentJobs.append(job)
    }
    
    func clear() {
       
    }
    ///***********************************************************
    ///
    /// checking if currently managing certain store
    ///
    ///************************************************************
    func hasStore() -> Bool {
        if currentStore == nil {
            return false
        }else {
            return true
        }
    }
    
    func getAllStores() -> [String] {
        var storesName :[String] = []
        if !stores.isEmpty {
            for store in stores {
                storesName.append(store.name!)
            }
        }
        return storesName
    }
    ///***********************************************************
    ///
    /// retrieve all jobs possessed by current store
    ///
    ///************************************************************
    func getAllJobs() -> [String] {
        var rJobs: [String] = []
        if !currentJobs.isEmpty {
            for job in currentJobs {
                rJobs.append(job.name!)
            }
        }
        return rJobs
    }
    ///***********************************************************
    ///
    /// retrieve all shifts possessed by current store
    ///
    ///************************************************************
    func getAllShifts() -> [(Int, String, String)] {
        var rShifts: [(Int, String, String)] = []
        
        var index = 0
        var timeSpan = ""
        var name = ""
        
        if !currentShifts.isEmpty {
            for shift in currentShifts {
                name = shift.name ?? ""
                timeSpan = TimeFormatter.shared.getTimeString(date: shift.start!, timeStyle: .short) + " ~ " + TimeFormatter.shared.getTimeString(date: shift.end!, timeStyle: .short)
                
                rShifts.append((index, name, timeSpan))
                index += 1
            }
        }
        return rShifts
    }
}
