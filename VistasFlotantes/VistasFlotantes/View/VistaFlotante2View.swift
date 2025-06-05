//
//  VistaFlotante2View.swift
//  VistasFlotantes
//
//  Created by Victor Munera on 3/6/25.
//
import SwiftUI

struct VistaFlotante2View: View {
    
    let textos = [
        "Recomendación 1",
        "Recomendación 2",
        "Recuerda visitar tu farmacia de confianza",
        "Gracias por usar la app",
        "Comparte FarmaGuardia",
        "Estamos para ayudarte",
        "Salud es lo primero"
    ]
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9).ignoresSafeArea()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack() { // negativo para solaparlas como baraja
                    ForEach(0..<textos.count, id: \.self) { index in
                        CardView(texto: textos[index])
                            .frame(width: 280, height: 180)
                            .shadow(radius: 10)
                            .padding(.vertical, 40)
                    }
                }
            }
            .padding(.horizontal, 60)
        }
    }
}

struct CardView: View {
    let texto: String
    
    var body: some View {
        VStack {
            Text(texto)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding()
        }
        .background(.ultraThinMaterial)
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        
    }
}

#Preview {
    VistaFlotante2View()
}
