//
//  CustomTabBar.swift
//  NC1-Pinterest
//
//  Created by Alejandro Oliva Ochoa on 16/11/23.
//

import SwiftUI

enum Tabs: Int {
    case home = 0
    case search = 2
    case create = 3
    case notifications = 4
    case profile = 5
}

struct CustomTabBar: View {
    
    // MARK: - Environment properties
    @Environment(\.colorScheme) var colorScheme
    
    
    // MARK: - Properties
    @Binding var selectedTab: Tabs
    @State var isSheetOpened: Bool = false
    
    
    // MARK: - Body
    var body: some View {
        HStack(alignment: .top) {
            
            
            // MARK: - Home item
            Button{
                withAnimation(.linear){
                    selectedTab = .home
                }
            } label: {
                GeometryReader { geo in
                    VStack{
                        Image(selectedTab == .home ? (colorScheme == .dark ? "house-dark-fill" : "house-light-fill") : "house")
                            .padding(.top)
                    }
                    
                    .frame(width: geo.size.width, height: geo.size.height / 2)
                }
            }
            .accessibilityLabel(selectedTab == .home ? "Selected, Home, Tab, 1 of 5." : "Home, Tab, 1 of 5.")
            .accessibilityRemoveTraits(.isButton)
            
            // MARK: - Search item
            Button{
            } label: {
                GeometryReader { geo in
                    VStack{
                        Image("magnifyingglass")
                            .padding(.top)
                    }
                    
                    .frame(width: geo.size.width, height: geo.size.height / 2)
                }
            }
            .disabled(true)
            .accessibilityLabel(selectedTab == .search ? "Selected, Search, Tab, 2 of 5." : "Search, Tab, 1 of 5, Disabled.")
            .accessibilityRemoveTraits(.isButton)
            
            // MARK: - Add item
            Button{
                isSheetOpened = true
            } label: {
                GeometryReader { geo in
                    VStack{
                        Image(selectedTab == .create ? (colorScheme == .dark ? "plus-dark-fill" : "plus-light-fill") : "plus")
                            .padding(.top)
                    }
                    .frame(width: geo.size.width, height: geo.size.height / 2)
                }
            }
            .sheet(isPresented: $isSheetOpened) {
                // CreatePinView(), CreateBoardView()
                ButtonSelectionView(firstSheetOpened: $isSheetOpened)
                    .presentationDetents([.fraction(0.35)])
            }
            .accessibilityLabel(selectedTab == .create ? "Selected, Create, Tab, 3 of 5." : "Create, Tab, 3 of 5.")
            .accessibilityRemoveTraits(.isButton)
            
            
            // MARK: - Search item
            Button{
            } label: {
                GeometryReader { geo in
                    VStack{
                        Image("messages")
                            .padding(.top)
                    }
                    
                    .frame(width: geo.size.width, height: geo.size.height / 2)
                }
            }
            .disabled(true)
            .accessibilityLabel(selectedTab == .notifications ? "Selected, Notifications, Tab, 4 of 5." : "Notifications, Tab, 4 of 5, Disabled.")
            .accessibilityRemoveTraits(.isButton)
            
            // MARK: - Profile item
            Button{
                withAnimation(.linear){
                    selectedTab = .profile
                }
                
            } label: {
                GeometryReader { geo in
                    VStack{
                        ProfileIconView(image: "profile-img")
                            .frame(width: 26, height: 26)
                            .padding(2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(selectedTab == .profile ? Color.primary : .clear, lineWidth: 2)
                            )
                            .padding(.top)
                            
                    }
                    .frame(width: geo.size.width, height: geo.size.height / 2)
                }
            }
            .disabled(true)
            .accessibilityLabel(selectedTab == .profile ? "Selected, Profile, Tab, 5 of 5." : "Profile, Tab, 5 of 5, Disabled.")
            .accessibilityRemoveTraits(.isButton)
        }
        .frame(height: 52)
        .background()
        .shadow(color: .black.opacity(colorScheme == .light ? 0.1 : 0.0), radius: 15, y: -4)
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.home))
}
