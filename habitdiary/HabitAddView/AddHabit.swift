//
//  AddHabit.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct AddHabit: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: HabitInfo.entity(),
        sortDescriptors: []
    )
    var habitInfos: FetchedResults<HabitInfo>
    let targetHabit: HabitInfo?
    var isEdit: Bool {
        targetHabit != nil
    }
    @State var habitName = ""
    @State var habitExplain = ""
    @State var habitType = HabitType.daily
    @State var dayOfTheWeek: [Int] = []
    @State var number = 0
    @State var selectedColor = Color.black
    
    init(targetHabit: HabitInfo? = nil) {
        self.targetHabit = targetHabit
        if let targetHabit = targetHabit {
            self._habitName = State(initialValue: targetHabit.name)
            self._habitExplain = State(initialValue: targetHabit.explanation ?? "")
            self._habitType = State(initialValue: HabitType(rawValue: targetHabit.habitType) ?? .daily)
            self._dayOfTheWeek = State(initialValue: targetHabit.dayOfWeek?.map{Int($0)} ?? [])
            self._number = State(initialValue: Int(targetHabit.times))
            self._selectedColor = State(initialValue: Color(str: targetHabit.color))
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("이름").font(.headline).padding(.top, 30)) {
                    TextField("물 다섯잔 마시기", text: $habitName)
                }
                Section(header: Text("설명").font(.headline)) {
                    TextField("하루에 2L씩 꼬박꼬박", text: $habitExplain)
                    ColorHorizontalPicker(selectedColor: $selectedColor)
                }
                Section(header:Text("종류").font(.headline)) {
                    Picker("Map type", selection: $habitType) {
                        Text("매일").tag(HabitType.daily)
                        Text("매주").tag(HabitType.weekly)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header:Text("설정").font(.headline)) {
                    if habitType == .weekly {
                        NavigationLink(destination: RepeatDaySelect(dayOfTheWeek: $dayOfTheWeek)) {
                            HStack {
                                Text("반복")
                                Spacer()
                                HStack {
                                    ForEach(dayOfTheWeek, id: \.self) { dayOfTheWeekInt in
                                        Text(Date.dayOfTheWeekStr(dayOfTheWeekInt))
                                    }
                                }
                            }
                        }
                    }
                    HStack {
                        Stepper(value: $number, in: 1...20) {
                            Text("\(number)회")
                        }
                    }
                }
                if isEdit {
                    Button(action: {
                        managedObjectContext.delete(targetHabit!)
                        CoreDataManager.save(managedObjectContext)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("삭제")
                    }
                }
            }
            .insetGroupedListStyle()
            .navigationBarTitle(Text("습관 추가"), displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("취소")
                    }
                ,trailing: saveButton
            )
        }
    }
    
    var saveButton: some View {
        Button(action: {
            if let targetHabit = targetHabit {
                targetHabit.name = habitName
                targetHabit.explanation = habitExplain == "" ? nil : habitExplain
                targetHabit.color = selectedColor.string
                targetHabit.habitType = habitType.rawValue
                targetHabit.dayOfWeek = dayOfTheWeek.map({Int16($0)})
                targetHabit.times = Int16(number)
            } else {
                let newHabit = HabitInfo(context: managedObjectContext)
                newHabit.name = habitName
                newHabit.explanation = habitExplain == "" ? nil : habitExplain
                newHabit.color = selectedColor.string
                newHabit.habitType = habitType.rawValue
                newHabit.dayOfWeek = dayOfTheWeek.map({Int16($0)})
                newHabit.userOrder = Int16(habitInfos.count)
                newHabit.id = UUID()
                newHabit.times = Int16(number)
                newHabit.achieve = [:]
            }
            CoreDataManager.save(managedObjectContext)
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("저장")
        }
    }
}

struct AddHabit_Previews: PreviewProvider {
    static var previews: some View {
        AddHabit()
    }
}
