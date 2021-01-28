//
//  BaseBuilder.swift
//  facelab
//
//  Created by Serhat Akalin on 11.08.2020.
//  Copyright © 2020 Lyrebird Studio. All rights reserved.
//

import UIKit

enum AppStoryboards: String {
    case main = "Main"
}

struct StoryBoard {
    static let main = UIStoryboard(name: AppStoryboards.main.rawValue, bundle: nil)
}

class BaseBuilder: NSObject { }

extension BaseBuilder {
    class func instantiate<T: UIViewController>(appStoryboard: AppStoryboards, viewController: String) -> T {
        let storyboard = UIStoryboard(name: appStoryboard.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: viewController) as! T
    }
}
