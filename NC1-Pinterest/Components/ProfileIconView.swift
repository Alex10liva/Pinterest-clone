//
//  ProfileIconView.swift
//  NC1-Pinterest
//
//  Created by Alejandro Oliva Ochoa on 15/11/23.
//

import SwiftUI

struct ProfileIconView: View {
    
    // MARK: - Properties
    @State var image: String
    
    
    // MARK: - Body
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
    }
}

#Preview {
    ProfileIconView(image: "img-1")
}
