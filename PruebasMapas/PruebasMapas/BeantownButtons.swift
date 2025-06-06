//
//  BeantownButtons.swift
//  PruebasMapas
//
//  Componente de botones que permiten hacer búsquedas en el mapa
//  o mover la cámara a regiones específicas predefinidas.
//  ver video youtube de Sean Allen: https://youtu.be/98rQZbwxMFI?si=cCy5554VPoc9x6gp
//  Created by Victor Munera on 7/2/25.
//

import SwiftUI
import MapKit

struct BeantownButtons: View {
    // Referencia al estado de la posicion de la cámara del mapa
    @Binding var position: MapCameraPosition
    // Resultados de la busqueda actual en el mapa
    @Binding var searchResults: [MKMapItem]
    // Region visible del mapa (opcional)
    var visibleRegion: MKCoordinateRegion?

    var body: some View {
        HStack {
            // Boton para buscar parque infantil "playground" en la zona visible
            Button {
                search(for: "playground")
            } label: {
                Label("Playground", systemImage: "figure.and.child.holdinghands")
            }
            .buttonStyle(.borderedProminent)
            
            // Boton para buscar playa "beach"
            Button {
                search(for: "beach")
            } label: {
                Label("Beach", systemImage: "beach.umbrella")
            }
            .buttonStyle(.borderedProminent)
            
            // Boton para mover la camara a Barcelona
            Button {
                position = .region(.barcelona)
            } label: {
                Label("Barcelona", systemImage: "building.2")
            }
            .buttonStyle(.bordered)
            
            // Boton para mover la camara al norte de Cataluña
            Button {
                position = .region(.northCatalonia)
            } label: {
                Label("North Catalonia", systemImage: "water.waves")
            }
            .buttonStyle(.bordered)
        }
        .labelStyle(.iconOnly) // Solo mostrar icono en los botones, sin el nombre
       
    }
    
    // Funcion que realiza una busqueda local con un texto dado
    func search(for query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        
        // Si no hay region visible, se usa una region por defecto centrada en un parking
        request.region = visibleRegion ?? MKCoordinateRegion(
            center: .parking,
            span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125))
        
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            searchResults = response?.mapItems ?? []
        }
    }
    
}


