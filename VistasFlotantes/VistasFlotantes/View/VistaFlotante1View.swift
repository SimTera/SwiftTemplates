//
//  VistaFlotante1View.swift
//  VistasFlotantes
//
//  Created by Victor Munera on 3/6/25.
//
import SwiftUI

struct VistaFlotante1View: View {
    var body: some View {
        ZStack {
            // Fondo degradado
            LinearGradient(
                colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.8)],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            .ignoresSafeArea()
            
            // Vista flotante
            
            VStack(spacing: 16){
                Text("Vista Flotante de Prueba")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("Este componente simula una vista tipo visionOS con fondo borroso y profundidad. La verdad que no lo acabo de ver")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(30)
            .shadow(color: .black.opacity(0.8), radius: 15, x: 0, y: 10)
            // esto de momento bugea y no hace el efecto que deberia por lo tanto lo anulo de momento, si cambio el material de fondo que no sea un material si funciona correctamente
//            .rotation3DEffect(
//                .degrees(10),
//                axis: (x: 1, y: -0.5, z: 0)
//            )
            .padding()
            
        }
    }
}

#Preview {
    VistaFlotante1View()
}
