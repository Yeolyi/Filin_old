//
//  EmojiPicker.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/28.
//

import SwiftUI

struct EmojiPicker: View {
    
    @Binding var selectedDate: Date
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var habit: Habit
    @ObservedObject var emojiManager: EmojiManager
    @Binding var activeSheet: DetailViewActiveSheet?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                Button(action: {
                    habit.dailyEmoji[selectedDate.dictKey] = nil
                    save()
                }) {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 25))
                        .mainColor()
                        .opacity(habit.dailyEmoji[selectedDate.dictKey] == nil ? 1 : 0.5)
                }
                ForEach(emojiManager.emojiList, id: \.self) { emoji in
                    Button(action: {
                        habit.dailyEmoji[selectedDate.dictKey] = emoji
                        save()
                    }) {
                        Text(emoji)
                            .font(.system(size: 25))
                            .opacity(habit.dailyEmoji[selectedDate.dictKey] == emoji ? 1 : 0.5)
                    }
                }
                Button(action: {
                    activeSheet = DetailViewActiveSheet.emoji
                }) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 25))
                        .subColor()
                }
            }
        }
        .rowBackground()
    }
    
    func save() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}

struct EmojiPicker_Previews: PreviewProvider {
    
    struct PreviewWrapper: View {
        @State(initialValue: Date()) var selectedDate: Date

        var body: some View {
            EmojiPicker(
                selectedDate: $selectedDate,
                habit: sampleHabit(name: "Test"),
                emojiManager: EmojiManager(), activeSheet: .constant(nil)
            )
        }
      }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
