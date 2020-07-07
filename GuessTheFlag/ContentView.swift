//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Sabesh Bharathi on 23/06/20.
//  Copyright © 2020 Sabesh Bharathi. All rights reserved.
//

import SwiftUI

struct FlagImage: View {
    var number: Int
    var countries: [String]
    var body: some View {
            Image(countries[number])
                .renderingMode(.original)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                .shadow(color: .black, radius: 2)
        }
}


struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
        .shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var score = 0
    @State private var isCorrect = -1
    @State private var turn = 0.0
    @State private var scale: CGFloat = 1
    var body: some View {
        
        ZStack {
            Color.blue
            .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                
                Spacer()
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                        .bold()
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        VStack {
                            if self.isCorrect == 1 {
                                VStack {
                                    if number == self.correctAnswer {
                                    FlagImage(number: number, countries: self.countries)
                                        .rotation3DEffect(.degrees(self.turn), axis: (x: 0, y: 1, z: 0))
                                        .animation(.default)
                                    } else {
                                    FlagImage(number: number, countries: self.countries)
                                        .opacity(0.25)
                                    }
                                }
                            } else if self.isCorrect == 0 {
                                FlagImage(number: number, countries: self.countries)
                                    .scaleEffect(self.scale)
                                    .animation(.interpolatingSpring(stiffness: 250, damping: 1))
                            }
                            else {
                                FlagImage(number: number, countries: self.countries)
                            }
                        }
                    }
                }
                Spacer()
                Text("Your score : \(score)")
                    .foregroundColor(.white)
                    .bold()
                Spacer()
                Button(action: {
                    self.score = 0
                }) {
                    Text("Reset")
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .bold()
                }
                Spacer()
            }
            .alert(isPresented: $showingScore) {
                Alert(title: Text(scoreTitle),
                      message: Text(scoreMessage),
                      dismissButton: .default(Text("Continue")) {
                        self.askQuestion()
                    } )
            }
        }
        
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        isCorrect = -1
        scale = 1
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            scoreMessage = "Your score is \(score)"
            isCorrect = 1
            withAnimation {
                turn += 360
            }
        } else {
            scoreMessage = "This is the flag of \(countries[number]). Your score is \(score)"
            scoreTitle = "Wrong"
            isCorrect = 0
            withAnimation{
                scale = 1.05
            }
        }
        showingScore = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
