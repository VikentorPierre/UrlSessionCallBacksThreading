//
//  Models.swift
//  CallbacksThreading
//
//  Created by Vikentor Pierre on 4/27/18.
//  Copyright © 2018 mosDev. All rights reserved.
//

import Foundation

// MARK:- setup the get model object
struct Users:Decodable{
    var id:Int
    var name:String
    var username:String
    var email:String
    var address:Address
    var phone:String
    var website:String
    var company:Company
}
struct Company: Decodable{
    var name:String
    var catchPhrase:String
    var bs:String
}
struct Address: Decodable{
    var street:String
    var suite:String
    var city:String
    var zipcode:String
    var geo:Geo
}
struct Geo:Decodable{
    var lat:String
    var lng:String
}
// MARK:- setup the post model object
struct Post: Codable{
    let userId:Int?
    let id:Int?
    let title:String?
    let body:String?
}
