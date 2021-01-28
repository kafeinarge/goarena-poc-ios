//
//  BaseViewModel.swift

//
//  Created by mehmet akyol on 5.10.2020.
//

import Foundation
import Combine

protocol ViewState {}

class BaseViewModel {
    var state: ViewState?
    var stateChanged: Notification.Name?
    
    required init() {
        stateChanged = Notification.Name("\(String(describing: self))StateValueChanged")
    }
}

