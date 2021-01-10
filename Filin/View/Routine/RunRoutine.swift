//
//  RunRoutine.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/26.
//

import SwiftUI

struct RunRoutine: View {
    
    let routine: RoutineContext
    let habitContent = HabitContextManager.shared.contents
    @State var currentListIndex = 0
    @State var isTimeInit = false
    
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining = 0
    @State var isCounting = false
    var isComplete: Bool {
        timeRemaining == 0
    }
    
    var body: some View {
        VStack {
            Spacer()
            if currentListIndex > 0 {
                VStack {
                    ForEach(0...currentListIndex - 1, id: \.self) { index in
                        Text(habitContent[index].name)
                            .subColor()
                            .headline()
                    }
                }
            }
            VStack {
                Text(habitContent[currentListIndex].name)
                    .title()
                LinearProgressBar(
                    color: ThemeColor.mainColor(colorScheme),
                    progress: habitContent[currentListIndex].progress(at: Date()) ?? 0
                )
                .frame(width: 200)
            }
            .padding(10)
            if currentListIndex < habitContent.count - 1 {
                VStack {
                    ForEach(currentListIndex + 1...habitContent.count - 1, id: \.self) { index in
                        Text(habitContent[index].name)
                            .subColor()
                            .headline()
                    }
                }
            }
            Spacer()
            nextButton
                .padding(.bottom, 50)
                .onReceive(timer) { _ in
                    guard isCounting else { return }
                    withAnimation {
                        self.timeRemaining = max(0, self.timeRemaining - 1)
                    }
                }
                .onReceive(NotificationCenter.default.publisher(
                            for: UIApplication.willResignActiveNotification)
                ) { _ in
                    isCounting = false
                    self.timer.upstream.connect().cancel()
                }
        }
        .onAppear {
            if !isTimeInit {
                timeRemaining = Int(habitInfos.first(where: {$0.id == routine.list[0]})!.requiredSecond)
                isTimeInit = true
            }
        }
    }
    
    var nextButton: some View {
        Button(action: {
            if habitContent[currentListIndex].requiredSec != 0 && timeRemaining != 0 {
                if isCounting {
                    self.timer.upstream.connect().cancel()
                } else {
                    self.timer =
                        Timer.publish(every: 1, on: .current, in: .common).autoconnect()
                }
                isCounting.toggle()
                return
            } else {
                self.timer.upstream.connect().cancel()
                isCounting = false
                let id = habitContent[currentListIndex].id
                withAnimation {
                    habitContent[currentListIndex].calAchieve(at: Date(), isAdd: true)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    if currentListIndex == habitContent.count - 1 {
                        presentationMode.wrappedValue.dismiss()
                        return
                    }
                    withAnimation {
                        currentListIndex += 1
                    }
                    timeRemaining = habitContent[currentListIndex].requiredSec
                }
            }
        }) {
            ZStack {
                if habitContent[currentListIndex].requiredSec != 0 {
                    if timeRemaining == 0 {
                        Text(currentListIndex == habitContent.count - 1 ? "Complete".localized : "Next".localized)
                            .foregroundColor(.white)
                            .zIndex(1)
                        Circle()
                            .foregroundColor(ThemeColor.mainColor(colorScheme))
                            .frame(width: 100, height: 100)
                    } else if isCounting {
                        Image(systemName: "pause")
                            .headline()
                            .mainColor()
                            .zIndex(1)
                        Circle()
                            .foregroundColor(.clear)
                            .overlay(
                                Circle()
                                    .trim(from: 0.0, to: CGFloat(timeRemaining)/CGFloat(habitContent[currentListIndex].requiredSec))
                                    .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .square, lineJoin: .bevel))
                                    .mainColor()
                                    .rotationEffect(Angle(degrees: 270.0))
                            )
                            .frame(width: 100, height: 100)
                    } else {
                        Image(systemName: "play")
                            .headline()
                            .mainColor()
                            .zIndex(1)
                        Circle()
                            .foregroundColor(.clear)
                            .overlay(
                                Circle()
                                    .trim(from: 0.0, to: CGFloat(timeRemaining)/CGFloat(habitContent[currentListIndex].requiredSec))
                                    .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .square, lineJoin: .bevel))
                                    .mainColor()
                                    .rotationEffect(Angle(degrees: 270.0))
                            )
                            .frame(width: 100, height: 100)
                    }
                } else {
                    Text(currentListIndex == habitContent.count - 1 ? "Complete".localized : "Next".localized)
                        .foregroundColor(.white)
                        .zIndex(1)
                    Circle()
                        .foregroundColor(ThemeColor.mainColor(colorScheme))
                        .frame(width: 100, height: 100)
                }
                
            }
        }
    }
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: []
    )
    var habitInfos: FetchedResults<Habit>

}

/*
struct RunRoutine_Previews: PreviewProvider {
    static var previews: some View {
        let coreDataPreview = CoreDataPreview.shared
        return RunRoutine(routine: coreDataPreview.sampleRoutine(name: "Sample", dayOfTheWeek: [1, 3, 5], time: "13-00"))
    }
}

*/
