//
//  +DynamicTypeSize.swift
//  NC1-Pinterest
//
//  Created by Alejandro Oliva Ochoa on 16/11/23.
//

import Foundation
import SwiftUI

extension DynamicTypeSize{
    
    var customMinScaleFactor: CGFloat {
        switch self {
        case .xSmall, .small, .medium:
            return 1.0
        case .large, .xLarge, .xxLarge:
            return 0.5
        default:
            return 0.6
        }
    }
    
    var customPadding: CGFloat {
        switch self {
        case .xSmall, .small, .medium:
            return 15.0
        case .large, .xLarge, .xxLarge, .xxxLarge, .accessibility1, .accessibility2, .accessibility3:
            return 35.0
        default:
            return 45.0
        }
    }
    
    var customImgSize: CGFloat{
        switch self {
        case .xSmall, .small, .medium:
            return 45.0
        case .large, .xLarge, .xxLarge, .xxxLarge, .accessibility1, .accessibility2, .accessibility3:
            return 60.0
        default:
            return 70.0
        }
    }
    
    var customImgProfileSize: CGFloat{
        switch self {
        case .xSmall, .small, .medium:
            return 100.0
        case .large, .xLarge, .xxLarge, .xxxLarge, .accessibility1, .accessibility2, .accessibility3:
            return 110.0
        default:
            return 115.0
        }
    }
}
