//
//  SignatureView.swift
//  AutoMarkExt
//
//  Created by Дмитрий Соколов on 06.08.2022.
//

import SwiftUI

struct SignatureView: View {
    var body: some View {
        Text("©SKYMAN44 2022")
            .foregroundColor(.gray)
            .fontWeight(.thin)
            .padding()
            .font(.system(size: 10))
            .frame(width: 200, height: 40, alignment: .bottom)
    }
}
