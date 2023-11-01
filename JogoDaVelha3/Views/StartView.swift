//
//  ContentView.swift
//  JogoDaVelha3
//
//  Created by Victor Hugo Pacheco Araujo on 24/10/23.
//

import SwiftUI

struct StartView: View {
  
  @EnvironmentObject var game: GameService
  @StateObject var connectionManager: MPConnectionManager
  @State private var gameType: GameType = .undetermined
  @AppStorage("yourName") var yourName = ""
  @State private var opponentName = ""
  @FocusState private var focus: Bool
  @State private var startGame = false
  @State private var changeName = false
  @State private var newName = ""
  
  init(yourName: String) {
    self.yourName = yourName
    _connectionManager = StateObject(wrappedValue: MPConnectionManager(yourName: yourName))
  }
  
  var body: some View {
    VStack {
//      ScrollView {
        
        Picker(String(localized: "selectGameLabel"), selection: $gameType) {
          
          Text(String(localized: "selectGameTypeLabel")).tag(GameType.undetermined)
          Text(String(localized: "twoSharingLabel")).tag(GameType.single)
          Text(String(localized: "challengeDeviceLabel")).tag(GameType.bot)
          Text(String(localized: "challengeFriendLabel")).tag(GameType.peer)
          
        }.padding()
          .background(RoundedRectangle(cornerRadius: 10)
            .stroke(lineWidth: 2))
        Text(gameType.description).padding()
        
        VStack{
          switch gameType {
          case .single:
            TextField(String(localized: "opponentNameKey"), text: $opponentName)
          case .bot:
            EmptyView()
          case .peer:
            MPPeersView(startGame: $startGame)
              .environmentObject(connectionManager)
          case .undetermined:
            EmptyView()
          }
        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .focused($focus)
        .frame(width: 350)
        
        if gameType != .peer {
          Button(String(localized: "startKey")) {
            game.setupGame(gameType: gameType, player1Name: yourName, player2Name: opponentName)
            focus = false
            startGame.toggle()
          }
          .buttonStyle(.borderedProminent)
          .disabled(
            gameType == .undetermined ||
            gameType == .single && opponentName.isEmpty
          )
          
          Image("LaunchScreen")
            .resizable()
            .scaledToFit()
            .frame(width: 200)
            .padding()
          Text(String(localized: "YourNameIsKey") + yourName)
          
          Button(String(localized: "changeName")) {
            changeName.toggle()
          }.buttonStyle(.bordered)
            .padding()
          
          
        }
        
        Spacer()
//      }
    }
    .padding()
    .navigationTitle(String(localized: "tictactoe3Key"))
    .fullScreenCover(isPresented: $startGame){
      GameView().environmentObject(connectionManager)
    }
    
    .alert(String(localized: "changeName"), isPresented: $changeName, actions: {
      TextField(String(localized: "newName"), text: $newName)
      Button("OK", role: .destructive) {
        yourName = newName
//        exit(-1) // force quit
      }
      Button(String(localized: "cancelKey"), role: .cancel) {}
    }, message: {
      Text(String(localized: "messageChangeName"))
    })
    
    .inNavigationStack()
    
    .onTapGesture {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
  }
}

#Preview {
  StartView(yourName: "Messi").environmentObject(GameService())
}
