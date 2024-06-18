import SwiftUI
import AVFAudio

// create called cards
class CalledCards: ObservableObject {
    @Published var calledCards: [Int] = []
    
    func appendCard(_ cardNum: Int) {
        calledCards.append(cardNum)
    }
    func clearCards() {
        calledCards.removeAll()
    }
    func cardCount() -> Int {
        return calledCards.count
    }
}

// create deck of cards to be shuffled
class CardRoll: ObservableObject {
    @Published var cardNums = Array(1...54)
    @Published var currentCardIndex = 0
    
    func shuffleDeck() {
        cardNums.shuffle()
    }
}


struct ContentView: View {
    @StateObject var calledArray = CalledCards()
    @StateObject var settings = SettingsViewModel()
    @StateObject var cardNums = CardRoll()
    @State var audioPlayer: AVAudioPlayer!
    @State var goToPlay = false
    @State var goToSettings = false
    
    var body: some View {
        let backGradient = LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
        
        NavigationStack {
            ZStack {
                backGradient
                
                // randomize background
                ForEach(0..<10) { _ in
                    Image("\(Int.random(in: 1..<54))")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 2)
                        .rotationEffect(Angle(degrees: Double.random(in: 0...360)))
                        .position(x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                                  y: CGFloat.random(in: 0...UIScreen.main.bounds.height))
                }
                
                VStack {
                    HStack {
                        Text("Lotería Caller!")
                            .font(.system(size: 45, weight: .bold))
                            .bold()
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [.green, .white, .red]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(10)
                            .position(x: 200, y: 100)
                    }
                    // navgation buttons to play and settings
                    NavigationLink(
                        destination: CardView(cardNums: cardNums, calledArray: calledArray, settings: settings),
                        isActive: $goToPlay,
                        label: {
                            Button(action: {
                                playAudio(langChoice: settings.selectedLanguage, number: cardNums.cardNums[cardNums.currentCardIndex])
                                goToPlay = true
                            }) {
                                Text("Play Lotería\nJugar Lotería")
                                    .foregroundColor(.black)
                            }.font(.title).bold()
                                .padding().background(LinearGradient(gradient: Gradient(colors: [.green, .white, .red]), startPoint: .leading, endPoint: .trailing)).cornerRadius(10)
                        }
                    ).position(x:200, y:50)
                    
                    NavigationLink(
                        destination: SettingsView(),
                        isActive: $goToSettings,
                        label: {
                            Button(action: {
                                goToSettings = true
                            }) {
                                Text("Settings")
                                .foregroundColor(.black)
                            }.font(.title).bold()
                            .padding().background(Color.gray).cornerRadius(10)
                        }
                    )
                }
            }
        }
    }
    
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
    ContentView()
}
