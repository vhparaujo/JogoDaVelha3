//
//  GameView.swift
//  JogoDaVelha3
//
//  Created by Victor Hugo Pacheco Araujo on 25/10/23.
//

import SwiftUI

struct GameView: View {
  @EnvironmentObject var game: GameService
  @EnvironmentObject var connectionManager: MPConnectionManager
  @Environment(\.dismiss) var dismiss
  
    var body: some View {
      
      VStack {
       
        if [game.player1.isCurrent, game.player2.isCurrent].allSatisfy({ $0 == false}) {
          Text(String(localized: "selectPlayerKey"))
        }
        HStack{
          
          Button(game.player1.name) {
            game.player1.isCurrent = true
            if game.gameType == .peer {
              let gameMove = MPGameMove(action: .start, playerName: game.player1.name, index: nil)
              connectionManager.send(gameMove: gameMove)
            }
          }
          .buttonStyle(PlayerButtonStyle(isCurrent: game.player1.isCurrent))
         
          Button(game.player2.name) {
            game.player2.isCurrent = true
            if game.gameType == .bot {
              Task {
                await game.deviceMove()
              }
            }
            
            if game.gameType == .peer {
              let gameMove = MPGameMove(action: .start, playerName: game.player2.name, index: nil)
              connectionManager.send(gameMove: gameMove)
            }
            
          }
          .buttonStyle(PlayerButtonStyle(isCurrent: game.player2.isCurrent))
          
        }.disabled(game.gameStarted)
          .padding()
        
        VStack {
          HStack{
            ForEach(0...2, id: \.self) { index in
              SquareView(index: index)
            }
          }
          HStack{
            ForEach(3...5, id: \.self) { index in
              SquareView(index: index)
            }
          }
          HStack{
            ForEach(6...8, id: \.self) { index in
              SquareView(index: index)
            }
          }
          
        }
        
        .overlay {
          if game.isThinking {
            VStack {
              Text(String(localized: "thinkingKey"))
                .foregroundStyle(Color(.systemBackground))
                .background(Rectangle().fill(Color.primary))
              ProgressView()
            }
          }
          
        }
        
        .disabled(game.boardDisabled || game.gameType == .peer && connectionManager.myPeerId.displayName != game.currentPlayer.name)
        
        VStack{
          if game.gameOver {
            Text(String(localized: "gameOverKey"))
            
            if game.possibleMoves.isEmpty {
              Text(String(localized: "drawKey"))
            } else {
              Text(game.currentPlayer.name + String(localized: "winsKey"))
            }
            Button(String(localized: "newGameKey")) {
              game.reset()
              if game.gameType == .peer {
                let gameMove = MPGameMove(action: .reset, playerName: nil, index: nil)
                connectionManager.send(gameMove: gameMove)
              }
            }
            .buttonStyle(.borderedProminent)
            
          }
        }.font(.largeTitle)
        
        Spacer()
        
      }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button(String(localized: "endGameKey")){
            dismiss()
            if game.gameType == .peer {
              let gameMove = MPGameMove(action: .end, playerName: nil, index: nil)
              connectionManager.send(gameMove: gameMove)
            }
            
          }
          .buttonStyle(.bordered)
        }
        
      }
      
      .navigationTitle(String(localized: "tictactoe3Key"))
      .onAppear {
        game.reset()
        if game.gameType == .peer {
          connectionManager.setup(game: game)
        }
      }
      .inNavigationStack()
      
    }
}

#Preview {
  GameView()
    .environmentObject(GameService())
    .environmentObject(MPConnectionManager(yourName: "Victor"))
}
