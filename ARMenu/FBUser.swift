//
//  FBUser.swift
//  ARMenu
//
//  Created by Eren Cicek on 23.02.22.
//

import Foundation

/// The User object created when the user authenticates.
public struct FBUser: Codable {
    public let uid: String
    public var name: String
    let email: String
    // App Specific properties can be added here
    /// The FBUser object
    /// - Parameters:
    ///   - uid: the UserID
    ///   - name: the name provided
    ///   - email: the email address provided
   public init(uid: String, name: String, email: String) {
        self.uid = uid
        self.name = name
        self.email = email
    }
}
