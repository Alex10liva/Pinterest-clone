//
//  ContentView.swift
//  NC1-Pinterest
//
//  Created by Alejandro Oliva Ochoa on 15/11/23.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    @State var selectedTab: Tabs = .home
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Body
    var body: some View {
        
        // MARK: - Content
        VStack(spacing: 0){
            switch selectedTab {
            case .home:
                HomeView()
            case .search:
                EmptyView()
            case .create:
                CreateBoardView(firstSheetOpened: .constant(true))
            case .notifications:
                EmptyView()
            case .profile:
                ProfileView()
            }
            
            // MARK: - Custom tab bar
            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}

#Preview {
    ContentView()
}
