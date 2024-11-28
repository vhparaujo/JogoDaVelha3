//
//  MPPeersView.swift
//  JogoDaVelha3
//
//  Created by Victor Hugo Pacheco Araujo on 26/10/23.
//

import SwiftUI

struct MPPeersView: View {
  @EnvironmentObject var connectionManager: MPConnectionManager
  @EnvironmentObject var game: GameService
  @Binding var startGame: Bool
    var body: some View {
      VStack {
        Text(String(localized: "playersAvailable"))
        List(connectionManager.availablePeers, id: \.self) { peer in
          HStack{
            Text(peer.displayName)
            Spacer()
            Button(String(localized: "select")) {
              game.gameType = .peer
              connectionManager.nearbyServiceBrowser.invitePeer(peer, to: connectionManager.session, withContext: nil, timeout: 30)
                
              game.player1.name = connectionManager.myPeerId.displayName
              game.player2.name = peer.displayName
            }
            .buttonStyle(.borderedProminent)
          }
          .alert(String(localized: "received") + (connectionManager.receivedInviteFrom?.displayName ?? String(localized: "unknown")), isPresented: $connectionManager.receivedInvite) {
            
            Button(String(localized: "reject")) {
              if let invitationHandler = connectionManager.invitationHandler {
                invitationHandler(false, nil)
              }
            }
            
            Button(String(localized: "accept")) {
              if let invitationHandler = connectionManager.invitationHandler {
                invitationHandler(true, connectionManager.session)
                game.player1.name = connectionManager.receivedInviteFrom?.displayName ?? String(localized: "unknown")
                game.player2.name = connectionManager.myPeerId.displayName
                game.gameType = .peer
              }
            }
            
          }

        }
      }
      .onAppear {
        connectionManager.isAvailableToPlay = true
        connectionManager.startBrowsing()
      }
      .onDisappear {
        connectionManager.stopBrowsing()
        connectionManager.stopAdvertising()
        connectionManager.isAvailableToPlay = false
      }
      .onChange(of: connectionManager.paired) { newValue in
        startGame = newValue
      }
      
    }
}

#Preview {
  MPPeersView(startGame: .constant(false))
    .environmentObject(MPConnectionManager(yourName: "teste"))
    .environmentObject(GameService())
}
