//
//  ContentView.swift
//  Sounds
//
//  Created by Jose Miguel Torres Chavez Nava on 14/04/24.
//

import AVFoundation
import SwiftUI

/// Custom extension for Color class that allow us to choose an Hex Code for any color.
extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        // print(cleanHexCode)
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}

struct ContentView: View {
    
    // Objeto para poder acceder a los métodos de la biblioteca de audio y video.
    @State var player: AVAudioPlayer!
    @State private var isAnimating = false
    @State private var isCorrect = false
    @State private var isWrong = false
    
    // This constant needs to be outside the function "speech"
    let synthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        VStack {
            /* Botones de reproducción de sonido con animación y feedback háptico. */
            HStack {
                Button {
                    playSound(name: "Correct")
                    isCorrect.toggle()
                } label: {
                    Text("Correct")
                        .frame(minWidth: 0.0, maxWidth: .infinity)
                        .fontWeight(.bold)
                        .foregroundColor(isAnimating ? .white : .black)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "868F96"), Color(hex: "596164")]), startPoint: .leading, endPoint: .trailing))
                        .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: isAnimating)
                        .cornerRadius(10)
                        .shadow(color: isAnimating ? .purple : .purple.opacity(0.5), radius: 5, x: 0, y: 0)
                }
                .sensoryFeedback(.success, trigger: isCorrect)
                
                Button {
                    playSound(name: "Wrong")
                    isWrong.toggle()
                } label: {
                    Text("Incorrect")
                        .frame(minWidth: 0.0, maxWidth: .infinity)
                        .fontWeight(.bold)
                        .foregroundColor(isAnimating ? .white : .black)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "868F96"), Color(hex: "596164")]), startPoint: .leading, endPoint: .trailing))
                        .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: isAnimating)
                        .cornerRadius(10)
                        .shadow(color: isAnimating ? .purple : .purple.opacity(0.5), radius: 5, x: 0, y: 0)
                }
                .sensoryFeedback(.error, trigger: isWrong)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            
            /* Text-to-speech */
            Button {
                speech(text: "Ciao, buongiorno!")
                isCorrect.toggle()
            } label: {
                HStack {
                    Image(systemName: "speaker.wave.2.circle")
                    Text("Italian")
                }
                .font(.title3)
                .foregroundStyle(Color.white)
                .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 20))
            }
            .background(Color.gray)
            .cornerRadius(10)
            .sensoryFeedback(.start, trigger: isCorrect)

            Button {
                speech(text: "Hello, good morning!")
                isCorrect.toggle()
            } label: {
                HStack {
                    Image(systemName: "speaker.wave.2.circle")
                    Text("English")
                }
                .font(.title3)
                .foregroundStyle(Color.white)
                .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 20))
            }
            .background(Color.gray)
            .cornerRadius(10)
            .sensoryFeedback(.start, trigger: isCorrect)
            
            Button {
                speech(text: "Hola, ¡buenos días!")
                isCorrect.toggle()
            } label: {
                HStack {
                    Image(systemName: "speaker.wave.2.circle")
                    Text("Spanish")
                }
                .font(.title3)
                .foregroundStyle(Color.white)
                .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 20))
            }
            .background(Color.gray)
            .cornerRadius(10)
            .sensoryFeedback(.stop, trigger: isCorrect)
        }
        .padding()
        .onAppear() {
            isAnimating = true
        }
    }
    
    // Función necesaria para reproducir sonidos:
    func playSound(name: String) {
        let url = Bundle.main.url(forResource: name, withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
    
    // Función para hablar lo que dice de un texto, detectando el lenguaje automáticamente.
    func speech(text: String) {
        if let language = NSLinguisticTagger.dominantLanguage(for: text) {
            // Now we know the language of the text!
            let utterance = AVSpeechUtterance(string: text)
            // We are using the detected language
            utterance.voice = AVSpeechSynthesisVoice(language: language)
            utterance.rate = 0.53
            self.synthesizer.speak(utterance)
        }
    }
}

#Preview {
    ContentView()
}
