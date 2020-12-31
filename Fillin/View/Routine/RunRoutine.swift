//
//  RunRoutine.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/26.
//

import SwiftUI

struct RunRoutine: View {
    
    let routine: Routine
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State var currentListIndex = 0
    @State var isTimeInit = false
    
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining = 0
    @State var isCounting = false
    var isComplete: Bool {
        timeRemaining == 0
    }
    @EnvironmentObject var incrementPerTap: IncrementPerTap
    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: []
    )
    var habitInfos: FetchedResults<Habit>
    var habitList: [Habit] {
        var tempList: [Habit] = []
        for id in routine.list {
            guard let habit = habitInfos.first(where: {$0.id == id}) else {
                assertionFailure()
                return []
            }
            tempList.append(habit)
        }
        return tempList
    }

    var body: some View {
        VStack {
            Spacer()
            if currentListIndex > 0 {
                VStack {
                    ForEach(0...currentListIndex - 1, id: \.self) { index in
                        Text(habitList[index].name)
                            .subColor()
                            .headline()
                    }
                }
            }
            VStack {
                Text(habitList[currentListIndex].name)
                    .title()
                LinearProgressBar(
                    color: ThemeColor.mainColor(colorScheme),
                    progress: habitList[currentListIndex].progress(at: Date()) ?? 0
                )
                .frame(width: 200)
            }
            .padding(10)
            if currentListIndex < habitList.count - 1 {
                VStack {
                    ForEach(currentListIndex + 1...habitList.count - 1, id: \.self) { index in
                        Text(habitList[index].name)
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
            if habitList[currentListIndex].requiredSecond != 0 && timeRemaining != 0 {
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
                guard let id = habitList[currentListIndex].id else {
                    return
                }
                let addedVal = Int16(incrementPerTap.addUnit[id] ?? 1)
                withAnimation {
                    habitList[currentListIndex].achievement[Date().dictKey]
                        = (habitList[currentListIndex].achievement[Date().dictKey] ?? 0) + addedVal
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    if currentListIndex == habitList.count - 1 {
                        presentationMode.wrappedValue.dismiss()
                        return
                    }
                    withAnimation {
                        currentListIndex += 1
                    }
                    timeRemaining = Int(habitList[currentListIndex].requiredSecond)
                }
            }
        }) {
            ZStack {
                if habitList[currentListIndex].requiredSecond != 0 {
                    if timeRemaining == 0 {
                        Text(currentListIndex == habitList.count - 1 ? "Complete".localized : "Next".localized)
                            .foregroundColor(.white)
                            .zIndex(1)
                        Circle()
                            .foregroundColor(ThemeColor.mainColor(colorScheme))
                            .frame(width: 100, height: 100)
                    } else if isCounting {
                        Image(systemName: "pause")
                            .font(.system(size: 25))
                            .zIndex(1)
                        Circle()
                            .foregroundColor(.clear)
                            .overlay(
                                Circle()
                                    .trim(from: 0.0, to: CGFloat(timeRemaining)/CGFloat(habitList[currentListIndex].requiredSecond))
                                    .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .square, lineJoin: .bevel))
                                    .mainColor()
                                    .rotationEffect(Angle(degrees: 270.0))
                            )
                            .frame(width: 100, height: 100)
                    } else {
                        Image(systemName: "play")
                            .font(.system(size: 25))
                            .zIndex(1)
                        Circle()
                            .foregroundColor(.clear)
                            .overlay(
                                Circle()
                                    .trim(from: 0.0, to: CGFloat(timeRemaining)/CGFloat(habitList[currentListIndex].requiredSecond))
                                    .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .square, lineJoin: .bevel))
                                    .mainColor()
                                    .rotationEffect(Angle(degrees: 270.0))
                            )
                            .frame(width: 100, height: 100)
                    }
                } else {
                    Text(currentListIndex == habitList.count - 1 ? "Complete".localized : "Next".localized)
                        .foregroundColor(.white)
                        .zIndex(1)
                    Circle()
                        .foregroundColor(ThemeColor.mainColor(colorScheme))
                        .frame(width: 100, height: 100)
                }
               
            }
        }
    }
}

/*
 struct RunRoutine_Previews: PreviewProvider {
 static var previews: some View {
 RunRoutine()
 }
 }
 */
