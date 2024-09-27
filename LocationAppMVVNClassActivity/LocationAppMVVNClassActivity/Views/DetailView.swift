import SwiftUI

struct DetailView: View {
    @ObservedObject var viewModel: LocationViewModel
    @State private var city: String
    @State private var state: String
    @Environment(\.presentationMode) var presentationMode
    
    init(viewModel: LocationViewModel) {
        self.viewModel = viewModel
        _city = State(initialValue: viewModel.location.city)
        _state = State(initialValue: viewModel.location.state)
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Update Location")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            
            VStack(spacing: 15) {
                TextField("Edit City", text: $city)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                
                TextField("Edit State", text: $state)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Button(action: {
                viewModel.location = Location(city: city, state: state)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Update Location")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            Spacer()
        }
        .navigationTitle("Detail View")
        .navigationBarTitleDisplayMode(.inline)
    }
}
