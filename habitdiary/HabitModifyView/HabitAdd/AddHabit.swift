//
//  AddHabit.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct AddHabit: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var listOrderManager: ListOrderManager
    @EnvironmentObject var sharedViewData: SharedViewData
    @FetchRequest(
        entity: HabitInfo.entity(),
        sortDescriptors: []
    )
    var habitInfos: FetchedResults<HabitInfo>
    
    @State var currentPage = 1
    let pageNum = 4
    var offSet: CGFloat {
        let canvasSize = UIScreen.main.bounds.width * CGFloat(pageNum)
        return (canvasSize-UIScreen.main.bounds.width)/2 - CGFloat(currentPage - 1) * UIScreen.main.bounds.width
    }
    @State var habitName = ""
    @State var habitType = HabitType.daily
    @State var dayOfTheWeek: [Int] = []
    @State var number = "1"
    @State var selectedColor = "#404040"
    @State var oneTouchUnit = "1"
    
    var isNextAvailable: Bool {
        switch(currentPage) {
        case 1:
            return habitName != ""
        case 2:
            return habitType == .daily ? true : !dayOfTheWeek.isEmpty
        case 3:
            return Int(number) ?? 0 > 0
        case 4:
            return true
        default:
            return true
        }
    }
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Test1(color: Color(hex: selectedColor), name: $habitName)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                Test2(habitType: $habitType, dayOfTheWeek: $dayOfTheWeek, color: Color(hex: selectedColor))
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                Test3(number: $number, oneTouchUnit: $oneTouchUnit, color: Color(hex: selectedColor))
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                Test4(color: $selectedColor)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }
            .offset(x: offSet)
            VStack {
                Spacer()
                    Button(action: {
                        withAnimation {
                            guard currentPage - 1 >= 1 else {
                                return
                            }
                            self.currentPage -= 1
                        }
                    }) {
                        Text("이전으로")
                            .fixedSize()
                            .foregroundColor(ThemeColor.mainColor)
                            .padding([.leading, .trailing], 10)
                            .padding(.bottom, 3)
                    }
                    .if(currentPage == 1) {
                        $0.hidden()
                    }
                    .offset(x: -UIScreen.main.bounds.width/2 + 70)
                Button(action: {
                    if isNextAvailable == false {
                        return
                    }
                    if currentPage == pageNum {
                        saveAndQuit()
                    }
                    withAnimation {
                        guard currentPage + 1 <= pageNum else {
                            return
                        }
                        self.currentPage += 1
                    }
                }) {
                    HStack {
                        Spacer()
                        Text(currentPage == pageNum ? "완료": "다음 (\(currentPage)/\(pageNum))")
                            .font(.system(size: 18, weight: .medium))
                            .fixedSize()
                            .foregroundColor(.white)
                            .padding([.top, .bottom], 15)
                        Spacer()
                    }
                    .background(
                        ThemeColor.mainColor
                    )
                }
                .frame(width: UIScreen.main.bounds.width - 60)
                .opacity(isNextAvailable ? 1.0 : 0.3)
                
            }
            .padding(.bottom, 40)
        }
    }
    
    func saveAndQuit() {
        dayOfTheWeek = dayOfTheWeek.sorted(by: <)
        let newHabit = HabitInfo(context: managedObjectContext)
        let id = UUID()
        newHabit.name = habitName
        newHabit.color = selectedColor
        newHabit.habitType = habitType.rawValue
        newHabit.targetDays = dayOfTheWeek.map({Int16($0)})
        newHabit.id = id
        newHabit.targetAmount = Int16(number) ?? 1
        newHabit.achieve = [:]
        newHabit.requiredSecond = 0
        CoreDataManager.save(managedObjectContext)
        listOrderManager.habitOrder.append(OrderInfo(id: id, dayOfWeek: dayOfTheWeek == [] ? nil : dayOfTheWeek))
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct AddHabit_Previews: PreviewProvider {
    static var previews: some View {
        AddHabit()
    }
}
