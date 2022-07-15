//
//  ShiftManager_SwiftUIApp.swift
//  ShiftManager_SwiftUI
//
//  Created by Hao Yu Yeh on 2022/6/30.
//

import SwiftUI

@main
struct ShiftManager_SwiftUIApp: App {
    let persistenceController = PersistenceController.shared
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .background:
                persistenceController.save()
            case .inactive:
                print("")
            case .active:
                print("")
            @unknown default:
                print("")
            }
            
        }
    }
}
