//
//  ProfileViewModel.swift
//  ShiftManager_SwiftUI
//
//  Created by Hao Yu Yeh on 2022/7/7.
//
import CoreData
import Combine



class ProfileViewModel: ObservableObject {
    @Published var profileViewState: ProfileViewState = .noStore
    private var currentStore: Store? = nil
    
    let persistenceController = PersistenceController.shared
    var managedObjectContext = PersistenceController.shared.container.viewContext
    
    private var stores: [Store] = []
    private var storesName: [String] = []
    private var staffs: [Staff] = []
    private var jobs: [Job] = []
    private var shifts: [Shift] = []
    
    init() {
        updateStoreLists()
        if !stores.isEmpty {
            updateCurrentStore(index: 0)
        }
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
                storesName = []
                for store in stores {
                    storesName.append(store.name!)
                }
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    func updateCurrentStore(index: Int) {
        currentStore = stores[index]
        staffs = currentStore?.employees?.allObjects as! [Staff]
        for staff in staffs {
            print("\(String(describing: currentStore?.name))" + "-" + "\(String(describing: staff.name))")
        }
        jobs = currentStore?.jobs?.allObjects as! [Job]
        shifts = currentStore?.shifts?.allObjects as! [Shift]
        checkProfileViewState()
    }
    
    func getAllStores() -> [String] {
        return storesName
    }
    
    func getStaff(index: Int) -> Staff? {
        if let index = getCorrectStaffBoundary(index: index) {
            return staffs[index]
        }else {
            return nil
        }
    }
    
    func deleteStaff(index: Int) {
        if let index = getCorrectStaffBoundary(index: index) {
            persistenceController.delete(staffs[index])
            persistenceController.save()
            staffs.remove(at: index)
            checkProfileViewState()
        }
    }
    
    func getCorrectStaffBoundary(index: Int) -> Int? {
        if staffs.count == 0 {
            return nil
        }else {
            return abs(index % staffs.count)

        }
    }
    
    func addStaff(info: String) {
        let staff = Staff(context: persistenceController.container.viewContext)
        staff.uuid = UUID()
        staff.name = info
        staff.employedBy = currentStore
        staffs = currentStore?.employees?.allObjects as! [Staff]
        persistenceController.save()
        checkProfileViewState()
    }
    
    func getSkillsList(staff: Staff) -> [(UUID,SkillType, String, Bool)] {
        var skillsList:[(id: UUID, category: SkillType, name: String,hasTicked: Bool)] = []
        let staffSkills = staff.capableOf?.allObjects as! [CapableOf]
        let staffCapableShifts = staff.availableOn?.allObjects as! [AvailableOn]
        
        if currentStore != nil {
            for job in jobs {
                
                skillsList.append((job.uuid!, .job, job.name!, staffSkills.contains { skill in
                    skill.skill?.name == job.name
                }))
            }
            for shift in shifts {
                skillsList.append((shift.uuid!, .shift, shift.name!, staffCapableShifts.contains { skill in
                    skill.shift?.name == shift.name
                }))
            }
        }
        return skillsList.sorted { return $0.name < $1.name
        }
    }
    
    func updateSkillsList(staff: UUID, skill: (UUID, SkillType, String, Bool)) {
        let currentStaff = staffs.filter { s in
            return s.uuid?.uuidString == staff.uuidString
        }
        let staffSkills = currentStaff[0].capableOf?.allObjects as! [CapableOf]
        let staffCapableShifts = currentStaff[0].availableOn?.allObjects as! [AvailableOn]
        
        switch skill.1 {
        case .job:
            let job = jobs.filter { j in
               return j.uuid?.uuidString == skill.0.uuidString
            }
            if skill.3 {
                let capableOf = CapableOf(context: managedObjectContext)
                capableOf.uuid = UUID()
                capableOf.staff = currentStaff[0]
                capableOf.skill = job[0]
                persistenceController.save()
            }else {
                let capableOf = staffSkills.filter { c in
                    c.skill?.name == job[0].name
                }
                persistenceController.delete(capableOf[0])
                persistenceController.save()
            }
        case .shift:
            let shift = shifts.filter { s in
               return s.uuid?.uuidString == skill.0.uuidString
            }
            if skill.3 {
                let availableOn = AvailableOn(context: managedObjectContext)
                availableOn.uuid = UUID()
                availableOn.staff = currentStaff[0]
                availableOn.shift = shift[0]
                persistenceController.save()
            }else {
                let availableOn = staffCapableShifts.filter { c in
                    c.shift?.name == shift[0].name
                }
                persistenceController.delete(availableOn[0])
                persistenceController.save()
            }
        }
    }
    
    func addSkill(info: String) {
        
    }
    
    func addDayOff(info: String) {
        
    }
    
    func setWeeklyWorkingHourLimits(staff: Staff, info: String) {
        staff.weeklyWorkHourLimits = Int16(info)!
        persistenceController.save()
    }
    
    func clear() {
        
    }
}
