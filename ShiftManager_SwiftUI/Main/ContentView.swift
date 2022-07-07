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
            ShiftManageView()
                .tabItem {
                    Image(systemName: "wrench")
                    Text("Shift")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Staffs")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
