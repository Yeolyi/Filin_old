//
//  EmojiListEdit.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/28.
//

import SwiftUI

struct EmojiListEdit: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var emojiManager: EmojiManager
    @State var listData: ListData<String> = ListData(values: [], save: {_ in})
    @State var newEmoji = ""
    
    var body: some View {
        VStack {
            InlineNavigationBar(
                title: "Edit emoji".localized, button1: {
                    Button(action: {
                        emojiManager.emojiList = listData.sortedValue
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save".localized)
                            .headerButton()
                            .mainColor()
                    }
                    
                }, button2: { EmptyView() }
            )
            HStack {
                TextFieldWithEndButton("Enter a emoji to add".localized, text: $newEmoji)
                    .frame(height: 30)
                Button(action: {
                    if let emoji = newEmoji.first?.description {
                        listData.add(value: emoji)
                        newEmoji = ""
                    }
                    UIApplication.shared.endEditing()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20))
                        .mainColor()
                        .padding(.trailing, 10)
                }
            }
            .padding(5)
            ReorderableList(listData: listData) { emoji in
                HStack(spacing: 10) {
                    Button(action: {
                        listData.delete(id: emoji)
                    }) {
                        Image(systemName: "minus.circle")
                            .font(.system(size: 20))
                            .mainColor()
                    }
                    Text(listData.internalIDToValue(emoji))
                }
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            self.listData = ListData(values: emojiManager.emojiList, save: { _ in
            })
        }
    }
}

/*
 struct EmojiListEdit_Previews: PreviewProvider {
 static var previews: some View {
 EmojiListEdit()
 }
 }
 */

struct TextFieldWrapperView: UIViewRepresentable {

    @Binding var text: String

    func makeCoordinator() -> TFCoordinator {
        TFCoordinator(self)
    }
}

extension TextFieldWrapperView {

    func makeUIView(context: UIViewRepresentableContext<TextFieldWrapperView>) -> UITextField {
        let textField = EmojiTextField()
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {

    }
}

class TFCoordinator: NSObject, UITextFieldDelegate {
    var parent: TextFieldWrapperView

    init(_ textField: TextFieldWrapperView) {
        self.parent = textField
    }

    //        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //            if let value = textField.text {
    //                parent.text = value
    //                parent.onChange?(value)
    //            }
    //
    //            return true
    //        }
}

class EmojiTextField: UITextField {
    // required for iOS 13
    override var textInputContextIdentifier: String? { "" } // return non-nil to show the Emoji keyboard ¯\_(ツ)_/¯

    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes where mode.primaryLanguage == "emoji"{
            return mode
        }
        return nil
    }
}
