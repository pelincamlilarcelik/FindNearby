//
//  String+Extension.swift
//  FindNearby
//
//  Created by Onur Celik on 13.03.2023.
//

import Foundation
extension String{
    var formattedPhoneNumber: String{
        self.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "+", with: "")
        
    }
}
