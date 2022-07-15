//
//  ContentView.swift
//  ShiftManager_SwiftUI
//
//  Created by Hao Yu Yeh on 2022/6/30.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView(){
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Staffs")
                }
            ShiftManageView()
                .tabItem {
                    Image(systemName: "wrench")
                    Text("Shift")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
