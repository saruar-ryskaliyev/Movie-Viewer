//
//  Extensions.swift
//  Movie Viewer
//
//  Created by Saruar on 06.06.2023.
//

import Foundation


extension String {
    func capitalizedFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
