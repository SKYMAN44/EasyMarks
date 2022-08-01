//
//  ContentView.swift
//  AutoMarkExt
//
//  Created by Дмитрий Соколов on 02.08.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var text = "0"
    @State private var spaceCounter = 0

    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Text("Settings")
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(alignment: .center, spacing: 20) {
                Text("№ spaces after MARK")
                Stepper(
                    "",
                    onIncrement: {
                        guard spaceCounter < 2 else {
                            return
                        }
                        spaceCounter += 1
                        text = String(spaceCounter)
                },
                    onDecrement: {
                        guard spaceCounter > 0 else {
                            return
                        }
                        spaceCounter -= 1
                        text = String(spaceCounter)
                    }
                )
                Text(text)
            }.padding()
        }.padding()
    }
}

struct ContentViewPreviews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
