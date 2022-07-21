//
//  ProfileView.swift
//  ShiftManager_SwiftUI
//
//  Created by Hao Yu Yeh on 2022/6/30.
//

import SwiftUI

struct ProfileView: View {
    @Binding var tabSelection: Int
    @StateObject  var profileViewModel = ProfileViewModel()
    @State private var storeSelection = 0

    var body: some View {
        switch profileViewModel.profileViewState {
        case .noStore:
            Text("Adding a store first!!!")
                .font(.largeTitle)
                .foregroundColor(.red)
            /************************
             when you change the currentStore to a store without staffs under showing the StaffView, the swiftui will update all the alive view related to the currentStore.
             in this case, the current alive view would be StaffCardView. when swiftui update alive views, the app will crash due to trying to show the staff which is nil.
             therefore, it has to be taken care of the getStaff function in ProfileViewModel and the StaffCardView in Profile View(need to take no staff into consideration).
             the thorough explanation can be found on the webpage below.
             因為根據有沒有員工來顯示不同的view，因此當從有員工的店轉換到沒有員工的店時，因為currentStore改變了所以view需要更新，
             但是目前StaffView還是alive所以會先更新它。因此在StaffCardView的時候要先處理沒有員工的時候需要顯示的畫面。
             詳細原因可以參考下列網頁
             https://www.hackingwithswift.com/forums/swiftui/child-view-seems-to-update-before-parent-view-can-anybody-explain-why/9259
             **/
        case .noStaff:
            VStack{
                HeaderView(profileViewModel: profileViewModel, storeSelection: $storeSelection)
                Spacer()
                Text("Adding a staff first!!!")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                Spacer()
            }
            
        case .greenLight:
            VStack{
                HeaderView(profileViewModel: profileViewModel, storeSelection: $storeSelection)
                StaffsView(profileViewModel: profileViewModel)
            }
        }
    }
}

struct HeaderView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @Binding  var storeSelection: Int
    @State private var showingAlert = false
    var body: some View {
        HStack{
            Picker(selection: $storeSelection, label: Text("Store")) {
                ForEach(0..<profileViewModel.getAllStores().count, id:\.self) {
                    Text(profileViewModel.getAllStores()[$0])
                }
            }
            .pickerStyle(.menu)
            .onChange(of: storeSelection) { newValue in
                profileViewModel.updateCurrentStore(index: storeSelection)
            }
            .padding(.leading, 10)
            Spacer()
            Text("Profile")
                .bold()
                .font(.largeTitle)
            Spacer()
            Button(action: {
                // input staff name and the store he belongs to
                showingAlert.toggle()
            }){
                Image(systemName: "person.fill.badge.plus")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .aspectRatio(contentMode: .fill)
            }
            .padding([.top, .bottom, .trailing], 10)
            .fullScreenCover(isPresented: $showingAlert) {
            } content: {
                OneInputAlertView(showingAlert: $showingAlert, alertTitle: "Adding...", placeHolder: "Staff's name", action: profileViewModel.addStaff)
            }
            
        }
    }
}

struct StaffsView: View {
    @ObservedObject var profileViewModel: ProfileViewModel

    @State private var currentStaff = 0
    
    var body: some View {
        VStack{
            GeometryReader{g in
                ZStack{
                    StaffCardView(profileViewModel: profileViewModel, staff: nil, bgColor: .black)
                        .position(x: g.size.width*0.6, y: g.size.height*0.7)
                        .offset(x: 40, y: -60)
                    
                    StaffCardView(profileViewModel: profileViewModel, staff: nil, bgColor: .gray)
                        .position(x: g.size.width*0.6, y: g.size.height*0.7)
                        .offset(x: 20, y: -30)
                    
                    StaffCardView(profileViewModel: profileViewModel, staff: profileViewModel.getStaff(index: currentStaff), bgColor: .red)
                        .position(x: g.size.width*0.6, y: g.size.height*0.7)
                        .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local).onEnded({ value in
                            switch GestureDirection.shared.getDragDirection(translation: value.translation) {
                                
                            case Direction.left:
                                currentStaff += 1
                            case Direction.right:
                                currentStaff -= 1
                            case Direction.up, Direction.down:
                                profileViewModel.deleteStaff(index: currentStaff)
                            default:
                                print("")
                            }
                        }))
                }
            }
        }
    }
}


struct StaffCardView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var staff: Staff?
    var bgColor: Color
    @State var weekHourLimits: String = ""
    @State var isSkillEditBtnPressed: Bool = false
    
    var body: some View {
        
        GeometryReader{ geometry in
            if let staff = staff {
                VStack(alignment: .leading, spacing: 1) {
                    HStack{
                        Spacer()
                        Text(staff.name!)
                            .bold()
                            .font(.largeTitle)
                            .padding([.top, .bottom], 20)
                        Spacer()
                    }
                    
                    HStack {
                        Text("Weekly Hour Limits:")
                            .font(.body)
                            .padding(.leading, 5)
                        TextField("", text: $weekHourLimits)
                            .onAppear(perform: {
                                weekHourLimits = String(staff.weeklyWorkHourLimits)
                            })
                            .padding(.leading, 5)
                            .border(.black)
                            .onChange(of: weekHourLimits) { newValue in
                                // numbers only
                                if newValue.range(of: "^[0-9]+$", options: .regularExpression) == nil {
                                    weekHourLimits = ""
                                }else {
                                    profileViewModel.setWeeklyWorkingHourLimits(staff: staff, info: weekHourLimits)
                                }
                            }
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    
                    
                    VStack{
                        HStack{
                            Text("Skills")
                            Button {
                                isSkillEditBtnPressed.toggle()
                                
                            } label: {
                                Image(systemName: isSkillEditBtnPressed ? "square.and.arrow.down.on.square" : "pencil" )
                            }

                        }
                        MultipleSelectionView(options: profileViewModel.getSkillsList(staff: staff), editable: $isSkillEditBtnPressed)
                            .frame(height: 50)
                    }
                    .padding()
                    
                    LabelBtnView(label: "Day Off", plusBtnDisabled: false, hasClear: false, textFieldPlaceHolder: "day off", alertType: .inputTextAndTimeSpan, action: profileViewModel.addDayOff)
                    let dayOffs = [(1,"20/6", nil),(2,"23/6", "12pm~12pm")]
                    
                    dayOffView(dayOffs: dayOffs)
                }
                .frame(maxWidth: geometry.size.width*0.7, maxHeight: geometry.size.height*0.6, alignment: .topLeading)
                .background(bgColor)
                .cornerRadius(20)
            }else {
                Text("")
                    .frame(maxWidth: geometry.size.width*0.7, maxHeight: geometry.size.height*0.6, alignment: .topLeading)
                    .background(bgColor)
                    .cornerRadius(20)
            }
        }
        
    }
}

struct MultipleSelectionView: View {
    @State var options: [(UUID, SkillType, String, Bool)]
    @Binding var editable: Bool
    
    private let adaptiveRows = [
        GridItem(.adaptive(minimum: 20))
    ]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: adaptiveRows, spacing: 10) {
                
                ForEach($options, id: \(UUID, SkillType, String, Bool).0) { $option in
                    Button {
                        option.3 = !option.3
                    } label: {
                        HStack{
                            Image(systemName: option.3 ? "checkmark.square" : "square")
                            Text(option.2)
                        }
                    }
                    .disabled(!editable)
                    .padding()
                }
            }
        }
    }
}

struct dayOffView: View {
    var dayOffs: [(id: Int, date: String, time: String?)]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 1) {
                ForEach(dayOffs, id: \.id) {dayOff in
                    VStack{
                        Text(dayOff.date)
                        if let time = dayOff.time {
                            Text(time)
                        }
                    }
                    .frame(width: 100, height: 40)
                    .padding()
                    .border(.black)
                    //                    Divider()
                }
                Spacer()
            }
        }
    }
}
//
//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        multipleSelectionView(options: ["roll", "roll1", "box1","roll2", "box2", "nigiri"]).frame(width: .infinity, height: 50)
//    }
//}
