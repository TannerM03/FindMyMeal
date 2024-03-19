//
//  FilterView.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 3/17/24.
//

import SwiftUI

struct FilterView: View {
    @State private var distance = 0
    @State private var price = 0
    @State private var price2 = 0
    @State private var price3 = 0
    @State private var price4 = 0

    private var strPrice = ""
    @State private var isEditing = false
    @State private var openNow = true
    @State private var userMood = ""
    @State private var isSwiperViewActive = false
    @ObservedObject var vm = RestaurantListViewModel()
    var body: some View {
        NavigationStack {
            //title
            Text("Filters")
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
            
            //link to swiper view
            NavigationLink(destination: SwiperView(vm: vm), isActive: $isSwiperViewActive) {
                            EmptyView()
                        }
                        .hidden()
            VStack {
                //add the ability to set location
                //get distance parameter
                Text("How far are you willing to go?")
                Picker("Distance", selection: $distance) {
                    ForEach(0...25, id: \.self) { mile in
                        Text("\(mile) Miles").tag(mile)
                    }
                }.padding(.bottom, 15)
                //get price range
                Text("What's your price range?")
                Slider(
                    value: Binding<Double>(
                            get: { Double(price) },
                            set: { price = Int($0) }
                        ),
                    in: 1...4,
                    step: 1,
                    onEditingChanged: { editing in
                        isEditing = editing
                    }
                ).padding(.horizontal, 30)
                Text("Price: \(priceString())")
                    .padding(.bottom, 15)
                
                //get terms
                Text("What are you in the mood for?")
                TextField("ex: fast food, breakfast, chinese", text: $userMood)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 15)
                //get whether they want it to be open
                Toggle("Only show open restaurants", isOn: $openNow)
                    .padding(.horizontal, 40)
                
                //submit button that takes you to SwiperView()
                Button(action: {
                    vm.term = userMood
                    vm.getPlaces(with: userMood, price: price, price2: 2, price3: 3, price4: 4, radius: distance)
                    isSwiperViewActive = true
                }, label: {
                    Text("Submit")
                })
            }
            Spacer()
        }
        
        
        
        /*Filters needed
        location (coordinates)
        term (what's ur mood)
        distance
        price
        openNow?
        */
        
    }
    func priceString() -> String {
            switch price {
                case 4:
                    return "$$$$"
                case 3:
                    return "$$$"
                case 2:
                    return "$$"
                default:
                    return "$"
            }
        }
    
}



#Preview {
    FilterView()
}
