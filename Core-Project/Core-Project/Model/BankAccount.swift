//
//  BankAccount.swift
//  Core-Project
//
//  Created by Yveslym on 11/8/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation
import KeychainSwift
import CoreData
struct BankAccount: Codable{
    
    let uid: String
    var link_session_id: String?
    var status: String?
    var request_id: String?
    var institution_id: String?
    var institution_name: String?
    var access_token: String?
    var accounts: [Account]?
    var itemAccess: ItemAccess? = nil
    var transactions: [Transaction]? = nil
    
    enum BankAccountKey: String, CodingKey{
        case institution, accounts, status, request_id, link_session_id, itemAccess,transactions
        enum instutionKey: String, CodingKey{
            case institution_id
            case name
        }
        enum AccountKey: String, CodingKey{
            case id
            case name
        }
    }
}

extension BankAccount{
    init(from decoder: Decoder)throws {
        let BankContenair = try decoder.container(keyedBy: BankAccountKey.self)
        
        self.status = try BankContenair.decodeIfPresent(String.self, forKey: .status)
        self.request_id = try BankContenair.decodeIfPresent(String.self, forKey: .request_id)
        self.link_session_id = try BankContenair.decodeIfPresent(String.self, forKey: .link_session_id)
        
        
       let instutitionContenair = try BankContenair.nestedContainer(keyedBy: BankAccountKey.instutionKey.self, forKey: .institution)
        self.institution_id = try instutitionContenair.decodeIfPresent(String.self, forKey: .institution_id)
        self.institution_name = try instutitionContenair.decodeIfPresent(String.self, forKey: .name)
        self.accounts = try BankContenair.decodeIfPresent([Account].self, forKey: .accounts) ?? nil
        self.uid = UUID().uuidString
    }
    func encode(to encoder: Encoder) throws{
        var contenaire = encoder.container(keyedBy: BankAccountKey.self)
        try contenaire.encode(status, forKey: .status)
        try contenaire.encode(self.request_id, forKey: .request_id)
        try contenaire.encode(link_session_id, forKey: .link_session_id)
        
        try contenaire.encode(accounts, forKey: .accounts)
        try contenaire.encode(itemAccess, forKey: .itemAccess)
        try contenaire.encode(transactions, forKey: .transactions)
        
        
        var institutionContenaire = contenaire.nestedContainer(keyedBy: BankAccountKey.instutionKey.self, forKey: .institution)
        try institutionContenaire.encode(self.institution_id, forKey: .institution_id)
        try institutionContenaire.encode(institution_name, forKey: .name)
    }
}
/// ItemAccess is a struct that contain the item_id, and access tokken
/// which is neccessaire to retrieve data from Api
//struct ItemAccess: Codable {
//    var item_id: String?
//    var access_token: String?
//}
//
///// struct that hold account id and name
///// a single instutition can have multiple accounts
//struct Account: Codable{
//    var id: String?
//    var name: String?
//}














