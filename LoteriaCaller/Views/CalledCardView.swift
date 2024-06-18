import SwiftUI

struct CalledCardView: View {
    @ObservedObject var calledArray: CalledCards
    
    var body: some View {
        let backGradient = LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
        
        // create tab of scrolling cards
        if calledArray.cardCount() > 0 {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(0..<calledArray.cardCount(), id: \.self) { rowIndex in
                        Image("\(calledArray.calledCards[rowIndex])")
                            .resizable()
                            .aspectRatio(contentMode: .fit).cornerRadius(15).shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 2)
                            .frame(width: 400, height: 500)
                    }
                }
            }
            .background(backGradient)
            .navigationBarTitle("Called Cards/Cartas llamadas", displayMode: .inline).bold().font(.title)
        }
        else {
            // if none have been called display message
            ZStack {
                backGradient
                VStack {
                    Text("No called cards!\n¡Aún no se han llamado cartas!")
                        .font(.title).bold().shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 2).padding().foregroundColor(.black).cornerRadius(10)
                    
                }
            }
        }
    }
}


#Preview {
    CalledCardView(calledArray: CalledCards())
}
