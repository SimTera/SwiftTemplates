//
//  ContentView.swift
//  PruebasMapas
//
//  Vista principal que muestra el mapa, las anotaciones, los resultados de búsqueda y rutas.
//  Incluye controles para cambiar la región, buscar lugares y mostrar información detallada.
//
//  ver video youtube de Sean Allen: https://youtu.be/98rQZbwxMFI?si=cCy5554VPoc9x6gp
//  Created by Victor Munera on 7/2/25.
//

import SwiftUI
import MapKit

// MARK: - Extensiones para coordenadas y regiones predefinidas

extension CLLocationCoordinate2D {
    // Coordenada de ejemplo para un parking
    static let parking = CLLocationCoordinate2D(
        latitude: 41.531194,
        longitude: 2.184399
    )
}

extension MKCoordinateRegion {
    // Región centrada en Barcelona
    static let barcelona = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 41.3926386,
            longitude: 2.0577888),
        span: MKCoordinateSpan(
            latitudeDelta: 0.1, // area que cubre el mapa latitud
            longitudeDelta: 0.1 // area que cubre el mapa longitud
        )
    )
    // Región centrada en el norte de Cataluña
    static let northCatalonia = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 41.8726787,
            longitude: 3.0825295),
        span: MKCoordinateSpan(
            latitudeDelta: 0.5,
            longitudeDelta: 0.5)
            
    )
}

// MARK: - Vista principal

struct ContentView: View {
    
    // Estado de la posición de la cámara del mapa (puede ser región, automática, etc.)
    @State private var position: MapCameraPosition = .automatic
    
    // Región visible actual (opcional, se actualiza al mover el mapa)
    @State private var visibleRegion: MKCoordinateRegion?
    
    // Resultados de busqueda (lugares encontrados)
    @State private var searchResults: [MKMapItem] = []
    
    // Resultado seleccionado por el usuario
    @State private var selectedResult: MKMapItem?
    
    // Ruta calculada entre dos puntos (el parking y resultado seleccionado)
    @State private var route: MKRoute?
    
    var body: some View {
        // Vista de mapa principal
        Map(position: $position, selection: $selectedResult) {
            // Anotacion personalizada para el parking
            Annotation("Parking", coordinate: .parking) {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.background)
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.secondary, lineWidth: 5)
                    Image(systemName: "cross")
                        .padding(5)
                }
            }
            .annotationTitles(.hidden) // Oculta el titulo de la anotación
            
            // Muestra un marcador por cada resultado de búsqueda
            ForEach(searchResults, id: \.self) { result in
                Marker(item: result)
            }
            .annotationTitles(.hidden)
            
            // Muestra la ubicacion del usuario
            UserAnnotation()
            
            // Si hay una ruta calculada, la dibuja en el mapa
            if let route {
                MapPolyline(route)
                    .stroke(.blue, lineWidth: 5)
            }
        }
        // Cambia el estilo del mapa (puedes probar otros estilos)
        .mapStyle(.standard(elevation:.realistic))
        // Inserta controles en la parte inferior de la pantalla
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                VStack(spacing:0){
                    // Si hay un resultado seleccionado mostramos la info
                    if let selectedResult {
                        ItemInfoView(selectedResult: selectedResult, route: route)
                            .frame(height: 128 )
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding([.top, .horizontal])
                    }
                }
                // Botones para buscar lugares y mover la cámara
                BeantownButtons(position: $position, searchResults: $searchResults, visibleRegion: visibleRegion)
                    .padding(.top)
                Spacer()
            }
            // Fondo con material translucido para mejorar lectura
            .background(.thinMaterial)
        }
        // Cuando cambian los resultados de busqueda volvemos a la posicion auto
        .onChange(of: searchResults) {
            position = .automatic
        }
        // Cuando cambia el resultado seleccionado, se calcula la ruta
        .onChange(of: selectedResult) {
            getDirections()
        }
        // Se actualiza la región visible al mover el mapa
        .onMapCameraChange {context in
            visibleRegion = context.region
        }
        // Controles nativos del mapa (ubicación, brújula, escala) podemos añadir mas
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
       
    }
    
    // MARK: - Calcula la ruta desde el parking al resultado seleccionado
    func getDirections() {
        route = nil
        guard let selectedResult else {return}
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: .parking))
        request.destination = selectedResult
//        request.transportType = .walking // Puedes descomentar para forzar modo a pie, o probar otros modos
        
        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            route = response?.routes.first // Se guarda la primera ruta calculada
            
        }
        
    }
}


#Preview {
    ContentView()
}
