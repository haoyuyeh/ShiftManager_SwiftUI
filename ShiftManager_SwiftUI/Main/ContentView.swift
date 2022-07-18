//
//  ContentView.swift
//  ShiftManager_SwiftUI
//
//  Created by Hao Yu Yeh on 2022/6/30.
//

import SwiftUI

struct ContentView: View {
    @State private var tabSelection = 0
    
    var body: some View {
        TabView(selection: $tabSelection){
            SettingsView(tabSelection: $tabSelection)
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .tag(0)
            ProfileView(tabSelection: $tabSelection)
                .tabItem {
                    Image(systemName: "person")
                    Text("Staffs")
                }
                .tag(1)
            ShiftManageView(tabSelection: $tabSelection)
                .tabItem {
                    Image(systemName: "wrench")
                    Text("Shift")
                }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
