//
//  ContentView.swift
//  BucketList
//

import SwiftUI
import MapKit


struct ContentView: View {
    
    @State private var viewModel = ViewModel()
    @State private var mapStyleValue = "standard"
    
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 35, longitude: 139),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    
    var body: some View {
        if !viewModel.isUnlocked {
            VStack {
                Picker("マップスタイル", selection: $mapStyleValue) {
                    Text("標準").tag("standard")
                    Text("ハイブリッド").tag("hybrid")
                }
                .pickerStyle(.segmented)
                MapReader { proxy in
                    Map(initialPosition: startPosition) {
                        ForEach(viewModel.locations) { location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .simultaneousGesture(LongPressGesture(minimumDuration: 1).onEnded { _ in viewModel.selectedPlace = location })
                            }
                            
                        }
                    }
                   
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.addLocation(at: coordinate)
                        }
                    }
                    .sheet(item: $viewModel.selectedPlace) { place in
                        EditView(location: place) {
                            viewModel.update(location: $0)
                        }
                    }
                    .mapStyle(mapStyleValue == "standard" ? .standard : .hybrid)
                    
                }
                
            }
        } else {
            Button("Unlock Places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
        }
    }
    
}



#Preview {
    ContentView()
}
