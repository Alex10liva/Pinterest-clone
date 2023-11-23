//
//  UpdateSheetView.swift
//  NC1-Pinterest
//
//  Created by Alejandro Oliva Ochoa on 17/11/23.
//

import SwiftUI

struct UpdateSheetView: View {
    
    // MARK: - Environment properties
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    // MARK: - Properties
    @Bindable var pin: Pin
    
    // MARK: - Body
    var body: some View{
        NavigationStack{
            // MARK: - Card image
            if let uiImage = UIImage(data: pin.image){
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            // MARK: - Title field
            VStack(alignment: .leading){
                Text("Title")
                    .font(.caption)
                // Dynamic text (Accessibility)
                .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                
                
                TextField(
                    "Tell everyone what your Pin is about",
                    text: $pin.title
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
                    text: $pin.desc
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
                    text: $pin.link
                )
                .keyboardType(.URL)
                // Dynamic text (Accessibility)
                .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
            }
            
            Divider()
                .padding(.top, 5)
                .padding(.bottom, 10)
        }
        .padding(.horizontal)
    }
}

#Preview {
    UpdateSheetView(pin: Pin(image: Data(), title: "", desc: "", link: ""))
}
