//
//  SettingsViewModel.swift
//  ShiftManager_SwiftUI
//
//  Created by Hao Yu Yeh on 2022/7/7.
//
import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    @Published var currentStore: Store? = nil
    let persistenceController = PersistenceController.shared
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: Store.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Store.name, ascending:   true)]) var stores: FetchedResults<Store>
    
    func setCurrentStore(index: Int) {
        self.currentStore = stores[index]
        print(currentStore?.name ?? "nil")
    }
    
    func addStore(storeName: String) {
        let store = Store(context: managedObjectContext)
        store.uuid = UUID()
        store.name = storeName
        persistenceController.save()
    }
    
    func addShift() {
        
    }
    
    func addJob() {
        
    }
    
    func clear(entity: TargetEntity) {
        switch entity {
        case .store:
            for store in stores {
                persistenceController.delete(store)
                persistenceController.save()
            }
        case .job:
            print("")
        case .shift:
            print("")
        }
    }
    
    func hasStore() -> Bool {
        return false
    }
    
    func getAllStores() -> [String] {
        var storesName :[String] = []
        for store in stores {
            storesName.append(store.name!)
        }
        return storesName
    }
    
    func getAllJobs() -> [String] {
        let jobs :[String] = ["roll1","roll1","roll1","roll1","roll1",
                              "roll1","roll1","roll1","roll1","roll1",
                              "roll1","roll1","roll1","roll1","roll1",
                              "roll1","roll1","roll1","roll1","roll1"]
        return jobs
    }
    
    func getAllShifts() -> [(Int, String, String)] {
        let shifts = [(1, "open", "7am~5pm"),(2, "close", "8am~8pm"),(3, "general", "8am~5pm")]
        return shifts
    }
}
