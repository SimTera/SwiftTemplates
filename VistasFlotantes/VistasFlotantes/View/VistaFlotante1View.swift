//
//  VistaFlotante1View.swift
//  VistasFlotantes
//
//  Vista de ejemplo con fondo degradado y un panel flotante central.
//  Inspirada en el estilo de VisionOS, usando material borroso y profundidad visual.
//
//  Created by Victor Munera on 3/6/25.
//
import SwiftUI

struct VistaFlotante1View: View {
    var body: some View {
        ZStack {
            // Fondo degradado de azul a purpura que cubre toda la pantalla
            LinearGradient(
                colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.8)],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            .ignoresSafeArea()
            
            // Panel flotante central
            
            VStack(spacing: 16){
                Text("Vista Flotante de Prueba")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("Este componente simula una vista tipo visionOS con fondo borroso y profundidad. La verdad que no lo acabo de ver")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
            .background(.ultraThinMaterial) // Efecto borroso tipo visionOS
            .cornerRadius(30)
            .shadow(color: .black.opacity(0.8), radius: 15, x: 0, y: 10)
            
//            .rotation3DEffect( // Comentado: puede dar problemas visuales con el material
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
