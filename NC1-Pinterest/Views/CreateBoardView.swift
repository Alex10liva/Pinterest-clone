//
//  CreateBoardView.swift
//  NC1-Pinterest
//
//  Created by Alejandro Oliva Ochoa on 17/11/23.
//

import SwiftUI

struct CreateBoardView: View {
    
    // MARK: - Environment properties
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Swift Data properties
    @Environment(\.modelContext) private var modelContext
    
    // MARK: - Properties
    @State private var boardTitle: String = ""
    @State private var toggle = false
    @Binding var firstSheetOpened: Bool
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.colorCardDetailBG
                    .ignoresSafeArea(.all)
                
                VStack{
                    // MARK: - Title field
                    VStack(alignment: .leading){
                        Text("Board name")
                        // Dynamic text (Accessibility)
                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                        
                        TextField(
                            "Give your board a title",
                            text: $boardTitle
                        )
                        .font(.title3)
                        .fontWeight(.bold)
                        // Dynamic text (Accessibility)
                        .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                    }
                    .padding(.bottom, 40)
                    
                    // MARK: - Collaborators section
                    VStack(alignment: .leading){
                        
                        Text("Collaborators")
                        // Dynamic text (Accessibility)
                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                        
                        HStack{
                            ProfileIconView(image: "profile-img")
                                .frame(height: dynamicTypeSize.customImgSize)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(colorScheme == .dark ? .black : .clear)
                                )
                            
                            Spacer()
                            
                            Image(systemName: "person.fill.badge.plus")
                                .padding()
                                .frame(height: dynamicTypeSize.customImgSize)
                                .background(.colorBGButton)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.bottom, 40)
                    
                    
                    // MARK: - Privacy properties
                    VStack(alignment: .leading, spacing: 10){
                        
                        Text("Privacy")
                        // Dynamic text (Accessibility)
                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                        
                        HStack(){
                            
                            VStack(alignment: .leading){
                                Text("Make this board secret")
                                    .font(.title3)
                                    .bold()
                                // Dynamic text (Accessibility)
                                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                                
                                Text("Only you and your collaborators will see this board")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .accessibilityElement(children: .combine)

                            Spacer()
                            
                            HStack {
                                Rectangle()
                                    .foregroundColor(toggle == true ? .white : .colorToogleBG)
                                    .frame(width: 45, height: 25, alignment: .center)
                                    .overlay(
                                        Circle()
                                            .foregroundColor(.accentColorInverted)
                                            .padding(.all, 3)
                                            .offset(x: toggle == true ? 11 : -11, y: 0)
                                        
                                    ).cornerRadius(20)
                            }
                            .accessibilityLabel(toggle ? "On" : "Off")
                        }
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.3)){
                                toggle.toggle()
                            }
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityHint(toggle ? "Double tap to make this board secret" : "Double tap to make this board public")
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            // MARK: - Toolbar
            .toolbar(){
                ToolbarItem(placement: .topBarLeading){
                    Button{
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .fontWeight(.heavy)
                            .padding(5)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    .accessibilityLabel("Close")
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint("Double tap to close the creation panel.")
                }
                
                ToolbarItem(placement: .principal){
                    Text("Create board")
                        .bold()
                }
                
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        withAnimation(.easeOut(duration: 0.4)){
                            addItem()
                            boardTitle = ""
                            dismiss()
                            firstSheetOpened = false
                        }
                        
                        hapticFeedback.notificationOccurred(.success)
                    } label: {
                        Text("Create")
                            .font(.footnote)
                            .foregroundStyle(boardTitle != "" ? .white : .secondary)
                            .fontWeight(.bold)
                            .padding()
                            .background(boardTitle != "" ? .colorPinterest : (colorScheme == .light ? .colorBGButton : .clear))
                            .clipShape(Capsule())
                            .padding(.top, 5)
                    }
                    .accessibilityLabel("Create")
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint(boardTitle != "" ? "Double tap to create a new Board." : "Add a title to create a new Board.")
                }
            }
        }
        
    }
    
    
    // MARK: - Functions
    // Function to create a new board
    private func addItem() {
        withAnimation {
            let newBoard = Board(name: boardTitle, pins: [])
            modelContext.insert(newBoard)
            
            do {
                try modelContext.save()
            } catch{
                print("Couldn't save the model.")
            }
        }
    }
}

#Preview {
    CreateBoardView(firstSheetOpened: .constant(false))
}
