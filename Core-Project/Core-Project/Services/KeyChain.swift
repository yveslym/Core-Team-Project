//
//  KeyChain.swift
//  Core-Project
//
//  Created by Yveslym on 11/13/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation
import KeychainSwift

struct KeyChainData{
    static func setUpKeyChain(){
       let keychain = KeychainSwift()
        keychain.set("8bb4e37cb6ad720c4b2ab3c6107ce7", forKey: "publicKey")
        keychain.set("5a0e10dfbdc6a46838fe6283", forKey: "clientId")
        keychain.set("a2c5ff8e5fa75701955d548d79bbe9", forKey: "secret")
    }
    
    static func publicKey()->String{
        return KeychainSwift().get("publicKey")!
    }
    
    static func clientId()-> String{
        return KeychainSwift().get("clientId")!
    }
    static func secret()-> String{
        return KeychainSwift().get("secret")!
    }
}
