//
//  ItemInfoView.swift
//  PruebasMapas
//
//  Vista que muestra información detallada del lugar seleccionado y un preview de Look Around.
//
//  ver video youtube de Sean Allen: https://youtu.be/98rQZbwxMFI?si=cCy5554VPoc9x6gp
//  Created by Victor Munera on 7/2/25.
//

import SwiftUI
import MapKit

struct ItemInfoView: View {
    // Lugar seleccionado
    let selectedResult: MKMapItem
    // Ruta calculada (opcional)
    let route: MKRoute?
    
    // Estado para la escena de Look Around (vista previa tipo Street View)
    @State private var lookAroundScene: MKLookAroundScene?
    
    // Calcula el tiempo estimado de viaje en formato legible
    private var travelTime: String? {
        guard let route else { return nil }
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour,.minute]
        return formatter.string(from: route.expectedTravelTime)
    }
    
    // Solicita la escena de Look Around para el lugar seleccionado
    func getLookAroundScene() {
        lookAroundScene = nil
        Task {
            let request = MKLookAroundSceneRequest(mapItem: selectedResult)
            lookAroundScene = try? await request.scene
        }
    }
    
    var body: some View {
        // Vista previa de Look Around
        LookAroundPreview(initialScene: lookAroundScene)
            .overlay(alignment: .bottomTrailing) {
                HStack {
                    // Nombre del lugar
                    Text("\(selectedResult.name ?? "")")
                    // Tiempo estimado de viaje, si existe
                    if let travelTime {
                        Text(travelTime)
                    }
                }
                .font(.caption)
                .foregroundStyle(.white)
                .padding(10)
            }
        // Cuando aparece la vista o cambia el resultado, actualiza la escena
            .onAppear {
                getLookAroundScene()
            }
            .onChange(of: selectedResult) {
                getLookAroundScene()
            }
    }
}
