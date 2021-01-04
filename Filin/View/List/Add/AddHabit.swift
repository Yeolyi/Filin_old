//
//  AddHabit.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct AddHabit: View {
    
    @State var currentPage = 1
    let totalPage = 5
    
    @State var habitName = ""
    @State var dayOfTheWeek = [1, 2, 3, 4, 5, 6, 7]
    @State var number = 10
    @State var selectedColor = "#a5a5a5"
    @State var minute = 1
    @State var second = 30
    @State var isRequiredSecond = false
    
    @State var oneTapUnit = 1
    
    var isNextAvailable: Bool {
        #if DEBUG
        return true
        #endif
        switch currentPage {
        case 1:
            return habitName != ""
        case 2: return !dayOfTheWeek.isEmpty
        case 3: return number > 0
        case 4: return !isRequiredSecond || (isRequiredSecond && dateToSecond > 0)
        case 5: return true
        default:
            assertionFailure()
            return true
        }
    }
    
    var dateToSecond: Int {
        minute * 60 + second
    }
    
    var body: some View {
        VStack {
            if currentPage == 1 {
                NameSection(name: $habitName)
            }
            if currentPage == 2 {
                DateSection(dayOfTheWeek: $dayOfTheWeek)
            }
            if currentPage == 3 {
                TimesSection(number: $number, oneTapUnit: $oneTapUnit)
            }
            if currentPage == 4 {
                TimerSection(minute: $minute, second: $second, isRequiredTime: $isRequiredSecond)
            }
            if currentPage == 5 {
                ThemeSection(color: $selectedColor)
            }
            HStack {
                previousButton
                Spacer()
            }
            nextButton
        }
        .padding(.bottom, 20)
    }
    var previousButton: some View {
        BasicTextButton("Previous".localized) {
            self.currentPage = max(self.currentPage - 1, 1)
        }
        .padding(.leading, 20)
        .padding(.bottom, 5)
        .if(currentPage == 1) {
            $0.hidden()
        }
    }
    var nextButton: some View {
        MainRectButton(
            action: {
                if isNextAvailable == false { return }
                if currentPage == totalPage {
                    saveAndQuit()
                    return
                }
                self.currentPage += 1
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            },
            str: currentPage == totalPage ? "Done".localized: "\("Next".localized) (\(currentPage)/\(totalPage))"
        )
        .opacity(isNextAvailable ? 1.0 : 0.5)
    }
    func saveAndQuit() {
        let id = UUID()
        Habit.saveHabit(
            id: id, name: habitName, color: selectedColor, dayOfWeek: dayOfTheWeek,
            numberOfTimes: number, requiredSecond: isRequiredSecond ? dateToSecond : 0, managedObjectContext
        )
        displayManager.habitOrder.append(id)
        if oneTapUnit != 1 {
            incrementPerTap.addUnit[id] = oneTapUnit
        }
        self.presentationMode.wrappedValue.dismiss()
    }
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var displayManager: DisplayManager
    @EnvironmentObject var incrementPerTap: IncrementPerTap
    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: []
    )
    var habitInfos: FetchedResults<Habit>
    
}

struct AddHabit_Previews: PreviewProvider {
    static var previews: some View {
        let coreDataPreview = CoreDataPreview()
        return AddHabit()
            .environment(\.managedObjectContext, coreDataPreview.context)
            .environmentObject(coreDataPreview.displayManager)
            .environmentObject(AppSetting())
    }
}
