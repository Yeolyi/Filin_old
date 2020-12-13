//
//  MainBottomBar.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct BottomBar: View {
    
    @EnvironmentObject var sharedViewData: SharedViewData
    @Binding var activeSheet: ActiveSheet?
    @Binding var isCalendarExpanded: Bool
    @Binding var isDiaryExpanded: Bool
    let habit: HabitInfo
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                shareButton
                    .hidden()
                    .padding(.leading, 15)
                Spacer()
                calendarViewModeButton
                Spacer()
                diaryViewModeButton
                Spacer()
                diaryWriteButton
                    .padding(.trailing, 15)
            }
            .frame(height: 50)
            .background(
                Blur(style: .systemMaterial)
                    .edgesIgnoringSafeArea(.bottom)
            )
            .animation(.linear(duration: 0.3))
        }
    }
    
    var diaryViewModeButton: some View {
        Button(action: {
            withAnimation {
                isDiaryExpanded.toggle()
            }
        }) {
            Image(systemName: "note.text")
                .font(.system(size: 25, weight: .light))
                .frame(width: 30, height: 30)
                .opacity(isDiaryExpanded ? 1.0 : 0.2)
        }
    }
    var shareButton: some View {
        Button(action: {}) {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 25, weight: .light))
                .frame(width: 30, height: 30)
        }
    }
    var calendarViewModeButton: some View {
        Button(action: {
            withAnimation {
                isCalendarExpanded.toggle()
            }
        }) {
            Image(systemName: "calendar")
                .font(.system(size: 25, weight: .light))
                .frame(width: 30, height: 30)
                .opacity(isCalendarExpanded ? 1.0 : 0.2)
        }
    }
    var diaryWriteButton: some View {
        Button(action: {activeSheet = ActiveSheet.diary}) {
            Image(systemName: "square.and.pencil")
                .font(.system(size: 25, weight: .light))
                .frame(width: 30, height: 30)
        }
    }
    
}

/*
struct MainBottomBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomBar()
            .environmentObject(SharedViewData())
            .previewDevice(.init(stringLiteral: "iPhone 12 mini"))
    }
}
*/
