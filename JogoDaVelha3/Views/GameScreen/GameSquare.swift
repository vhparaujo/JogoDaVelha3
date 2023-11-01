//
//  GameSquare.swift
//  JogoDaVelha3
//
//  Created by Victor Hugo Pacheco Araujo on 25/10/23.
//

import SwiftUI

struct GameSquare {
  var id: Int
  var player: Player?
  
  var image: Image {
    if let player = player {
      return player.gamePiece.image
    } else {
      return Image("none")
    }
  }
  
  static var reset: [GameSquare] {
    var squares = [GameSquare]()
    
    for index in 1...9 {
      squares.append(GameSquare(id: index))
    }
    return squares
  }
  
}
