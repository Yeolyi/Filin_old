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
    @State var dayOfWeek: [Int] = [1, 2, 3, 4, 5, 6, 7]
    @State var isReminder = true
    let totalPage = 4
    
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
        } else if currentPage == 4 {
            return true
        } else {
            assertionFailure()
            return true
        }
    }
    var body: some View {
        VStack(spacing: 0) {
            if currentPage == 1 {
                VStack(spacing: 0) {
                    LottieView(filename: "lottieStack")
                        .frame(width: 130, height: 130)
                        .padding(.bottom, 5)
                        .padding(.top, 21)
                    Text("Add routine".localized)
                        .title()
                        .padding(.bottom, 89)
                    VStack {
                        HStack {
                            Text("Name".localized)
                                .bodyText()
                            Spacer()
                        }
                        TextFieldWithEndButton("After wake up".localized, text: $name)
                    }
                    .rowBackground()
                }
            }
            if currentPage == 2 {
                RoutineSetList(listData: listData)
            }
            if currentPage == 3 {
                RoutineDate(dayOfTheWeek: $dayOfWeek)
            }
            if currentPage == 4 {
                RoutineTime(routineTime: $routineTime, isTimer: $isReminder)
            }
            Spacer()
            HStack {
                previousButton
                Spacer()
            }
            nextButton
        }
        .padding(.bottom, 20)
    }
    var previousButton: some View {
        Button(action: {
            withAnimation { self.currentPage = max(self.currentPage - 1, 1) }
        }) {
            Text("Previous".localized)
                .bodyText()
                .fixedSize()
                .padding(.leading, 20)
                .padding(.bottom, 8)
        }
        .if(currentPage == 1) {
            $0.hidden()
        }
    }
    var nextButton: some View {
        MainRectButton(
            action: {
                if isNextAvailable == false { return }
                if currentPage == totalPage {
                    #warning("Save function Needed")
                    presentationMode.wrappedValue.dismiss()
                    return
                }
                withAnimation { self.currentPage += 1 }
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            },
            str: currentPage == totalPage ? "Done".localized: "\("Next".localized) (\(currentPage)/\(totalPage))"
        )
        .opacity(isNextAvailable ? 1.0 : 0.5)
    }
}

struct AddRoutine_Previews: PreviewProvider {
    static var previews: some View {
        AddRoutine()
    }
}
