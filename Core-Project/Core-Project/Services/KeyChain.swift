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
        keychain.set("a26bacd40a288d215735a0cfcb1508", forKey: "publicKey")
        keychain.set("59f67b2ebdc6a40e54b2fffc", forKey: "clientId")
        keychain.set("adaaa3eaf89ada326158673d2595b2", forKey: "secret")
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
