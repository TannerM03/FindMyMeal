//
//  ProfileView.swift
//  MunchMadness
//
//  Created by Tanner Macpherson on 3/17/24.
//

import SwiftUI
import SwiftData


struct ProfileView: View {
    @Environment(\.modelContext) private var context
    @Query private var items: [DataItem]
    
    @Binding var restaurant: RestaurantViewModel?
    
    
    @State private var isSheetShowing: Bool = false
    
    @State private var selectedItem: DataItem?
    
    @Binding var selectedTab: String
    
    @State private var editedNotes: String = ""
    @State private var openEditor: Bool = false
        
    var body: some View {
        
        ZStack {
            VStack {
                Text("Favorites")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .italic()
                    .foregroundStyle(.darkerblue)
                List() {
                    ForEach (items) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                Text("\(item.city), \(item.state ?? "")")
                                    .font(.footnote)
                            }
                            Spacer()
                            ImageView(urlString: item.imageUrl)
                                .frame(width: 50, height: 36)
                                .cornerRadius(5)
                                .padding(.trailing, 10)
                        }.onTapGesture {
                            selectedItem = item
                            editedNotes = selectedItem!.userNotes ?? ""
                        }.sheet(item: $selectedItem) { selectedItem in
                            ZStack {
                                Color.uncBlue.ignoresSafeArea()
                                VStack {
                                    Text(selectedItem.name)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 15)
                                        .padding(.vertical, 10)
                                        .background {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(.white)
                                        }.overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.darkerblue, lineWidth: 3)
                                        )
                                        .padding(.top, 30)
                                        .padding(.bottom, 15)

                                    HStack {
                                        // directions button
                                        Button {
                                            UIApplication.shared.open(URL(string: "http://maps.apple.com/?address=\(String(describing: selectedItem.address1))+\(selectedItem.city)")!)
                                            
                                        } label: {
                                            Text("    Directions")
                                                .frame(width: 110, height: 25)
                                                .background(Color.darkerblue)
                                                .foregroundStyle(.white)
                                                .cornerRadius(20)
                                                .font(.subheadline)
                                                .overlay(
                                                    Circle()
                                                        .frame(width: 25, height: 25)
                                                        .foregroundStyle(.black)
                                                        .padding(.trailing, 85)
                                                )
                                                .overlay(
                                                    Circle()
                                                        .frame(width: 22, height: 22)
                                                        .padding(.trailing, 85)
                                                        .foregroundStyle(.white)
                                                    
                                                        .overlay(
                                                            Image(systemName: "mappin")
                                                                .foregroundStyle(Color.darkerblue)
                                                                .fontWeight(.semibold)
                                                                .font(.footnote)
                                                                .padding(.trailing, 85)
                                                                .foregroundStyle(.black)
                                                        )
                                                )
                                            
                                            
                                        }
                                        //see more button
                                        Button {
                                            UIApplication.shared.open(URL(string: selectedItem.url)!)
                                        }label: {
                                            Text("    See More")
                                                .frame(width: 110, height: 25)
                                                .background(Color.yelpRed)
                                                .foregroundStyle(.white)
                                                .cornerRadius(20)
                                                .font(.subheadline)
                                                .overlay(
                                                    Circle()
                                                        .frame(width: 25, height: 25)
                                                        .foregroundStyle(.black)
                                                        .padding(.trailing, 85)
                                                )
                                                .overlay(
                                                    Circle()
                                                        .frame(width: 22, height: 22)
                                                        .padding(.trailing, 85)
                                                        .foregroundStyle(.white)
                                                    
                                                        .overlay(
                                                            Image(systemName: "chevron.forward.2")
                                                                .foregroundStyle(Color.yelpRed)
                                                                .fontWeight(.semibold)
                                                                .font(.footnote)
                                                                .padding(.trailing, 85)
                                                                .foregroundStyle(.black)
                                                        )
                                                )
                                        }
                                    }.padding(.bottom, 15)
                                    ImageView(urlString: selectedItem.imageUrl)
                                        .frame(width: 275, height: 242)
                                        .cornerRadius(5)
                                        .multilineTextAlignment(.center)
                                        .padding(4)
                                        .background(Color.white)
                                        .shadow(radius: 5)
                                        .padding(.bottom, 7)
                                    
                                    Text("\(selectedItem.city), \(selectedItem.state ?? "")")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .multilineTextAlignment(.center)
                                        .padding(5)
                                        .background {
                                            UnevenRoundedRectangle(topLeadingRadius: 10, topTrailingRadius: 10)
                                                .fill(.white)
                                        }.padding(.bottom, -3)
                                    
                                    HStack {
                                        Image(systemName: "star.fill")
                                            .foregroundStyle(.yellow)
                                        Text(String(format: "%.1f", selectedItem.rating))
                                            .fontWeight(.semibold)
                                        Text("(\(selectedItem.reviewCount)) on Yelp")
                                            .foregroundColor(.secondary)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Text("*")
                                        Text("\(selectedItem.price)")

                                    }.font(.subheadline)
                                        .padding(10)
                                        .background {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(.white)
                                        }
                                    
                                
                                    HStack(alignment: .center) {
                                        Spacer()
                                        VStack() {
                                            Text("My Notes")
                                                .foregroundStyle(Color.white)
                                                .font(.title3)
                                                .padding(.bottom, 5)
                                                .padding(.top, 10)
                                                .fontWeight(.semibold)
                                                .shadow(color: .black, radius: 2)
                                        }
                                        Spacer()
                                            .overlay {
                                                Button {
                                                    openEditor = true
                                                } label: {
                                                    Circle()
                                                        .frame(width: 25, height: 25)
                                                        .foregroundStyle(.black)
                                                        .overlay(
                                                            Circle()
                                                                .frame(width: 22, height: 22)
                                                                .foregroundStyle(Color.white)
                                                            
                                                                .overlay(
                                                                    Image(systemName: "pencil")
                                                                        .foregroundStyle(Color.green)
                                                                        .fontWeight(.semibold)
                                                                        .font(.footnote)
                                                                )
                                                        )
                                                    
                                                }.padding(.leading, 15)
                                                    .padding(.top, 8)
                                            }
                                    }
                                                
                                    
                                    Text(selectedItem.userNotes ?? "")
                                        .multilineTextAlignment(.leading)
                                        .padding(10)
                                        .frame(width: 300, height: 120, alignment: .topLeading)
                                        .background {
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.black, lineWidth: 1)
                                                .fill(Color.white)
                                        }
 

                                    Spacer()
                                }.padding(.horizontal, 20)
                                if openEditor {
                                    Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                                                
                                    VStack {
                                        Text("Edit Notes")
                                            .font(.title)
                                            .padding()
                                                    
                                            TextEditor(text: $editedNotes)
                                                .frame(width: 300, height: 120)
                                                .padding()
                                                .background {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.black, lineWidth: 1)
                                                }
                                                    
                                            Button {
                                                selectedItem.userNotes = editedNotes
                                                do {
                                                    try context.save()
                                                } catch {
                                                    print("rip")
                                                }
                                                openEditor = false
                                            } label: {
                                                Text("Save")
                                                    .fontWeight(.semibold)
                                                    .foregroundStyle(Color.white)
                                                    .padding(.vertical, 8)
                                                    .frame(maxWidth: .infinity)
                                                    .background(Color.green)
                                            }.padding(.top, 15)
                                        
                                    }
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .padding()
                                }
                            }
                            
                        }
                        
                        
                    }.onDelete { indexes in
                        for index in indexes {
                            deleteItem(items[index])
                        }
                    }
                }.scrollContentBackground(.hidden)
                    .background(Color.uncBlue)
                    .padding(.top, -7)
            }
            
        }.onAppear {
            addItem()
        }
    }
    func addItem() {
        if let restaurant = restaurant {
            let item = DataItem(id: restaurant.id, name: restaurant.name, isClosed: restaurant.isClosed, reviewCount: restaurant.reviewCount, imageUrl: restaurant.imageUrl, rating: restaurant.rating, price: restaurant.price, address1: restaurant.address1, city: restaurant.city, state: restaurant.state ?? "", displayPhone: restaurant.displayPhone, distance: restaurant.distance, url: restaurant.url)
                
            if items.contains(where: {$0.id == item.id}) {
                print("already contains this resaurant")
            } else {
                print("added \(item.id)")
                context.insert(item)
            }
        }
        
        
        print(context)
    }
    func deleteItem(_ item: DataItem) {
        context.delete(item)
    }
    func saveNotes(item: DataItem) {
        do {
            try context.save()
        } catch {
            print("rip")
        }
    }
}

//#Preview {
//    ProfileView(restaurant: RestaurantViewModel.example, selectedTab: $selectedTab)
//}
//
