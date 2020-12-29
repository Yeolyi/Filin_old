//
//  HabitTimer.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/22.
//

import SwiftUI

struct HabitTimer: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var addUnit: IncrementPerTap
    let seconds: Int
    let habit: Habit
    let date: Date
    
    @State private var timeRemaining = 0
    @State var isCounting = false
    var isComplete: Bool {
        timeRemaining == 0
    }
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
                        Circle()
                            .trim(from: 0.0, to: 1.0 - (CGFloat(seconds) - CGFloat(timeRemaining))/CGFloat(seconds))
                            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .square, lineJoin: .bevel))
                            .mainColor()
                            .rotationEffect(Angle(degrees: 270.0))
                            .animation(.linear)
                    )
                Button(action: {
                    guard let id = habit.id, isComplete else { return }
                    let addedVal = Int16(addUnit.addUnit[id] ?? 1)
                    withAnimation {
                        habit.achievement[date.dictKey] = (habit.achievement[date.dictKey] ?? 0) + addedVal
                    }
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    Habit.coreDataSave(managedObjectContext)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("\(timeRemaining == 0 ? "Tap to complete".localized : "\(timeRemaining)")")
                        .font(.system(size: 30, weight: .semibold))
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
                }
            }
            .frame(width: 200, height: 200)
            .padding(.bottom, 60)
            Spacer()
            Button(action: {
                if isCounting {
                    self.timer.upstream.connect().cancel()
                } else {
                    self.timer =
                        Timer.publish(every: 1, on: .current, in: .common).autoconnect()
                }
                isCounting.toggle()
            }) {
                Image(systemName: isCounting ? "pause" : "play")
                    .font(.system(size: 40))
                    .mainColor()
            }
            Spacer()
        }
        .navigationBarTitle("Timer".localized)
    }
}

/*
struct HabitTimer_Previews: PreviewProvider {
    static var previews: some View {
        HabitTimer()
    }
}
*/
