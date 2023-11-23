//
//  numberColumnsView.swift
//  NC1-Pinterest
//
//  Created by Alejandro Oliva Ochoa on 20/11/23.
//

import SwiftUI

struct NumberColumnsView: View {

    // MARK: - Environment properties
    @Environment(\.dismiss) private var dismiss
    
    
    // MARK: - Properties
    @Binding var columnsIconOption: nColumnsOptions
    
    
    // MARK: - Body
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                Text("View options")
                
                // MARK: - Wide button
                HStack{
                    Button{
                        withAnimation(.easeOut){
                            columnsIconOption = .wideIcon
                        }
                        dismiss()
                    } label: {
                        Text("Wide")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .accessibilityLabel("Wide")
                    .accessibilityAddTraits(.isButton)
                    
                    Image(systemName: "checkmark")
                        .bold()
                        .opacity(columnsIconOption == .wideIcon ? 1 : 0)
                        .accessibilityHidden(true)
                }
                .padding(.vertical, 5)
                
                
                // MARK: - Default button
                HStack{
                    Button{
                        withAnimation(.easeOut){
                            columnsIconOption = .defaultIcon
                        }
                        dismiss()
                    } label: {
                        Text("Default")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .accessibilityLabel("Default")
                    .accessibilityAddTraits(.isButton)
                    
                    Image(systemName: "checkmark")
                        .bold()
                        .opacity(columnsIconOption == .defaultIcon ? 1 : 0)
                        .accessibilityHidden(true)
                }
                .padding(.vertical, 5)
                
                
                // MARK: - Compact button
                HStack{
                    Button{
                        withAnimation(.easeOut){
                            columnsIconOption = .compactIcon
                        }
                        dismiss()
                    } label: {
                        Text("Compact")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .accessibilityLabel("Compact")
                    .accessibilityAddTraits(.isButton)
                    
                    Image(systemName: "checkmark")
                        .bold()
                        .opacity(columnsIconOption == .compactIcon ? 1 : 0)
                        .accessibilityHidden(true)
                }
                .padding(.vertical, 5)
                
                
                // MARK: - Close button
                HStack{
                    Spacer()
                    Button{
                        dismiss()
                    } label: {
                        ActionButton(textButton: "Close", redColor: false)
                            
                    }
                    .accessibilityLabel("Close")
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint("Double tap to close the view options panel.")
                    
                    Spacer()
                }
                .padding(.top, 10)
                
                Spacer()
            }
        }
        .padding()
    }
}

#Preview {
    NumberColumnsView(columnsIconOption: .constant(.compactIcon))
}
