//
//  MainBottomBar.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct MainBottomBar: View {
    
    @Binding var showAddModal: Bool
    @Binding var editMode: Bool
    @EnvironmentObject var sharedViewData: SharedViewData
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                emptyButton
                Spacer()
                emptyButton
                Spacer()
                if sharedViewData.inMainView {
                    emptyButton
                } else {
                    shareButton
                }
                Spacer()
                if sharedViewData.inMainView {
                    habitPlusButton
                } else {
                    calendarViewModeButton
                }
            }
            .frame(height: 50)
            .background(
                Blur(style: .systemMaterial)
                    .edgesIgnoringSafeArea(.bottom)
            )
            .animation(.linear(duration: 0.3))
        }
    }
    
    var emptyButton: some View {
        Text("")
            .font(.system(size: 25, weight: .light))
            .padding(.leading, 15)
    }
    var shareButton: some View {
        Button(action: {}) {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 25, weight: .light))
        }
    }
    var calendarViewModeButton: some View {
        Button(action: {
            withAnimation {
                sharedViewData.isCalendarMode.toggle()
            }
        }) {
            Image(systemName: sharedViewData.isCalendarMode ? "calendar.circle.fill" : "calendar.circle")
                .font(.system(size: 25, weight: .light))
                .padding(.trailing, 15)
        }
    }
    var habitPlusButton: some View {
        Button(action: {
            self.showAddModal = true
        }) {
            Image(systemName: "plus")
                .font(.system(size: 25, weight: .light))
                .padding(.trailing, 15)
        }
    }
}

struct MainBottomBar_Previews: PreviewProvider {
    static var previews: some View {
        MainBottomBar(showAddModal: .constant(false), editMode: .constant(false))
            .environmentObject(SharedViewData())
            .previewDevice(.init(stringLiteral: "iPhone 12 mini"))
    }
}
