//
//  FloatingTextFieldcx.swift
//  Dense
//
//  Created by Joseph Pecoraro on 4/3/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI

struct FloatingTextField: View {
    let title: String
    let placeholder: String
    let text: Binding<String>
    /// If you want the floating title to show based on an alternate value in addition to the primary text
    let alternateText: Binding<String>
    
    let style : Style
    
    init(_ title: String, placeholder: String = "", text: Binding<String>, alternateText: Binding<String> = .constant(""), style: Style = .adaptive) {
        self.title = title
        self.placeholder = placeholder
        self.text = text
        self.alternateText = alternateText
        self.style = style
    }
    
    var body: some View {
        switch(style) {
        case .fixed:
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(Color(.placeholderText))
                TextField(placeholder, text: text)
                    .textFieldStyle(.roundedBorder)
                    .onTapGesture {/* capture tap to prevent keyboard dismiss */}
            }
        case .adaptive:
            VStack(alignment: .leading, spacing: 2) {
                if !text.wrappedValue.isEmpty || !alternateText.wrappedValue.isEmpty {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(Color(.placeholderText))
                }
                TextField(title, text: text)
                    .textFieldStyle(.roundedBorder)
                    .onTapGesture {/* capture tap to prevent keyboard dismiss */}
            }
        }
    }
    
    enum Style {
        case fixed
        case adaptive
    }
}

struct FloatingTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Fixed")
                .padding()
            FloatingTextField("Name", placeholder: "Peanut Butter", text: .constant(""), style: .fixed)
            FloatingTextField("Name", text: .constant("Name"), style: .fixed)
            FloatingTextField("Calories Per Serving", text: .constant("20.0"), style: .fixed)
                .keyboardType(.decimalPad)
            FloatingTextField("Calories Per Serving", placeholder: "160", text: .constant(""), style: .fixed)
                .keyboardType(.decimalPad)
            Text("Adaptive")
                .padding()
            FloatingTextField("Name", placeholder: "Peanut Butter", text: .constant(""), style: .adaptive)
            FloatingTextField("Name", text: .constant("Name"), style: .adaptive)
            FloatingTextField("Calories Per Serving", placeholder: "160", text: .constant(""), style: .adaptive)
                .keyboardType(.decimalPad)
            FloatingTextField("Calories Per Serving", text: .constant("20.0"), style: .adaptive)
                .keyboardType(.decimalPad)
        }
    }
}
