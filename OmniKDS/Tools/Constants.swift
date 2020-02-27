//
//  Constants.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 11/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//
import Foundation

let GlobalKitchenID = 1111
let GlobalAdminUserID = 9999
let kNotReachable = 0
let kReachableViaWiFi = 1
let kReachableViaWWAN = 2
let kReachable = 3
let kReachabilityChangedNotification = "kNetworkReachabilityChangedNotification"
let kDidChangeOrderContentNotification = "DidChangeOrderContent"
let kSomeItemStateDidChangeNotification = "SomeItemStateDidChangeNotification"
let kDidArriveNewDocketNotification = "DidArriveNewDocketNotification"
let kDidUpdateUsersDBNOtification = "DidUpdateUsersDBNOtification"

struct NIK { //network interchange keys
    
//    let GlobalKitchenID = 1111
    static let SYNC_ACTION = "SYNC_ACTION"
    static let SYNC_ACTION_KITCHEN_DOCKETS = "SYNC_ACTION_KITCHEN_DOCKETS"
    static let SIGNATURE = "58df8b0c36d6982b82c3ecf6b4662e34fe8c25bba48f5369f135bf843651c3a4"
    static let AUTH = "AUTH"
    static let MESSAGE = "MESSAGE"
}

enum DBError : Error{
    case NoObjectFound
    case CorruptedObject
    case UnknownError
}

enum RowType{
    
    case RowTypeBool
    case RowTypeText
    case RowTypeColor
    case RowTypeSegment
    case RowTypeSlider
    case RowTypeList
}

