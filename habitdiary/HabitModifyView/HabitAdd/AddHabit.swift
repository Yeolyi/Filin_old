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
    @State var habitExplain = ""
    @State var habitType = HabitType.daily
    @State var dayOfTheWeek: [Int] = []
    @State var number = 1
    @State var selectedColor = Color.black
    
    var isNextAvailable: Bool {
        switch(currentPage) {
        case 1:
            return habitName != ""
        case 2:
            return habitType == .daily ? true : !dayOfTheWeek.isEmpty
        case 3:
            return number > 0
        case 4:
            return true
        default:
            return true
        }
    }
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Test1(color: $selectedColor, name: $habitName, habitExplain: $habitExplain)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                Test2(habitType: $habitType, dayOfTheWeek: $dayOfTheWeek, color: selectedColor)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                Test3(number: $number, color: selectedColor)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                Test4(color: $selectedColor)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }
            .offset(x: offSet)
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        withAnimation {
                            guard currentPage - 1 >= 1 else {
                                return
                            }
                            self.currentPage -= 1
                        }
                    }) {
                        Text("이전")
                            .fixedSize()
                            .padding(5)
                            .padding([.leading, .trailing], 10)
                    }
                    .rowBackground()
                    .if(currentPage == 1) {
                        $0.hidden()
                    }
                    LinearProgressBar(color: .gray, progress: Double(currentPage)/Double(pageNum))
                        .frame(width: UIScreen.main.bounds.width * 0.4)
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
                        Text(currentPage == pageNum ? "완료": "다음")
                            .fixedSize()
                            .padding(5)
                            .padding([.leading, .trailing], 10)
                    }
                    .opacity(isNextAvailable ? 1.0 : 0.3)
                    .rowBackground()
                }
                .padding(.bottom, 40)
            }
        }
    }
    
    func saveAndQuit() {
        let newHabit = HabitInfo(context: managedObjectContext)
        let id = UUID()
        newHabit.name = habitName
        newHabit.explanation = habitExplain == "" ? nil : habitExplain
        newHabit.color = selectedColor.string
        newHabit.habitType = habitType.rawValue
        newHabit.dayOfWeek = dayOfTheWeek.map({Int16($0)})
        newHabit.userOrder = Int16(habitInfos.count)
        newHabit.id = id
        newHabit.times = Int16(number)
        newHabit.achieve = [:]
        CoreDataManager.save(managedObjectContext)
        listOrderManager.habitOrder.append(id)
        self.presentationMode.wrappedValue.dismiss()
    }
    
}

struct AddHabit_Previews: PreviewProvider {
    static var previews: some View {
        AddHabit()
    }
}
