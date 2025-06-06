//
//  VistaFlotante2View.swift
//  VistasFlotantes
//
//  Ejemplo de scroll horizontal con tarjetas tipo carta, usando material borroso y sombras.
//
//  Created by Victor Munera on 3/6/25.
//
import SwiftUI

struct VistaFlotante2View: View {
    
    // Lista de textos para las tarjetas
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
            // Fondo oscuro para resaltar las tarjetas
            Color.black.opacity(0.9).ignoresSafeArea()
            
            // Scroll horizontal de tarjetas
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

// Vista reutilizable para cada tarjeta
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
