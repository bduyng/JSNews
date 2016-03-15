//
//  UserSettings.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 3/14/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import Foundation

struct SettingsConstants {
    struct Author {
        // use to find correct section in didSelectRowAtIndexPath
        static let headerTitle = "AUTHOR" // must check in Main.storyboard :(
        struct Twitter {
            // use to find correct cell in didSelectRowInAuthorSection
            static let accessibilityIdentifier = "Twitter"  // must check in Assets.xcassets :(
            static let url = "https://twitter.com/bduyng"
        }
        struct Github {
            static let accessibilityIdentifier = "Github"  // must check in Assets.xcassets :(
            static let url = "https://github.com/bduyng"
        }
        struct Email {
            static let accessibilityIdentifier = "Email"  // must check in Assets.xcassets :(
            static let url = "mailto://bduyng@gmail.com?subject=Feedback%20from%20JSNews"
        }
    }
    
    struct TextSize {
        static let key = "TextSize"
        static let headerTitle = "TEXT SIZE" // must check in Main.storyboard : (
        struct Small {
            static let key = "Small"
            static let value = 15.0
        }
        struct Medium {
            static let key = "Medium"
            static let value = 17.0
        }
        struct Large {
            static let key = "Large"
            static let value = 19.0
        }
    }
    
    struct EnterReaderModeFirst {
        static let key = "EnterReaderModeFirst"
    }
}

struct UserSettings {
    static var TextSize: Double! {
        didSet {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setDouble(TextSize, forKey: "TextSize")
        }
    }
    
    static var EnterReaderModeFirst: Bool! {
        didSet {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(EnterReaderModeFirst, forKey: "EnterReaderModeFirst")
        }
    }
    
}