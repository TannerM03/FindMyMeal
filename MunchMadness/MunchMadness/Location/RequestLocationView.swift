//
//  RequestLocationView.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 3/19/24.
//

import SwiftUI

struct RequestLocationAccessView: View {
    @ObservedObject var locationManager: LocationManager
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack() {
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
                    .padding(.bottom, 5)
                Text("We will use your location to display restaurants near you")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 300)
                    .padding(.bottom, 10)
                Button {
                    locationManager.requestLocationAccess()
                } label: {
                    Text("Allow access")
                }
            }
        }
    }
}
