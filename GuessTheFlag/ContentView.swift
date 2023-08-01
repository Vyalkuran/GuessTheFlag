//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by sebastian.popa on 8/1/23.
//

import SwiftUI

struct ContentView: View {
    @State private var flagAlert = false
    @State private var refreshAlert = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var questionsAsked = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var answerMessage = ""
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                VStack(spacing: 15){
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Button("Refresh the score!"){
                    confirmRefreshScore()
                }
                .buttonStyle(.bordered)
                .background(.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 3)
                .alert("Do you want to start a new game session?", isPresented: $refreshAlert){
                    Button("Yes", role: .destructive, action: refreshScore)
                    Button("No", role: .cancel) {}
                }
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $flagAlert) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(answerMessage + "\nYour score is \(score) out of \(questionsAsked)")
        }
    }
    
    func flagTapped(_ number: Int){
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong"
        }
        answerMessage = "\(scoreTitle)! That's the flag of \(countries[number])."
        questionsAsked += 1
        flagAlert = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    func confirmRefreshScore(){
        refreshAlert = true
    }
    func refreshScore() {
        askQuestion()
        score = 0
        questionsAsked = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
