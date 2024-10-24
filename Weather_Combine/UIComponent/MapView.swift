//
//  MapView.swift
//  Weather_Combine
//
//  Created by wjdyukyung on 10/24/24.
//

import SwiftUI
import MapKit

class MapViewCoordinator: NSObject, MKMapViewDelegate {
    var parent: MapView

    init(parent: MapView) {
        self.parent = parent
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 애너테이션 처리 로직
        return nil
    }
}

struct MapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D

    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(parent: self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // 업데이트 로직
    }
}
