//
//  SheetButton.swift
//  Dense
//
//  Created by Joseph Pecoraro on 6/13/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import SwiftUI

struct SheetButton<Content> : View where Content : View {
    @State private var isPresented = false
    
    let title: String
    @ViewBuilder var content: () -> Content
    
    let action: Optional<() -> Void>
    
    init(_ title: String, action: Optional<() -> Void> = nil, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
        self.action = action
    }
    
    var body: some View {
        Button(title) {
            action?()
            isPresented.toggle()
        }
        .sheet(isPresented: $isPresented) {
            content()
        }
    }
}

struct SheetButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SheetButton("Test") {
                Text("Test")
            }
            SheetButton("Test 2", action: { print("test2") } ) {
                VStack {
                    Text("Test2")
                    Text("Test22")
                }
            }
        }
    }
}
