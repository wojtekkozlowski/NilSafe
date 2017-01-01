
//  NilSafeTests.swift
//  NilSafeTests
//
//  Created by Wojtek Kozlowski on 01/01/2017.
//  Copyright © 2017 Wojtek Kozlowski. All rights reserved.
//

import XCTest
@testable import NilSafe

extension User: NilSafe {}
extension Account: NilSafe {}
extension Discount: NilSafe {}

class User {
    var name: String!
    var account: Account!
    var alias: String?
}

class Account {
    var amount: Int!
    var discount: Discount?
    var accountType: AccountType!
}

class Discount {
    var amount: Int!
    var text: String!
}

enum AccountType {
    case limited, full
}


class NilSafeTests: XCTestCase {
    
    func testValid_1() {
        let discount = Discount()
        discount.amount = 5
        discount.text = "Hello"
        
        let account = Account()
        account.discount = discount
        account.amount = 5
        account.accountType = .full
        
        let user = User()
        user.name = "joe"
        user.account = account
        
        XCTAssertTrue(user.isNilSafe())
    }
    
    func testInvalid_User_1() {
        
        let discount = Discount()
        discount.amount = 5
        discount.text = "Hello"
        
        let account = Account()
        account.discount = discount
        account.amount = 10
        account.accountType = .full
        
        let user = User()
//        user.name = "joe"
        user.account = account
        
        XCTAssertFalse(user.isNilSafe())
    }
    
    func testInvalid_User_2() {
        
        let discount = Discount()
        discount.amount = 5
        discount.text = "Hello"
        
        let account = Account()
        account.amount = 10
        account.discount = discount
        account.accountType = .full
        
        let user = User()
        user.name = "joe"
//        user.account = account
        
        XCTAssertFalse(user.isNilSafe())
    }
    
    func testInvalid_User_Account_1() {
        
        let discount = Discount()
        discount.amount = 5
        discount.text = "Hello"
        
        let account = Account()
        account.discount = discount
        account.accountType = .full
//        account.amount = 10
        
        let user = User()
        user.name = "joe"
        user.account = account
        
        XCTAssertFalse(user.isNilSafe())
    }
    
    func testInvalid_User_Account_2() {
        
        let discount = Discount()
        discount.amount = 5
        discount.text = "Hello"
        
        let account = Account()
        account.discount = discount
//        account.accountType = .full
        account.amount = 10
        
        let user = User()
        user.name = "joe"
        user.account = account
        
        XCTAssertFalse(user.isNilSafe())
    }
    
    func testInvalid_User_Account_Discounts_text() {
        
        let discount = Discount()
        discount.amount = 5
//        discount.text = "Hello"
        
        let account = Account()
        account.discount = discount
        account.amount = 5
        
        let user = User()
        user.name = "joe"
        user.account = account
        
        XCTAssertFalse(user.isNilSafe())
    }
    
    func testInvalid_User_Account_Discounts_Amount() {
        
        let discount = Discount()
//        discount.amount = 5
        discount.text = "Hello"
        
        let account = Account()
        account.discount = discount
        account.amount = 5
        
        let user = User()
        user.name = "joe"
        user.account = account
        
        XCTAssertFalse(user.isNilSafe())
    }
    
}
