//
//  OptionsCard.swift
//  NC1-Pinterest
//
//  Created by Alejandro Oliva Ochoa on 21/11/23.
//

import SwiftUI
import SwiftData

struct OptionsCard: View {
    
    // MARK: - Properties
    var pinToDelete: Pin
    @State var deleteOptionsSheet: Bool = false
    @Binding var firstSheet: Bool
    
    // MARK: - Body
    var body: some View {
        NavigationStack{
            ZStack(alignment: .top){
                Color.colorCardDetailBG
                
                VStack(alignment: .leading){
                    Text("Manage")
                        .padding(.bottom)
                    
                    HStack{
                        Button{
                            deleteOptionsSheet.toggle() // Toggle the delete options sheet
                        } label: {
                            Text("Delete pin")
                                .font(.title2)
                                .bold()
                            
                            Spacer()
                        }
                        .sheet(isPresented: $deleteOptionsSheet){
                            // Sheet to delete a pin
                            SheetDeleteView(passedDeleteOptionsSheet: $firstSheet, pinToDelete: pinToDelete)
                                .presentationDetents([.fraction(0.3)])
                        }
                        
                        Spacer()
                    }
                }
                .padding()
                
            }
            .ignoresSafeArea(.all)
        }
    }
    
    struct SheetDeleteView: View {
        // MARK: - Environment properties
        @Environment(\.dismiss) var dismiss
        @Environment(\.modelContext) private var modelContext
        
        // MARK: - Swiftui queries
        @Query private var items: [Pin]
        @Query private var boards: [Board]
        
        // MARK: - Properties
        @Binding var passedDeleteOptionsSheet: Bool
        var pinToDelete: Pin
        
        // MARK: - Body
        var body: some View {
            ZStack(alignment: .top){
                Color.colorCardDetailBG
                
                VStack{
                    Text("Are you sure?")
                        .font(.title)
                        .bold()
                        .padding(.top, 20)
                        .padding(.bottom, 5)
                    
                    Text("If you delete this Pin, it'll be gone for good and those who've saved it won't be able to view it.")
                        .padding(.bottom, 10)
                    
                    HStack{
                        Button{
                            dismiss() // Dismiss the sheet
                        } label: {
                            ActionButton(textButton: "Cancel", redColor: false)
                        }
                        
                        Button{
                            // Delete the pin and dismiss the sheet
                            deleteItem(pinToDelete: pinToDelete)
                            dismiss()
                            passedDeleteOptionsSheet = false
                        } label: {
                            ActionButton(textButton: "Delete", redColor: true)
                        }
                    }
                }
                .padding()
            }
            .ignoresSafeArea(.all)
        }
        
        // MARK: - Functions
        // Functon to delete a pin
        func deleteItem(pinToDelete: Pin) {
            // Delete the pin in the All list
            if let index = items.firstIndex(where: { $0.id == pinToDelete.id }) {
                withAnimation {
                    modelContext.delete(items[index])
                }
            }
            
            // If the pin is in a board, delete it
            for boardIndex in boards.indices {
                if let pinIndex = boards[boardIndex].pins.firstIndex(where: { $0.id == pinToDelete.id }) {
                    boards[boardIndex].pins.remove(at: pinIndex)
                }
            }
        }
    }
}

#Preview {
    OptionsCard(pinToDelete: Pin(image: Data(), title: "", desc: "", link: ""), firstSheet: .constant(false))
}
