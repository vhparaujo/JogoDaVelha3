//
//  MPGameMove.swift
//  JogoDaVelha3
//
//  Created by Victor Hugo Pacheco Araujo on 26/10/23.
//

import Foundation

struct MPGameMove: Codable {
  enum Action: Int, Codable {
    case start, move, reset, end
  }
  
  let action: Action
  let playerName: String?
  let index: Int?
  
  func data() -> Data? {
    try? JSONEncoder().encode(self)
  }
  
}
