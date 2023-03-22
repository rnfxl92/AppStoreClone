//
//  MockUserDefault.swift
//  AppStoreTests
//
//  Created by 박성민 on 2023/03/22.
//

import Foundation

class MockUserDefaults: UserDefaults {
  var gameStyleChanged = 0
  override func set(_ value: Int, forKey defaultName: String) {
   
  }
}
