import SwiftUI
import MapKit

struct AddTripView: View {
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var location = ""
    @State private var detailedLocation = ""
    
    var onSave: (Trip) -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Location")) {
                    TextField("Enter trip location", text: $location)
                    TextField("Enter detailed address", text: $detailedLocation)
                }
                
                Section(header: Text("Dates")) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Add New Trip")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if !location.isEmpty {
                            let newTrip = Trip(startDate: startDate, endDate: endDate, location: location, detailedLocation: detailedLocation)
                            onSave(newTrip)
                        }
                    }
                    .disabled(location.isEmpty)
                }
            }
        }
    }
}
