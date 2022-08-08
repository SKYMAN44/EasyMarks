//
//  ContentView.swift
//  AutoMarkExt
//
//  Created by Дмитрий Соколов on 02.08.2022.
//

import SwiftUI

struct ContentView: View {
    let storage: UserDefaults = UserDefaults(suiteName: MarkSuit.APP_GROUP_ID)!
    @State private var NumberOfSpaces = UserDefaults(suiteName: MarkSuit.APP_GROUP_ID)!.numberOfSpaces
    @State private var isFixMark = UserDefaults(suiteName: MarkSuit.APP_GROUP_ID)!.fixExistingMarks
    
    @State private var text = "0"
    @State private var spaceCounter = 0
    @State private var fixMark = true

    var body: some View {
        VStack(alignment: .center, spacing: 4, content: {
            Text("Settings")
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(alignment: .firstTextBaseline, spacing: nil) {
                Text("№ spaces after MARK")
                HStack(alignment: .top, spacing: 5) {
                    Stepper(
                        "",
                        onIncrement: {
                            guard NumberOfSpaces < 2 else {
                                return
                            }
                            NumberOfSpaces += 1
                            text = String(NumberOfSpaces)
                    },
                        onDecrement: {
                            guard NumberOfSpaces > 0 else {
                                return
                            }
                            NumberOfSpaces -= 1
                            text = String(NumberOfSpaces)
                        }
                    )
                    Text(text)
                }
            }.padding()
            HStack(alignment: .firstTextBaseline, spacing: 20) {
                Text("Fix existing MARK")
                Toggle(
                    "",
                    isOn: $fixMark
                ).toggleStyle(SwitchToggleStyle(tint: .purple))
            }
            Spacer()
            Button("save") {
                    self.save()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    }
            }.frame(width: 200, height: 50, alignment: .center)
            Spacer()
            SignatureView()
        }).frame(width: 360.0, height: 250.0)
    }

    func save(){
        storage.numberOfSpaces = NumberOfSpaces
        storage.fixExistingMarks = fixMark
    }
}

struct ContentViewPreviews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
