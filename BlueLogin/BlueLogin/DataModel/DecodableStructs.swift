//
//  NetworkManager.swift
//  BlueLogin
//
//  Created by Andres Guevara Caprio on 8/17/20.
//  Copyright © 2020 Andres Guevara Caprio. All rights reserved.
//

import Foundation

struct UserResult : Decodable {
    var results : [UserInfo]
}

struct UserInfo: Decodable {
    var gender : String
    var name : UserName
    var location : UserLocation
    var email : String
    var login : UserLogin
    var registered : UserRegisteredDate
    var phone : String
    var picture : UserPicture
}

struct UserName : Decodable {
    var title : String
    var first : String
    var last : String
}

struct UserLocation : Decodable {
    var street : StreetInfo
    var city : String
    var state : String
    var country : String
}

struct StreetInfo : Decodable {
    var number : Int
    var name : String
}

struct UserLogin : Decodable{
    var password : String
}

struct UserRegisteredDate : Decodable {
    var date : String
}

struct UserPicture : Decodable{
    var medium : String
}


