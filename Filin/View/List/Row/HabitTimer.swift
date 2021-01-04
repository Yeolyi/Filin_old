//
//  HabitTimer.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/22.
//

import SwiftUI

struct HabitTimer: View {
    
    let seconds: Int
    let habit: Habit
    let date: Date
    
    @State private var timeRemaining = 0
    @State var isCounting = false
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(habit: Habit, date: Date) {
        self.habit = habit
        self.seconds = Int(habit.requiredSecond)
        self.date = date
        _timeRemaining = State(initialValue: seconds)
    }
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                Circle()
                    .foregroundColor(.clear)
                    .overlay(
                        ZStack {
                            Circle()
                                .trim(from: 0.0, to: (CGFloat(seconds) - CGFloat(timeRemaining))/CGFloat(seconds))
                                .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .square, lineJoin: .bevel))
                                .foregroundColor(habit.color)
                                .rotationEffect(Angle(degrees: 270.0))
                                .animation(.linear)
                                .zIndex(1)
                            Circle()
                                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .square, lineJoin: .bevel))
                                .subColor()
                                .zIndex(0)
                        }
                    )
                Rectangle()
                    .foregroundColor(habit.color)
                    .frame(width: 10, height: 90)
                    .cornerRadius(10)
                    .offset(y: -40)
                    .rotationEffect(.degrees(Double(360/seconds*(seconds - timeRemaining))))
                    .animation(.linear)
                Rectangle()
                    .foregroundColor(habit.color)
                    .frame(width: 10, height: 90)
                    .cornerRadius(10)
                    .offset(y: -40)
                    .animation(.linear)
                VStack(spacing: 0) {
                    Text("\(timeRemaining)")
                        .title()
                        .mainColor()
                        .onReceive(timer) { _ in
                            guard isCounting else { return }
                            self.timeRemaining = max(0, self.timeRemaining - 1)
                        }
                        .onReceive(NotificationCenter.default.publisher(
                                    for: UIApplication.willResignActiveNotification)
                        ) { _ in
                            isCounting = false
                            self.timer.upstream.connect().cancel()
                        }
                    Text("Sec".localized)
                        .bodyText()
                        .subColor()
                }
                .offset(y: 60)
            }
            .frame(width: 250, height: 250)
            .fixedSize()
            Spacer()
            HStack(alignment: .center, spacing: 60) {
                Button(action: {
                    self.timer.upstream.connect().cancel()
                    isCounting = false
                    timeRemaining = seconds
                }) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .subColor()
                        .title()
                }
                .frame(width: 50)
                Button(action: {
                    if let id = habit.id, timeRemaining == 0 {
                        let addedVal = Int16(addUnit.addUnit[id] ?? 1)
                        withAnimation {
                            habit.achievement[date.dictKey] = (habit.achievement[date.dictKey] ?? 0) + addedVal
                        }
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        Habit.save(managedObjectContext)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    if isCounting {
                        self.timer.upstream.connect().cancel()
                    } else {
                        self.timer =
                            Timer.publish(every: 1, on: .current, in: .common).autoconnect()
                    }
                    isCounting.toggle()
                }) {
                    Image(systemName: timeRemaining == 0 ? "plus" : (isCounting ? "pause" : "play"))
                        .subColor()
                        .title()
                }
                .frame(width: 50)
            }
            Spacer()
        }
        .navigationBarTitle(habit.name)
    }
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var addUnit: IncrementPerTap
    
}

struct HabitTimer_Previews: PreviewProvider {
    static var previews: some View {
        let coreDataPreview = CoreDataPreview()
        coreDataPreview.habit1.requiredSecond = 5
        return
            NavigationView {
                HabitTimer(habit: coreDataPreview.habit1, date: Date())
                    .environmentObject(coreDataPreview.incrementPerTap)
            }
    }
}

