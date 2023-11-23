//
//  ActionButton.swift
//  NC1-Pinterest
//
//  Created by Alejandro Oliva Ochoa on 15/11/23.
//

import SwiftUI

struct ActionButton: View {
    
    // MARK: - Environment properties
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    
    // MARK: - Properties
    var textButton: String
    var redColor: Bool
    
    var body: some View {
        Text(textButton)
            .font(.footnote)
            .foregroundStyle(redColor ? .white : .accent)
            .fontWeight(.bold)
            .padding()
            .background(redColor ? .colorPinterest : .colorBGButton)
            .clipShape(Capsule())
        
            // Dynamic text (Accessibility)
            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
            
    }
}

#Preview {
    ActionButton(textButton: "Create", redColor: false)
}
