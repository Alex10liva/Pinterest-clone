//
//  Home.swift
//  NC1-Pinterest
//
//  Created by Alejandro Oliva Ochoa on 14/11/23.
//

import SwiftUI
import SwiftData
import PhotosUI

struct HomeView: View {
    // MARK: - Swift Data Properties
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Pin.date, order: .reverse) private var items: [Pin]
    @Query private var boards: [Board]
    
    // MARK: - Environment properties
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Properties
    @State private var selectedtab: Board = .init(name: "All", pins: [])
    @State private var allSelected: Bool = true
    
    @State var columnsIconOption: nColumnsOptions = .defaultIcon
    @State var columnSheetIsPresented: Bool = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack{
            ZStack(alignment: .bottom){
                VStack{
                    // MARK: - Custom tab bar
//                    if(!items.isEmpty){
                        HStack{
                            ScrollView(.horizontal){
                                HStack(){
                                    // MARK: - Default board
                                    Text("All")
                                        .font(.callout)
                                        .bold()
                                        .padding(.bottom, 5)
                                        .background(
                                            VStack {
                                                Spacer()
                                                RoundedRectangle(cornerRadius: 1)
                                                    .fill(.primary)
                                                    .frame(height: 3)
                                                    .opacity(allSelected ? 1 : 0)
                                            }
                                        )
                                        .padding(.horizontal, 8)
                                        .padding(.leading, 10)
                                        .padding(.vertical, 10)
                                        .onTapGesture {
                                            withAnimation(.easeOut){
                                                allSelected = true
                                            }
                                        }
                                        .accessibilityLabel(allSelected ? "Selected. All" : "All")
                                        .accessibilityAddTraits(.isButton)
                                    
                                    // MARK: - Display the created boards
                                    ForEach(boards){ board in
                                        HStack(spacing: 10){
                                            Text(board.name)
                                                .font(.callout)
                                                .bold()
                                                .padding(.bottom, 5)
                                                .background(
                                                    VStack {
                                                        Spacer()
                                                        RoundedRectangle(cornerRadius: 1)
                                                            .fill(.primary)
                                                            .frame(height: 3)
                                                            .opacity(!allSelected && selectedtab == board ? 1 : 0)
                                                    }
                                                )
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 10)
                                                .onTapGesture {
                                                    withAnimation(.easeOut){
                                                        selectedtab = board
                                                        allSelected = false
                                                    }
                                                }
                                                .accessibilityLabel(selectedtab == board ? "Selected. \(board.name)" : "\(board.name)")
                                                .accessibilityAddTraits(.isButton)
                                        }
                                        
                                    }
                                    Spacer()
                                }
                            }
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
                                    .presentationDetents([.fraction(0.35)])
                                    .onDisappear(){
                                        UserDefaults.standard.set(columnsIconOption.rawValue, forKey: "nColumnsOption")
                                    }
                            }
                            .accessibilityLabel("Display options.")
                            .accessibilityAddTraits(.isButton)
                            .accessibilityHint("Double tap to change the layout of the grid.")
                        }
//                    }
                    // MARK: - Scroll view grid (Pinterest style)
                    ScrollView{
                        
                        // If the all tab is selected display all the pins
                        if allSelected {
                            ScrollPinsGrid(pins: items, nColumns: getNColumns(columnOption: columnsIconOption))
                        } else {
                            // Filter the boards depending on the selected tab
                            let filteredBoards = boards.filter { $0.name == selectedtab.name }
                            
                            // Flatten the pins and then sort them by date
                            let sortedPins = filteredBoards.flatMap { $0.pins }.sorted(by: { $0.date > $1.date })
                            
                            ScrollPinsGrid(pins: sortedPins, nColumns: getNColumns(columnOption: columnsIconOption))
                        }
                    }
                }
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
    
    func getString(columnOption: nColumnsOptions) -> String {
        switch columnOption {
        case .compactIcon:
            return "Compact layout."
            
        case .defaultIcon:
            return "Default layout."
            
        case .wideIcon:
            return "Wide layout."
        }
    }
}

#Preview {
    HomeView()
}
