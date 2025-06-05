//
//  ContentView.swift
//  PruebasMapas
//
//  Created by Victor Munera on 7/2/25.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
    static let parking = CLLocationCoordinate2D(
        latitude: 41.531194,
        longitude: 2.184399
    )
}

extension MKCoordinateRegion {
    static let barcelona = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 41.3926386,
            longitude: 2.0577888),
        span: MKCoordinateSpan(
            latitudeDelta: 0.1,
            longitudeDelta: 0.1
        )
    )
    
    static let northCatalonia = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 41.8726787,
            longitude: 3.0825295),
        span: MKCoordinateSpan(
            latitudeDelta: 0.5,
            longitudeDelta: 0.5)
            
    )
}

struct ContentView: View {
    
    @State private var position: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    
    @State private var searchResults: [MKMapItem] = []
    @State private var selectedResult: MKMapItem?
    @State private var route: MKRoute?
    
    var body: some View {
        Map(position: $position, selection: $selectedResult) {
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
            .annotationTitles(.hidden) //Esto hace que sea o no visible
            
            ForEach(searchResults, id: \.self) { result in
                Marker(item: result)
            }
            .annotationTitles(.hidden)
            
            UserAnnotation()
            
            if let route {
                MapPolyline(route)
                    .stroke(.blue, lineWidth: 5)
            }
        }
//        .mapStyle(.hybrid) //Modo hibrido caminos y real. Puedo probar otros
        .mapStyle(.standard(elevation:.realistic)) // modo estandar, cambiando la elevacion
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                VStack(spacing:0){
                    if let selectedResult {
                        ItemInfoView(selectedResult: selectedResult, route: route)
                            .frame(height: 128 )
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding([.top, .horizontal])
                    }
                }
                BeantownButtons(position: $position, searchResults: $searchResults, visibleRegion: visibleRegion)
                    .padding(.top)
                Spacer()
            }
            .background(.thinMaterial)
        }
        .onChange(of: searchResults) {
            position = .automatic
        }
        .onChange(of: selectedResult) {
            getDirections()
        }
        .onMapCameraChange {context in
            visibleRegion = context.region
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
       
    }
    
    func getDirections() {
        route = nil
        guard let selectedResult else {return}
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: .parking))
        request.destination = selectedResult
//        request.transportType = .walking
        
        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            route = response?.routes.first
            
        }
        
    }
}


#Preview {
    ContentView()
}
