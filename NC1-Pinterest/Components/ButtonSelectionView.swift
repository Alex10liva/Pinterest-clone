//
//  ButtonSelectionView.swift
//  NC1-Pinterest
//
//  Created by Alejandro Oliva Ochoa on 17/11/23.
//

import SwiftUI

struct ButtonSelectionView: View {
    
    // MARK: - Environment properties
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Properties
    @State var openCreatePinSheet: Bool = false
    @State var openCreateBoardSheet: Bool = false
    @Binding var firstSheetOpened: Bool
    
    
    // MARK: - Body
    var body: some View {
        NavigationStack{
            VStack(){
                // MARK: - Info
                HStack(alignment: .top){
                    Text("i")
                        .foregroundStyle(.white)
                        .font(.footnote)
                        .fontWeight(.black)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(.colorInfoIcon)
                        .clipShape(Circle())
                        .accessibilityHidden(true)
                    
                    VStack(alignment: .leading){
                        Text("We combined Pins and Idea Pins.")
                        Link(destination: URL(string: "https://creators.pinterest.com/blog/new-pin-format-update/")!){
                            Text("Learn more")
                                .underline()
                                .bold()
                        }
                    }
                    .foregroundStyle(.black)
                    Spacer()
                }
                .padding()
                .background(.colorInfoBG)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.bottom, 10)
                
                
                // MARK: - Buttons to create
                HStack(spacing: 15){
                    // Pin button
                    Button{
                        openCreatePinSheet.toggle()
                    } label: {
                        VStack{
                            Image(systemName: "pin.fill")
                                .font(.title3)
                                .frame(width: 24, height: 24)
                                .padding()
                                .background(.colorBGButton)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                            Text("Pin")
                                .bold()
                        }
                    }
                    .sheet(isPresented: $openCreatePinSheet){
                        CreatePinView(firstSheetOpened: $firstSheetOpened)
                            .presentationDetents([.large])
                    }
                    .accessibilityLabel("Pin")
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint("Double tap to open the panel to create new Pin.")
                    
                    // Board button
                    Button{
                        openCreateBoardSheet.toggle()
                    } label: {
                        VStack{
                            Image(colorScheme == .dark ? "board-dark-fill" : "board-fill")
                                .frame(width: 24, height: 24)
                                .padding()
                                .background(.colorBGButton)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Text("Board")
                                .bold()
                        }
                    }
                    .sheet(isPresented: $openCreateBoardSheet){
                        CreateBoardView(firstSheetOpened: $firstSheetOpened)
                            .presentationDetents([.large])
                    }
                    
                    .accessibilityLabel("Board")
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint("Double tap to open the panel to create new Board.")
                }
            }
            .padding()
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
                }
                
                ToolbarItem(placement: .principal){
                    Text("Start creating now")
                        .bold()
                }
            }
            Spacer()
        }
    }
}

#Preview {
    ButtonSelectionView(firstSheetOpened: .constant(false))
}
