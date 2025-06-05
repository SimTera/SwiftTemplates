//
//  VistaFlotanteScroll.swift
//  VistasFlotantes
//
//  Created by Victor Munera on 3/6/25.
//
import SwiftUI

struct VistaFlotanteScroll: View {
    @State private var selectedCard: Int = 0 // Carta seleccionada al inicio

    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.mint, Color.blue],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            .ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .leading, spacing: 24) {
                    
                    // 🟦 Sección normal en vertical
                    Text("Bienvenido a Pruebas de Vistas Flotantes")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)
                    
                    Text("Aquí tienes algunas recomendaciones y vistas flotantes")
                        .font(.subheadline)
                        .padding(.horizontal)
                    CartaView(texto: "Primera carta")
                        .padding(.horizontal)
                    CardView(texto: "Otra esta viene de otro proyecto")
                        .padding(.horizontal)
                    CartaView(texto: "Con un par de líneas de texto para que se vea más largo")
                        .padding(.horizontal)
                    CartaView(texto: "otra")
                        .padding(.horizontal)
                    CartaView(texto: "Y otra")
                        .padding(.horizontal)
                    
                    // 🟥 Sección con scroll horizontal
                    Text("Vistas tipo cartas")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(0..<10) { i in
                                CartaView(texto: "Carta \(i)")
                            }
                        }
                        .padding(.horizontal)
                        //                    Al meter el padding horizontal tengo que darle el frame de la altura al scroll vertical para que quepa el elemento, un poco mas de lo que ocupa la carta y su sombra
                        .frame(height: 180)
                    }
                    
                    // 🟨 Otra sección vertical
                    Text("Más contenido...")
                        .font(.headline)
                        .padding(.horizontal)
                    CartaView(texto: "otra")
                        .padding(.horizontal)
                    CartaView(texto: "Y otra")
                        .padding(.horizontal)
                    
                    // Un scroll horizontal pero con movimiento
                    Text("Cartas apiladas dinamicamente...")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: -60) {
                            // espacio antes de la primera carta
                            Spacer()
                                .frame(width: UIScreen.main.bounds.width / 2 - 100)
                            ForEach(0..<10) { i in
                                GeometryReader { geo1 in
                                    CartaView(texto: "Carta \(i)")
                                        .rotation3DEffect(
                                            .degrees(Double(geo1.frame(in: .global).minX - 30) / -15),
                                            axis: (x: 0, y: 1, z: 0)
                                        )
                                        .scaleEffect(getScale1(geo1: geo1))
                                        .opacity(getOpacity1(geo1: geo1))
                                }
                                .frame(width: 200, height: 180) // 👈 IMPORTANTE
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Estructura tipo Grid
                    
                    Text("Vista tipo grid")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)

                    let columnas = [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ]

                    LazyVGrid(columns: columnas, spacing: 20) {
                        ForEach(0..<10) { i in
                            CartaView(texto: "Grid \(i)")
                        }
                    }
                    .padding()
                    
                    // Scroll horizontal carta central mas grande
                    
                    Text("Vista horizontal la carta central crecerá con el scroll")
                        .font(.title2)
                        .bold()
                        .padding()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(0..<10) { i in
                                GeometryReader { geo in
                                    CartaView(texto: "Carta \(i)")
                                        .scaleEffect(getScale(geo: geo))
                                        .opacity(getOpacity(geo: geo))
                                        .zIndex(getZIndex(geo: geo)) // 👈 Esto es opcional para que la central esté "por encima"
                                }
                                .frame(width: 200, height: 140)
                            }
                            
                        }
                        .padding(.horizontal, UIScreen.main.bounds.width / 2 - 100) // 👈 Esto es clave para que se centren todas las cartas
                        .frame(height: 160)
                    }
                    
                    // Probando Scroll lateral mas centrado y ampliado como con iman
                    Text("Scroll lateral con centrado como con iman")
                        .font(.title2)
                        .bold()
                        .padding()
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                // espacio antes de la primera carta
                                Spacer()
                                    .frame(width: UIScreen.main.bounds.width / 2 - 100)
                                // lista de cartaas
                                ForEach(0..<10) { i in
                                    GeometryReader { geo in
                                        let frame = geo.frame(in: .global)
                                        let screenCenter = UIScreen.main.bounds.width / 2
                                        let diff = abs(screenCenter - frame.midX)
                                        let scale = max(0.9, 1 - diff / 300)
                                        let isCenter = diff < 20
                                        
                                        CartaView(texto: "Carta \(i)")
                                            .scaleEffect(scale)
                                            .opacity(Double(max(0.4, 1 - diff / 400)))
                                            .background(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .stroke(isCenter ? Color.blue : Color.clear, lineWidth: 4)
                                                    .animation(.easeInOut(duration: 0.2), value: isCenter)
                                            )
                                            .blur(radius: diff > 150 ? 1.5 : 0)
                                            .offset(y: isCenter ? -10 : 0)
                                            .animation(.spring(response: 0.4, dampingFraction: 0.75), value: scale)
                                            .onTapGesture {
                                                selectedCard = i
                                                withAnimation(.spring()) {
                                                    proxy.scrollTo(i, anchor: .center)
                                                }
                                            }
                                            .id(i)
                                    }
                                    .frame(width: 200, height: 140)
                                }
                                // 👉 Espacio después de la última carta
                                            Spacer()
                                                .frame(width: UIScreen.main.bounds.width / 2 - 100)
                            }
                            .padding(.horizontal)
                            .frame(height: 180)
                        }
                        .onAppear {
                            DispatchQueue.main.async {
                                proxy.scrollTo(selectedCard, anchor: .center)
                            }
                        }
                    }
                    // probando control de cambios
                }
                .padding(.vertical)
            }
        }
    }
}

struct CartaView: View {
    let texto: String
    
    var body: some View {
        VStack {
            Text(texto)
                .font(.headline)
                .padding()
        }
        .frame(width: 200, height: 140)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .shadow(color: .black.opacity(0.75), radius: 5, x: 0, y: 10)
    }
}
// Funciones para hacer la vista tipo carta que se mueve
func getScale1(geo1: GeometryProxy) -> CGFloat {
    let midX = geo1.frame(in: .global).midX
    let screenMidX = UIScreen.main.bounds.width / 2
    let diff = abs(screenMidX - midX)
    let scale = max(0.9, 1 - diff / 500)
    return scale
}

func getOpacity1(geo1: GeometryProxy) -> Double {
    let midX = geo1.frame(in: .global).midX
    let screenMidX = UIScreen.main.bounds.width / 2
    let diff = abs(screenMidX - midX)
    let opacity = Double(max(0.5, 1 - diff / 400))
    return opacity
}

// Funciones para que se levante la carta del medio que se haga mas grande
func getScale(geo: GeometryProxy) -> CGFloat {
    let midX = geo.frame(in: .global).midX
    let screenMidX = UIScreen.main.bounds.width / 2
    let diff = abs(screenMidX - midX)
    let scale = max(0.9, 1 - diff / 300) // 👈 central 1.0, lados 0.9
    return scale
}

func getOpacity(geo: GeometryProxy) -> Double {
    let midX = geo.frame(in: .global).midX
    let screenMidX = UIScreen.main.bounds.width / 2
    let diff = abs(screenMidX - midX)
    return Double(max(0.5, 1 - diff / 400))
}

func getZIndex(geo: GeometryProxy) -> Double {
    let midX = geo.frame(in: .global).midX
    let screenMidX = UIScreen.main.bounds.width / 2
    return 1 - Double(abs(screenMidX - midX) / 500)
}


#Preview {
    VistaFlotanteScroll()
}

// otra vez problemas con github jajaja
// Ahora creo que no me guarda los cambios...

