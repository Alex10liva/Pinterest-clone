//
//  CardView.swift
//  NC1-Pinterest
//
//  Created by Alejandro Oliva Ochoa on 14/11/23.
//

import SwiftUI
import SwiftData

struct CardView: View {
    
    // MARK: - Environment properties
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    @State var openOptionsSheet: Bool = false
    
    
    // MARK: - Properties
    var receivedPin: Pin
    
    // MARK: - Body
    var body: some View {
        // MARK: - Card
        VStack{
            // MARK: - Card image
            if let uiImage = UIImage(data: receivedPin.image){
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            HStack (alignment: .top){
                // MARK: - Card title
                Text(receivedPin.title)
                    .foregroundStyle(.primary)
                    .font(.footnote)
                    .padding(.top, 5)
                    .truncationMode(.tail)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                // Dynamic text (Accessibility)
                    .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                
                Spacer()
                
                // MARK: - Card button
                VStack{
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.primary)
                }
                .padding(.top, 10)
                .padding(.horizontal, 10)
                .padding(.bottom, dynamicTypeSize.customPadding - 8)
                .onTapGesture {
//                    deleteItem(pinToDelete: receivedPin)
                    openOptionsSheet.toggle()
                }
                .sheet(isPresented: $openOptionsSheet){
                    OptionsCard(pinToDelete: receivedPin, firstSheet: $openOptionsSheet)
                        .presentationCornerRadius(30)
                        .presentationDetents([.fraction(0.20)])
                }
                
            }
            .padding(.horizontal, 5)
        }//: Card
    }
}

#Preview {
    CardView(receivedPin: Pin(image: Data(), title: "Title", desc: "Desc", link: ""))
        .padding()
}
