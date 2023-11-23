//
//  ProfileView.swift
//  NC1-Pinterest
//
//  Created by Alejandro Oliva Ochoa on 20/11/23.
//

import SwiftUI
import SwiftData

enum nColumnsOptions: String {
    case wideIcon = "wideIcon"
    case defaultIcon = "defaultIcon"
    case compactIcon = "compactIcon"
}

struct ProfileView: View {
    
    // MARK: - Swift Data properties
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Pin.date, order: .reverse) private var items: [Pin]
    
    // MARK: - Environment properties
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Properties
    @State var search: String = ""
    @State var columnsIconOption: nColumnsOptions = .defaultIcon
    @State var columnSheetIsPresented: Bool = false
    @State var addSheetIsPresented: Bool = false
    
    @State private var pinsActive: Bool = true
    @State private var boardsActive: Bool = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack{
            VStack{
                // MARK: - View header
                HStack{
                    ProfileIconView(image: "profile-img")
                        .padding(.vertical, 5)
                    Spacer()
                    Image(systemName: "ellipsis")
                }
                .frame(height: dynamicTypeSize.customImgSize)
                .overlay{
                    
                    Text("Pins")
                        .bold()
                }
            }
            .padding(10)
            
            // MARK: - Search bar
            HStack{
                HStack{
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                        .bold()
                    
                    TextField(
                        "Search",
                        text: $search
                    )
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.colorBGButton)
                .clipShape(Capsule())
                
                // MARK: - Layout button
                Button{
                    columnSheetIsPresented.toggle()
                } label: {
                    Image(getImage(columnOption: columnsIconOption))
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                }
                .padding(.horizontal)
                .sheet(isPresented: $columnSheetIsPresented){
                    NumberColumnsView(columnsIconOption: $columnsIconOption)
                        .presentationCornerRadius(30)
                        .presentationDetents([.fraction(0.35)])
                        .onDisappear(){
                            UserDefaults.standard.set(columnsIconOption.rawValue, forKey: "nColumnsOption")
                        }
                }
                
                // MARK: - Add button
                Button(){
                    addSheetIsPresented.toggle()
                } label: {
                    Image(systemName: "plus")
                        .bold()
                        .font(.title2)
                }
                .sheet(isPresented: $addSheetIsPresented){
                    CreatePinView(firstSheetOpened: .constant(true))
//                    ButtonSelectionView(firstSheetOpened: $addSheetIsPresented)
//                        .presentationDetents([.fraction(0.15)])
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 5)
            
            // MARK: - Scroll view grid
            ScrollView{
                ScrollPinsGrid(pins: items, nColumns: getNColumns(columnOption: columnsIconOption))
            }
            .overlay{
                if items.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No pins added", systemImage: "pin")
                    }, description: {
                        Text("Start adding your pins by tapping on the '+' button")
                    })
                }
            }
        }
        .onAppear(){
            columnsIconOption = getStoredNColumnsOption()
        }
    }
    
    // MARK: - Functions
    // Function to get the stored number of columns from user defaults
    func getStoredNColumnsOption() -> nColumnsOptions {
        if let savedOptionRawValue = UserDefaults.standard.string(forKey: "nColumnsOption"),
           let savedOption = nColumnsOptions(rawValue: savedOptionRawValue) {
            return savedOption
        } else {
            return .defaultIcon
        }
    }
    
    // Function to get the iamge depending on the selected layout
    func getImage(columnOption: nColumnsOptions) -> String {
        switch columnOption {
        case .compactIcon:
            return colorScheme == .dark ? "compact-icon-dark" : "compact-icon"
            
        case .defaultIcon:
            return colorScheme == .dark ? "default-icon-dark" : "default-icon"
            
        case .wideIcon:
            return colorScheme == .dark ? "wide-icon-dark" : "wide-icon"
        }
    }
    
    // Function to get the number of columns depending on the selected layout
    func getNColumns(columnOption: nColumnsOptions) -> Int {
        switch columnOption {
        case .compactIcon:
            return 3
            
        case .defaultIcon:
            return 2
            
        case .wideIcon:
            return 1
        }
    }
}


#Preview {
    ProfileView()
}
