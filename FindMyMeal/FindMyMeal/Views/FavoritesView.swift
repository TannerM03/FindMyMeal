import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var context
    @Query private var items: [DataItem] = []
    
    @Binding var restaurant: RestaurantViewModel?
    @Binding var selectedTab: String
    
    @State private var selectedItem: DataItem?
    @State private var editedNotes: String = ""
    @State private var openEditor: Bool = false
    @State private var searchTerm: String = ""
    
    @State private var currentPage: Int = 1
    @State private var itemsPerPage: Int = 7
    
    @State private var updateTrigger: Bool = false
    @Binding var didSubmit: Bool
    @Environment(\.presentationMode) var presentationMode
    @State private var instructionsClicked = false


    
    var filteredItems: [DataItem] {
            if searchTerm.isEmpty {
                return items.reversed()
            } else {
                return items.reversed().filter { item in
                    item.name.lowercased().contains(searchTerm.lowercased()) ||
                    item.city.lowercased().contains(searchTerm.lowercased())
                }
            }
        }
    
    var paginatedItems: [DataItem] {
            let startIndex = (currentPage - 1) * itemsPerPage
            let endIndex = min(startIndex + itemsPerPage, filteredItems.count)
            if startIndex < endIndex && startIndex < filteredItems.count {
                return Array(filteredItems[startIndex..<endIndex])
            } else {
                return []
            }
        }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors:[Color.uncBlue, Color.darkerblue]), startPoint: UnitPoint(x: 0.5, y: 0.5), endPoint: .bottom)
            GeometryReader { geometry in
                VStack {
                    if (paginatedItems.count != 0 || !searchTerm.isEmpty) {
                        HStack {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                                selectedTab = "1"
                            }label: {
                                Image(systemName: "house.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(Color.darkerblue)
                                    .padding(.leading, 15)
                            }
                            Spacer()
                            Text("Favorites")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(.darkerblue)
                            Spacer()
                            Button {
                                instructionsClicked = true
                            }label: {
                                Image(systemName: "info.circle")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(Color.darkerblue)
                                    .padding(.trailing, 15)
                            }
                        }
                        .background {
                            Rectangle()
                                .frame(width: 600, height: 200)
                                .foregroundStyle(.white)
                        }
                        TextField("Search by restaurant name or city", text: $searchTerm)
                            .submitLabel(.done)
                            .font(.subheadline)
                            .padding(12)
                            .background(.white)
                            .padding()
                            .shadow(radius: 10)
                            .background {
                                Rectangle()
                                    .frame(width: 500, height: 86)
                                    .foregroundStyle(Color.uncBlue)
                            }.overlay(alignment: .trailing) {
                                Button {
                                    searchTerm = ""
                                }label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(.gray)
                                        .padding(.trailing, 25)
                                }
                            }
                        List() {
                            ForEach(paginatedItems) { item in
                                if (item.name.lowercased().contains(searchTerm.lowercased()) || item.city.lowercased().contains(searchTerm.lowercased()) || searchTerm == "") {
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
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        selectedItem = item
                                        editedNotes = item.userNotes ?? ""
                                    }
                                }
                            }
                            .onDelete { indexes in
                                for index in indexes {
                                    deleteItem(paginatedItems[index])
                                }
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .background(LinearGradient(gradient: Gradient(colors:[Color.uncBlue, Color.darkerblue]), startPoint: UnitPoint(x: 0.5, y: 0.5), endPoint: UnitPoint(x: 0.5, y: getYGradient(for: geometry.size))))
                        .padding(.top, -20)
                        
                        HStack(spacing: 30) {
                            Button {
                                currentPage = 1
                            } label: {
                                Image(systemName: "chevron.left.2")
                            }
                            Button {
                                if currentPage > 1 {
                                    currentPage -= 1
                                }
                            } label: {
                                Image(systemName: "arrow.left")
                            }
                            Text("\(currentPage) of \((filteredItems.count + itemsPerPage - 1) / itemsPerPage)")
                            Button {
                                if ((currentPage * itemsPerPage) < filteredItems.count) {
                                    currentPage += 1
                                }
                            } label: {
                                Image(systemName: "arrow.right")
                            }
                            Button {
                                currentPage = (filteredItems.count + itemsPerPage - 1) / itemsPerPage
                            } label: {
                                Image(systemName: "chevron.right.2")
                            }
                        }.foregroundStyle(Color.white)
                            .padding(.bottom, 30)
                    } else {
                        HStack {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                                selectedTab = "1"
                            }label: {
                                Image(systemName: "house.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(Color.darkerblue)
                                    .padding(.leading, 15)
                            }
                            Spacer()
                            Text("Favorites")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(.darkerblue)
                            Spacer()
                            Button {
                                instructionsClicked = true
                            }label: {
                                Image(systemName: "info.circle")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(Color.darkerblue)
                                    .padding(.trailing, 15)
                            }
                        }
                        .background {
                            Rectangle()
                                .frame(width: 500, height: 122)
                                .foregroundStyle(.white)
                                .padding(.bottom, 50)
                        }
                        
                        Spacer()
                        Text("You don't have any favorites yet :(")
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.trailing, 10)
                        
                        Spacer()
                    }
                    
                }.overlay {
                    if (instructionsClicked) {
                        Color.black.opacity(0.3).ignoresSafeArea()
                            .onTapGesture {
                                instructionsClicked = false
                            }
                        InstructionsView(selectedTab: $selectedTab)
                            .padding(6)
                            .multilineTextAlignment(.leading)
                            .frame(width: 350, height: 435, alignment: .topLeading)
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 1)
                                    .fill(Color.white)
                            }.overlay(alignment: .topTrailing) {
                                Button {
                                    instructionsClicked = false
                                }label: {
                                    Image(systemName: "xmark.circle")
                                        .resizable()
                                        .foregroundStyle(.black)
                                        .frame(width: 25, height: 25)
                                        .padding(.top, 10)
                                        .padding(.trailing, 10)
                                }.padding(.trailing, 15)
                                    .padding(.top, 10)
                            }
                    }
                }
            }
        }
        .sheet(item: $selectedItem) { selectedItem in
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
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.darkerblue, lineWidth: 3)
                        )
                        .padding(.top, 30)
                        .padding(.bottom, 15)
                    
                    HStack {
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
                        Button {
                            UIApplication.shared.open(URL(string: selectedItem.url)!)
                        } label: {
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
                                            Image("yelp_burst")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 18, height: 18)
                                                .fontWeight(.semibold)
                                                .font(.footnote)
                                                .padding(.trailing, 85)
                                                .foregroundStyle(.black)
                                        )
                                )
                        }
                    }
                    .padding(.bottom, 15)
                    
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
                        }
                        .padding(.bottom, -3)
                    
                    HStack {
                        Image(getStarImage(rating: selectedItem.rating))
                            .foregroundStyle(.yellow)
                        Text(String(format: "%.1f", selectedItem.rating))
                            .fontWeight(.medium)
                        Text("(\(selectedItem.reviewCount)) on ")
                            .font(.subheadline)
                            .foregroundStyle(.black)
                            .padding(.leading, -3)
                        Image("yelp_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 20)
                            .padding(.leading, -6)
                        Text("*")
                        Text("\(selectedItem.price)")
                    }
                    .font(.subheadline)
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                    }
                    
                    HStack(alignment: .center) {
                        Spacer()
                        VStack {
                            Text("My Notes")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .shadow(color: .gray, radius: 5)
                                .padding(.bottom, 5)
                                .padding(.top, 10)
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
                                }
                                .padding(.leading, 15)
                                .padding(.top, 8)
                            }
                    }
                    ScrollView {
                        Text(selectedItem.userNotes ?? "No notes yet...")
                            .foregroundStyle(selectedItem.userNotes != nil ? Color.black : Color.gray)
                            .multilineTextAlignment(.leading)
                            .padding(10)
                            .frame(width: 300, alignment: .topLeading)
                    }.frame(height: 120)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 1)
                                .fill(Color.white)
                        }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .foregroundStyle(.black)
                
                if openEditor {
                    Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Text("Edit Notes")
                            .font(.title)
                            .padding()
                        
                        TextEditor(text: $editedNotes)
                            .padding(6)
                            .multilineTextAlignment(.leading)
                            .frame(width: 300, height: 120, alignment: .topLeading)
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 1)
                                    .foregroundStyle(.white)

                            }.overlay {
                                if (editedNotes.isEmpty) {
                                    Text("Click to add notes...")
                                        .frame(width: 300)
                                        .font(.headline)
                                        .foregroundStyle(Color.gray)
                                        .fontWeight(.medium)
                                        .padding(.trailing, 120)
                                        .padding(.bottom, 65)
                                        .allowsHitTesting(false)
                                }
                            }
                        

                        Button {
                            selectedItem.userNotes = editedNotes
                            do {
                                try context.save()
                            } catch {
                            }
                            openEditor = false
                        } label: {
                            Text("Save")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.white)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                        }
                        .padding(.top, 15)
                    }
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding()
                }
            }
        }.onAppear {
            if (didSubmit) {
                addItem()
            }
        }
    }
    
    func getStarImage(rating: Double) -> String {
        let ratingInt = (rating * 2).rounded() / 2
        switch ratingInt {
        case 0:
            return "yelp0Star"
        case 0.5:
            return "yelp0.5Star"
        case 1:
            return "yelp1Star"
        case 1.5:
            return "yelp1.5Star"
        case 2:
            return "yelp2Star"
        case 2.5:
            return "yelp2.5Star"
        case 3:
            return "yelp3Star"
        case 3.5:
            return "yelp3.5Star"
        case 4:
            return "yelp4Star"
        case 4.5:
            return "yelp4.5Star"
        case 5:
            return "yelp5Star"
        default:
            return ""
        }
    }
    
    func getYGradient(for size: CGSize) -> CGFloat {
        return size.width > 400 ? 1.09 : 1.1
    }
    
    func addItem() {
        didSubmit = false
            if let restaurant = restaurant {
                let item = DataItem(
                    id: restaurant.id,
                    name: restaurant.name,
                    isClosed: restaurant.isClosed,
                    reviewCount: restaurant.reviewCount,
                    imageUrl: restaurant.imageUrl,
                    rating: restaurant.rating,
                    price: restaurant.price,
                    address1: restaurant.address1,
                    city: restaurant.city,
                    state: restaurant.state ?? "",
                    displayPhone: restaurant.displayPhone,
                    distance: restaurant.distance,
                    url: restaurant.url
                )
                
                if items.contains(where: { $0.id == item.id }) {
                } else {
                    context.insert(item)
                }
            }
        }
    
    func deleteItem(_ item: DataItem) {
        context.delete(item)
        do {
            try context.save()
            updateTrigger.toggle()
            } catch {
            }
    }
}
