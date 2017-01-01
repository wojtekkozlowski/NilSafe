
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

    func testValid() {
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

    func testArrayValid_1() {

        class B: NilSafe {
            var c: String!
        }

        class A: NilSafe {
            var bs: [B]!
        }

        let a = A()
        let b = B()
        b.c = "required"
        a.bs = [b]

        XCTAssertTrue(a.isNilSafe())
    }

    func testArrayInvalid_Array_Element_has_nil_property() {

        class B: NilSafe { var c: String! }
        class A: NilSafe { var bs: [B]! }

        let a = A()
        let b = B()
        //        b.c = "required"
        a.bs = [b]

        XCTAssertFalse(a.isNilSafe())
    }

    func testArrayValid_empty_array() {

        class B: NilSafe { var c: String! }
        class A: NilSafe { var bs: [B]! }

        let a = A()
        a.bs = []

        XCTAssertTrue(a.isNilSafe())
    }

    func testArrayValid_Optional() {

        class B: NilSafe { var c: String! }
        class A: NilSafe { var bs: [B]? }

        let a = A()

        XCTAssertTrue(a.isNilSafe())
    }

    func testArray_Optional_But_Element_has_nil_property() {

        class B: NilSafe { var c: String! }
        class A: NilSafe { var bs: [B]? }

        let a = A()
        a.bs = [B()]

        XCTAssertFalse(a.isNilSafe())
    }

    func testArray_Optional_But_Nasted_Element_has_nil_property() {

        class C: NilSafe { var c: String! }
        class B: NilSafe { var cs: [C]! }
        class A: NilSafe { var bs: [B]? }

        let a = A()
        let b = B()
        b.cs = [C()]
        a.bs = [b]

        XCTAssertFalse(a.isNilSafe())
    }

    func testArray_Optional_Nasted_Elements() {

        class C: NilSafe { var str: String! }
        class B: NilSafe { var cs: [C]! }
        class A: NilSafe { var bs: [B]? }

        let a = A()
        let b = B()
        let c = C()
        c.str = "required"
        b.cs = [c]
        a.bs = [b]

        XCTAssertTrue(a.isNilSafe())
    }
}
