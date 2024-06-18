//
//  CardView.swift
//  LoteriaCaller
//
//  Created by Ruben Reyes on 4/11/24.
//

import SwiftUI
import AVFoundation


struct CardView: View {
    @State var completelyCalled = false
    @State var goToCalled = false
    @StateObject var cardNums: CardRoll
    @StateObject var calledArray: CalledCards
    @ObservedObject var settings: SettingsViewModel
    @State var audioPlayer: AVAudioPlayer!
    
    var body: some View {
        let backGradient = LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
        
        NavigationStack {
            ZStack {
                backGradient
                VStack {
                    
                    // Making image a button
                    Button(action: {
                        if calledArray.cardCount() == 54 {
                            completelyCalled = true
                        }
                        else {
                            
                        playAudio(langChoice: settings.selectedLanguage, number: cardNums.cardNums[(cardNums.currentCardIndex + 1) % 54])
                        calledArray.appendCard(cardNums.cardNums[cardNums.currentCardIndex])
                            rotateToNextCard()
                        }
                    })
                    {
                        Image("\(cardNums.cardNums[cardNums.currentCardIndex])")
                            .resizable()
                            .aspectRatio(contentMode: .fit).cornerRadius(15).shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 2)
                            .frame(width: 400, height: 500)
                            .rotationEffect(.degrees(0))
                    }
                    // reset rotation
                    .rotation3DEffect(.degrees(0), axis: (x: 0, y: 1, z: 0))
                    
                    
                    //Displaying card name
                    Text(loteriaCards[cardNums.cardNums[cardNums.currentCardIndex]] ?? "").foregroundStyle(.black).font(.largeTitle.bold()).shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 2).multilineTextAlignment(.center).fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    
                    
                    // Shuffling cards and emptying called cards
                    Button("Shuffle Deck", action: {
                        cardNums.shuffleDeck()
                        calledArray.clearCards()
                        playAudio(langChoice: settings.selectedLanguage, number: cardNums.cardNums[cardNums.currentCardIndex])
                    }).font(.title).bold().shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 2).padding().foregroundColor(.white).background(Color.red).cornerRadius(10)
                    
                    
                }
            }
        }
        // button to go to called card view
        .toolbar {
                Button(role: .destructive, action: {
                    goToCalled = true
                }) {
                    Text("View Called Cards").foregroundColor(.blue)
                }
            }
        
        // restarting if all cards were called
            .alert("All cards have been called!", isPresented: $completelyCalled) {
                Button("Restart", role: .cancel, action: {
                    cardNums.shuffleDeck()
                    calledArray.clearCards()
                    playAudio(langChoice: settings.selectedLanguage, number: cardNums.cardNums[cardNums.currentCardIndex])
                })
        }
        
        // navigating to called cards view
        .navigationDestination(isPresented: $goToCalled, destination: {
            CalledCardView(calledArray: calledArray)
        } )
    }
    
    // card rotation function
    private func rotateToNextCard() {
        withAnimation(.easeInOut(duration: 0.5)) {
            cardNums.currentCardIndex = (cardNums.currentCardIndex + 1) % 54 
        }
    }
    
    // function for audio clip
    private func playAudio(langChoice: String, number: Int) {
        let fileName = "\(langChoice)\(number)"

        if let soundURL = Bundle.main.url(forResource: fileName, withExtension: "MP3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer.play()
            } catch {
                print("Error playing audio: \(error.localizedDescription)")
            }
        } else {
            print("Audio file not found for \(fileName)")
        }
    }

}

#Preview {
    CardView(cardNums: CardRoll(), calledArray: CalledCards(), settings: SettingsViewModel())
}
