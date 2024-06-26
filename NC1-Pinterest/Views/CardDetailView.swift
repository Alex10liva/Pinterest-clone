//
//  CardDetailView.swift
//  NC1-Pinterest
//
//  Created by Alejandro Oliva Ochoa on 16/11/23.
//

import SwiftUI

struct CardDetailView: View {
    
    // MARK: - Environment properties
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.openURL) private var openURL
    
    // MARK: - Properties
    var itemReceived: Pin
    @State var openOptionsSheet: Bool = false
    @State private var fullScreenImg: Bool = false
    @State private var scale: CGFloat = 1.0
    @State private var dragOffset: CGSize = .zero
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top){
            Color.colorCardDetailBG
            
            // MARK: - Pin content
            ScrollView{
                ZStack(alignment: .top){
                    if let uiImage = UIImage(data: itemReceived.image){
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .ignoresSafeArea(.all)
                            .scaleEffect(scale)
                            .overlay(
                                LinearGradient(
                                    colors: [.black.opacity(0.4), .clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .frame(height: 250)
                                , alignment: .top
                            )
                            .onTapGesture {
                                // If it has a link open in the website
                                if itemReceived.link != ""{
                                    if let url = URL(string: formatURL(itemReceived.link)) {
                                        openURL(url)
                                    }
                                } else {
                                    // Open the image in full screen
                                    withAnimation(.easeOut) {
                                        fullScreenImg.toggle()
                                    }
                                }
                            }
                            .fullScreenCover(isPresented: $fullScreenImg) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .edgesIgnoringSafeArea(.all)
                                    .offset(y: dragOffset.height) // Apply vertical scrolling
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
                                                // Update dragOffset while the gesture is being performed
                                                if value.translation.height > 0 {
                                                    dragOffset = value.translation
                                                }
                                            }
                                            .onEnded { value in
                                                // Calculate the fraction of the screen
                                                let screenHeight = UIScreen.main.bounds.height
                                                let dragFraction = value.translation.height / screenHeight
                                                
                                                // Defines the fraction required to close the view
                                                let closeThreshold: CGFloat = 0.3 // For example, close when the user drags 30% down
                                                
                                                if dragFraction > closeThreshold {
                                                    withAnimation {
                                                        fullScreenImg = false
                                                        dragOffset = .zero
                                                    }
                                                } else {
                                                    // If it does not reach the threshold, returns the image to its original position
                                                    withAnimation {
                                                        dragOffset = .zero
                                                    }
                                                }
                                            }
                                    )
                            }
                    }
                }
                
                // MARK: - Pin header
                HStack{
                    HStack(spacing: 15){
                        ProfileIconView(image: "profile-img")
                            .frame(height: dynamicTypeSize.customImgSize)
                            .accessibilityHidden(true)
                        
                        VStack(alignment: .leading){
                            Text("Alejandro Oliva")
                            Text("10 followers")
                        }
                        .accessibilityElement(children: .combine)
                        // Dynamic text (Accessibility)
                        .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                    }
                    
                    Spacer()
                    
                    ActionButton(textButton: "Follow", redColor: false)
                        .accessibilityLabel("Follow")
                        .accessibilityAddTraits(.isButton)
                        .accessibilityHint("Double tap to follow this creator.")
                }
                .padding()
                
                // MARK: - Pin title and description
                HStack(){
                    Text(itemReceived.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                    // Dynamic text (Accessibility)
                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack{
                    Text(itemReceived.desc)
                    // Dynamic text (Accessibility)
                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                
                Divider()
                
                HStack{
                    Button{
                        // If it has a link open in the website
                        if itemReceived.link != "" {
                            if let url = URL(string: formatURL(itemReceived.link)) {
                                openURL(url)
                            }
                        } else {
                            // Open the image in full screen
                            withAnimation(.easeOut){
                                fullScreenImg = true
                            }
                        }
                    } label: {
                        ActionButton(textButton: itemReceived.link != "" ? "Visit" : "View", redColor: false)
                    }
                    
                    // Button to save the button (just a placeholder, no action)
                    Button{
                    } label: {
                        ActionButton(textButton: "Save", redColor: true)
                    }
                }
                .padding(.bottom, 50)
            }
            .ignoresSafeArea(.all)
            
            
            // MARK: - Buttons to navigate
            HStack{
                Button{
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(.white)
                        .fontWeight(.heavy)
                        .padding(.vertical, 15)
                        .padding(.horizontal)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                .accessibilityLabel("Back")
                .accessibilityAddTraits(.isButton)
                .accessibilityHint("Double tap to close Pin.")
                
                Spacer()
                
                Button{
                    openOptionsSheet.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.white)
                        .fontWeight(.heavy)
                        .padding()
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        
                }
                .sheet(isPresented: $openOptionsSheet){
                    OptionsCard(pinToDelete: itemReceived, firstSheet: $openOptionsSheet)
                        .presentationDetents([.fraction(0.20)])
                }
                // More options
                .accessibilityLabel("More options")
                .accessibilityAddTraits(.isButton)
            }
            .padding()
            .padding(.top, 10)
        }
        .ignoresSafeArea(.all)
    }
    
    // Function to format the received URL
    func formatURL(_ input: String) -> String {
        if input.hasPrefix("http://") || input.hasPrefix("https://") {
            return input
        } else {
            return "https://" + input
        }
    }
}

#Preview {
    CardDetailView(itemReceived: Pin(image: Data(), title: "Title", desc: "Description", link: ""))
}
