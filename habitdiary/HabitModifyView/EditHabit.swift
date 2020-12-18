//
//  AddHabit.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct EditHabit: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var listOrderManager: ListOrderManager
    let targetHabit: HabitInfo
    @State var habitName = ""
    @State var habitType = HabitType.daily
    @State var dayOfTheWeek: [Int] = []
    @State var number = ""
    @State var selectedColor = ""
    @State var isDeleteAlert = false
    
    init(targetHabit: HabitInfo) {
        self.targetHabit = targetHabit
        self._habitName = State(initialValue: targetHabit.name)
        self._habitType = State(initialValue: HabitType(rawValue: targetHabit.habitType) ?? .daily)
        self._dayOfTheWeek = State(initialValue: targetHabit.targetDays?.map{Int($0)} ?? [])
        self._number = State(initialValue: String(targetHabit.targetAmount))
        self._selectedColor = State(initialValue: targetHabit.color)
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("\(targetHabit.name) 수정")
                    .sectionText()
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("취소")
                        .padding(.trailing, 20)
                        .foregroundColor(ThemeColor.mainColor)
                }
                Button(action: {
                    guard habitName != "", !(habitType == .weekly && dayOfTheWeek.isEmpty), Int(number) ?? 0 > 0 else {
                        return
                    }
                    dayOfTheWeek = dayOfTheWeek.sorted(by: <)
                    targetHabit.name = habitName
                    targetHabit.color = selectedColor
                    targetHabit.habitType = habitType.rawValue
                    targetHabit.targetDays = dayOfTheWeek.map({Int16($0)})
                    targetHabit.targetAmount = Int16(number) ?? 0
                    if let index = listOrderManager.habitOrder.firstIndex(where: {$0.id == targetHabit.id}) {
                        listOrderManager.habitOrder[index].dayOfWeek = habitType == .daily ? nil : dayOfTheWeek
                    }
                    CoreDataManager.save(managedObjectContext)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("저장")
                        .padding(.trailing, 20)
                        .foregroundColor(ThemeColor.mainColor)
                }
                .opacity(
                    (habitName != "" && !(habitType == .weekly && dayOfTheWeek.isEmpty) && Int(number) ?? 0 > 0) ? 1.0 : 0.5
                )
            }
            .padding(.top, 20)
            Divider()
            ScrollView {
                Group {
                    Text("이름")
                        .sectionText()
                    TextField("물 다섯잔 마시기", text: $habitName)
                        .rowBackground()
                        .padding([.leading, .trailing], 10)
                    Text("주기")
                        .sectionText()
                    Picker("Map type", selection: $habitType) {
                        Text("매일").tag(HabitType.daily)
                        Text("매주").tag(HabitType.weekly)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding([.leading, .trailing], 30)
                    if habitType == .weekly {
                        HStack {
                            ForEach(1..<8) { dayOfTheWeekInt in
                                Button(action: {
                                    if dayOfTheWeek.contains(dayOfTheWeekInt) {
                                        dayOfTheWeek.remove(at: dayOfTheWeek.firstIndex(of: dayOfTheWeekInt)!)
                                    } else {
                                        dayOfTheWeek.append(dayOfTheWeekInt)
                                    }
                                }) {
                                    CircleProgress(progress: 0, color: Color(hex: selectedColor), num: Date.dayOfTheWeekStr(dayOfTheWeekInt), isUnderBar: false, highlighted: false, activated: dayOfTheWeek.contains(dayOfTheWeekInt))
                                        .frame(width: 40, height: 40)
                                        .zIndex(0)
                                }
                            }
                        }
                    }
                }
                Text("횟수")
                    .sectionText()
                HStack {
                    TextField("15회", text: $number)
                        .keyboardType(.numberPad)
                    Button(action: {
                        UIApplication.shared.endEditing()
                    }) {
                        Text("완료")
                            .foregroundColor(ThemeColor.mainColor)
                    }
                }
                .rowBackground()
                Text("테마색")
                    .sectionText()
                ColorHorizontalPicker(selectedColor: $selectedColor)
                Button(action: {
                    self.isDeleteAlert = true
                }) {
                    HStack {
                        Spacer()
                        Text("삭제")
                            .foregroundColor(.red)
                        Spacer()
                    }
                    .rowBackground()
                    .padding(.top, 30)
                    .padding(.bottom, 30)
                }
                .alert(isPresented: $isDeleteAlert) {
                    Alert(
                        title: Text("\(targetHabit.name)을 삭제하시겠습니까?"),
                        message: nil,
                        primaryButton: .default(Text("취소")),
                        secondaryButton: .destructive(Text("삭제"), action: {
                            if let index = listOrderManager.habitOrder.firstIndex(where: {$0.id == targetHabit.id}) {
                                listOrderManager.habitOrder.remove(at: index)
                            }
                            managedObjectContext.delete(targetHabit)
                            CoreDataManager.save(managedObjectContext)
                            presentationMode.wrappedValue.dismiss()
                        }))
                }
            }
        }
    }
}


struct EditHabit_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        EditHabit(targetHabit: HabitInfo(context: context))
            .environment(\.managedObjectContext, context)
            .environmentObject(SharedViewData())
    }
}

