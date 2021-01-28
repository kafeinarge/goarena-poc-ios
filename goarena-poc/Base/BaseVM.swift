//
//  BaseVM.swift
//  goarena-poc
//
//  Created by serhat akalin on 27.01.2021.
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
