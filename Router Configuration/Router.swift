//
//  Router.swift
//  Router Configuration
//
//  Created by Lara Orlandic on 7/20/17.
//  Copyright © 2017 Lara Orlandic. All rights reserved.
//

import Foundation


class Router {
    
    // A text description of this item.
    var text: String
    
    // A Boolean value that determines the clicked state of this item.
    var clicked: Bool
    
    // Returns a ToDoItem initialized with the given text and default completed value.
    init(text: String) {
        self.text = text
        self.clicked = false
    }
    
}
