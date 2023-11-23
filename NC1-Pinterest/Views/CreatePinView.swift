//
//  Create.swift
//  NC1-Pinterest
//
//  Created by Alejandro Oliva Ochoa on 15/11/23.
//

import SwiftUI
import SwiftData
import PhotosUI

struct CreatePinView: View {
    
    // MARK: - Environment properties
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Swift Data properties
    @Environment(\.modelContext) private var modelContext
    @Query private var boards: [Board]
    
    // MARK: - Properties
    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedPhotoData: Data?
    @State var newTitle: String = ""
    @State var newDesc: String = ""
    @State var newLink: String = ""
    @State var selectedBoard: Board?
    @Binding var firstSheetOpened: Bool
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        NavigationStack{
            ScrollView{
                // MARK: - Section to add a new photo
                Section {
                    if let selectedPhotoData, let uiImage = UIImage(data: selectedPhotoData){
                        PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()){
                            
                            ZStack(alignment: .topTrailing){
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                Image(systemName: "pencil.circle.fill")
                                    .padding(5)
                            }
                        }
                        .accessibilityLabel("Selected photo")
                        .accessibilityAddTraits(.isButton)
                        .accessibilityHint("Double tap to select another photo.")
                        
                    } else {
                        PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()){
                            Image(systemName: "plus.circle.fill")
                                .padding(.horizontal, 50)
                                .padding(.vertical, 90)
                        }
                        .background(.primary.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.primary.opacity(0.5), lineWidth: 2)
                        )
                        .accessibilityLabel("Add photo")
                        .accessibilityAddTraits(.isButton)
                        .accessibilityHint("Double tap to open the photo selector.")
                    }
                }
                .frame(width: 150)
                .padding(.top, 10)
                .padding(.bottom, 40)
                
                // MARK: - Title field
                VStack(alignment: .leading){
                    Text("Title")
                        .font(.caption)
                    // Dynamic text (Accessibility)
                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                    
                    TextField(
                        "Tell everyone what your Pin is about",
                        text: $newTitle
                    )
                    .font(.title3)
                    .fontWeight(.bold)
                    // Dynamic text (Accessibility)
                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                }
                .padding(.bottom, 40)
                
                
                
                // MARK: - Description field
                VStack(alignment: .leading){
                    Text("Description")
                        .font(.caption)
                    // Dynamic text (Accessibility)
                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                    
                    TextField(
                        "Add a detailed description",
                        text: $newDesc
                    )
                    // Dynamic text (Accessibility)
                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                }
                
                
                
                Divider()
                    .padding(.top, 5)
                    .padding(.bottom, 10)
                
                // MARK: - Link field
                VStack(alignment: .leading){
                    Text("Link")
                        .font(.caption)
                    // Dynamic text (Accessibility)
                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                    
                    TextField(
                        "Add your link here",
                        text: $newLink
                    )
                    .keyboardType(.URL)
                    // Dynamic text (Accessibility)
                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                }
                
                
                
                Divider()
                    .padding(.top, 5)
                    .padding(.bottom, 10)
                
                
                // MARK: - Board selector
                Picker("Pick a board", selection: $selectedBoard) {
                    Text("All").tag(nil as Board?)
                    ForEach(boards) { board in
                        Text(board.name).tag(board as Board?)
                    }
                }
                .pickerStyle(.navigationLink)
                
                Divider()
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                
            }
            .padding()
            
            // MARK: - Create button
            HStack{
                Spacer()
                Button{
                    withAnimation(.easeOut(duration: 0.4)){
                        addItem()
                        newTitle = ""
                        newDesc = ""
                        newLink = ""
                        selectedPhotoData = nil
                        dismiss()
                        firstSheetOpened = false
                    }
                    hapticFeedback.notificationOccurred(.success)
                    
                } label: {
                    ActionButton(textButton: "Create", redColor: true)
                        .padding(.bottom)
                }
                .padding(.horizontal)
                .accessibilityLabel("Create")
                .accessibilityAddTraits(.isButton)
                .accessibilityHint("Double tap to create a new Pin.")
            }
            .navigationTitle("Create pin")
            .navigationBarTitleDisplayMode(.inline)
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
            }
        }
        .task(id: selectedPhoto){
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self){
                selectedPhotoData = data
            }
        }
        
    }
    
    
    // MARK: - Functions
    // function to store a new pin
    private func addItem() {
        withAnimation {
            let newItem = Pin(image: selectedPhotoData!, title: newTitle, desc: newDesc, link: newLink)
            modelContext.insert(newItem)
            
            if(selectedBoard != nil){
                let filteredBoards = boards.filter { $0.name == selectedBoard!.name }
                filteredBoards[0].pins.append(newItem)
            }
            
            do {
                try modelContext.save()
            } catch{
                print("Couldn't save the model.")
            }
        }
    }
}

#Preview {
    CreatePinView(firstSheetOpened: .constant(false))
}
