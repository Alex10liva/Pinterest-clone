//
//  ScrollGridView.swift
//  NC1-Pinterest
//
//  Created by Alejandro Oliva Ochoa on 14/11/23.
//

import SwiftUI
import SwiftData

struct ScrollPinsGrid: View {
    
    // MARK: - Properties
    var pins: [Pin]
    var nColumns: Int = 2
    var columns = [ColumnPins]()
    @State private var pinToShow: Pin?
    
    
    // MARK: - Init
    init(pins: [Pin], nColumns: Int) {
        self.pins = pins
        self.nColumns = nColumns
        self.columns = organizeInColumns()
    }
    
    // MARK: - Body
    var body: some View {
        // MARK: - Scrollview
        HStack (alignment: .top, spacing: 10){
            ForEach(columns){ column in
                LazyVStack(spacing: 10){
                    // MARK: - Pin content
                    ForEach(column.columnContent) { pin in
//                        if(pin.pinContent.link != "") {
//                            Link(destination: URL(string: formatURL(pin.pinContent.link))!, label: {
//                                CardView(receivedPin: pin.pinContent)
//                            })
//                            .accessibilityLabel("Link from Alejandro Oliva to \(pin.pinContent.link)")
//                            .accessibilityHint("Double tap to open it.")
//                            .accessibilityRemoveTraits(.isLink)
//                        } else {
                            Button{
                                pinToShow = pin.pinContent
                            } label: {
                                // MARK: - Card view for each pin
                                CardView(receivedPin: pin.pinContent)
                            }
                            .sheet(item: $pinToShow){ pin in
                                CardDetailView(itemReceived: pin)
                                    .presentationCornerRadius(30)
                            }
                            .accessibilityLabel(pin.pinContent.title != "" ? "Pin from Alejandro Oliva. Title: \(pin.pinContent.title)" : "Pin from Alejandro Oliva.")
                            .accessibilityHint("Double tap to open it.")
                            .accessibilityRemoveTraits(.isButton)
//                        }
                    }
                }//: LazyVStack
            }//: ForEach
        }//: HStack
        .padding(.horizontal, 10)
    }
    
    // MARK: - Functions
    // Function to format the received URL
    func formatURL(_ input: String) -> String {
        if input.hasPrefix("http://") || input.hasPrefix("https://") {
            return input
        } else {
            return "https://" + input
        }
    }
    
    // Function to organize in columns all the pins
    func organizeInColumns() -> [ColumnPins] {
        var columns = [ColumnPins]()
        var voiceOverOrder = pins.count
        
        for _ in 0 ..< nColumns {
            columns.append(ColumnPins())
        }
        
        for (index, pin) in pins.enumerated() {
            let columnIndex = index % nColumns
            let pinWithOrder = PinWOrder(pinContent: pin, orderVO: voiceOverOrder)
            columns[columnIndex].columnContent.append(pinWithOrder)
            voiceOverOrder -= 1
        }
        
        return columns
    }
}

#Preview {
    ScrollPinsGrid(pins: [Pin(image: Data(), title: "", desc: "", link: "")], nColumns: 2)
}
