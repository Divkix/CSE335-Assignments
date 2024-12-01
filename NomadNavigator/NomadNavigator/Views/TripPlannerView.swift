import SwiftUI
import MapKit

struct TripPlannerView: View {
    @State private var trips: [Trip] = []
    @State private var isAddingTrip = false
    @State private var selectedTrip: Trip? = nil

    let tripsKey = "savedTrips"

    var body: some View {
        NavigationView {
            List {
                ForEach(trips) { trip in
                    VStack(alignment: .leading) {
                        Text(trip.location)
                            .font(.headline)
                        Text("From: \(formattedDate(trip.startDate)) To: \(formattedDate(trip.endDate))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        selectedTrip = trip
                    }
                }
                .onDelete(perform: deleteTrip)
            }
            .navigationTitle("Trip Planner")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddingTrip = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingTrip) {
                AddTripView { newTrip in
                    trips.append(newTrip)
                    saveTrips()
                    isAddingTrip = false
                }
            }
            .sheet(item: $selectedTrip) { trip in
                TripMapView(trip: trip)
            }
        }
        .onAppear(perform: loadTrips)  // Load trips when the view appears
    }

    func deleteTrip(at offsets: IndexSet) {
        trips.remove(atOffsets: offsets)
        saveTrips()
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    // MARK: - Persistence Functions

    func saveTrips() {
        if let encoded = try? JSONEncoder().encode(trips) {
            UserDefaults.standard.set(encoded, forKey: tripsKey)
        }
    }

    func loadTrips() {
        if let savedTrips = UserDefaults.standard.data(forKey: tripsKey),
           let decodedTrips = try? JSONDecoder().decode([Trip].self, from: savedTrips) {
            trips = decodedTrips
        }
    }
}
