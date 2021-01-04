//
//  Test1.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct NameSection: View {
    
    @Binding var name: String
    @State var nameExamples = [
        "Some long item", "And then some longer one",
        "Short", "Items", "Here", "And", "A", "Few", "More",
        "And then a very very very long one"
    ].shuffled()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                LottieView(filename: "lottiePlus")
                    .frame(width: 120, height: 120)
                    .padding(.bottom, 5)
                    .padding(.top, 21)
                Text(appSetting.isFirstRun && habitInfos.isEmpty ?
                        "Make first goal".localized : "Make new goal".localized)
                    .title()
                    .padding(.bottom, 89)
                HStack {
                    Text("What is the name of the goal?".localized)
                        .bodyText()
                    Spacer()
                }
                .padding(.leading, DesignValues.horizontalBorderPadding)
                TextFieldWithEndButton("Drink water".localized, text: $name)
                    .rowBackground()
                    .padding(.bottom, 15)
                FlowLayout(mode: .scrollable, items: nameExamples) { text in
                    Button(action: { name = text }) {
                    Text(text)
                        .bodyText()
                        .padding(10)
                        .background(
                            Rectangle()
                                .subColor()
                                .opacity(0.2)
                        )
                    }
                }
                .rowPadding()
            }
        }
    }
    
    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: []
    )
    var habitInfos: FetchedResults<Habit>
    @EnvironmentObject var appSetting: AppSetting
    @Environment(\.colorScheme) var colorScheme
    
}

struct Test1_Previews: PreviewProvider {
    
    struct StateWrapper: View {
        @State var selectedText = "Text"
        var body: some View {
            let coreDataPreview = CoreDataPreview()
            return NameSection(name: $selectedText)
                .environment(\.managedObjectContext, coreDataPreview.context)
                .environmentObject(AppSetting())
        }
    }
    
    static var previews: some View {
        StateWrapper()
    }
}
