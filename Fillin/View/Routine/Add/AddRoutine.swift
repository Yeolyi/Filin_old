//
//  AddRoutine.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/25.
//

import SwiftUI

struct AddRoutine: View {
    
    @State var name = ""
    @State var currentPage = 1
    @State var routineTime = Date()
    let totalPage = 3
    
    @ObservedObject var listData = ListData<UUID>(values: [], save: {_ in })
    @Environment(\.managedObjectContext) var context
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    var isNextAvailable: Bool {
        if currentPage == 1 {
            return name != ""
        } else if currentPage == 2 {
            return !listData.list.isEmpty
        } else if currentPage == 3 {
            return true
        } else {
            assertionFailure()
            return true
        }
    }
    
    var body: some View {
        VStack {
            if currentPage == 1 {
                HabitAddBadgeView(title: "Add routine".localized, imageName: "square.stack.3d.down.forward") {
                    Text("Name".localized)
                        .sectionText()
                    TextFieldWithEndButton("Morning wakeup".localized, text: $name)
                }
            }
            if currentPage == 2 {
                RoutineSetList(listData: listData)
            }
            if currentPage == 3 {
                RoutineTime(routineTime: $routineTime)
            }
            Spacer()
            HStack {
                previousButton
                Spacer()
            }
            nextButton
        }
        .padding(.bottom, 30)
    }
    var previousButton: some View {
        Button(action: {
            withAnimation { self.currentPage = max(self.currentPage - 1, 1) }
        }) {
            Text("previous".localized)
                .fixedSize()
                .mainColor()
                .padding(.leading, 10)
                .padding(.bottom, 3)
        }
        .if(currentPage == 1) {
            $0.hidden()
        }
    }
    var nextButton: some View {
        Button(action: {
            if isNextAvailable == false { return }
            if currentPage == totalPage {
                Routine.save(
                    name: name, list: listData.sortedValue,
                    reminderTimes: [routineTime.hourAndMinuteStr], context: context
                )
                presentationMode.wrappedValue.dismiss()
                return
            }
            withAnimation { self.currentPage += 1 }
        }) {
            HStack {
                Spacer()
                Text(currentPage == totalPage ? "Done".localized: "\("Next".localized) (\(currentPage)/\(totalPage))")
                    .font(.system(size: 18, weight: .medium))
                    .fixedSize()
                    .foregroundColor(.white)
                    .padding([.top, .bottom], 15)
                Spacer()
            }
            .background(ThemeColor.mainColor(colorScheme))
        }
        .padding([.leading, .trailing], 10)
        .opacity(isNextAvailable ? 1.0 : 0.3)
    }
}

struct AddRoutine_Previews: PreviewProvider {
    static var previews: some View {
        AddRoutine()
    }
}
