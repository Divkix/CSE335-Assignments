//
// Name:        Divanshu Chauhan
// Date:        9/25/24
// Description: A wallet app where user can add their car information
//              and then add it their wallet.
//

import SwiftUI

// CardType enum
enum CardType: String, CaseIterable, Identifiable {
    case visa = "VISA"
    case mastercard = "Mastercard"
    case amex = "Amex"
    case discover = "Discover"
    
    var id: String { self.rawValue }
}

// CardColor enum
enum CardColor: String, CaseIterable, Identifiable {
    case red, green, blue, black
    
    var id: String { self.rawValue }
    
    var color: Color {
        // switch-case for color
        switch self {
        case .red:
            return Color(red: 240/255, green: 84/255, blue: 84/255)
        case .green:
            return Color(red: 47/255, green: 93/255, blue: 98/255)
        case .blue:
            return Color(red: 44/255, green: 116/255, blue: 179/255)
        case .black:
            return Color(red: 38/255, green: 40/255, blue: 41/255)
        }
    }
}



// Card details class conforming to ObservableObject
class CardDetails: ObservableObject {
    static private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        return formatter
    }()
    
    // Variables used to store card details
    @Published var holderName: String = ""
    @Published var bank: String = ""
    @Published var type: CardType = .visa
    @Published var number: String = ""
    @Published var validity: Date = Date()
    @Published var secureCode: String = ""
    @Published var color: CardColor = .blue
    
    var formattedValidity: String {
        Self.dateFormatter.string(from: validity)
    }
}

struct CardInputView: View {
    @StateObject private var cardDetails = CardDetails()
    
    var body: some View {
        NavigationView {
            ZStack{
                ScrollView {
                    VStack(spacing: 5) {
                        // Signature Section
                        SectionView(header: "SIGNATURE") {
                            VStack(alignment: .leading){
                                Text("Cardholder Name")
                                TextField("Enter Cardholder Name Here", text: $cardDetails.holderName)
                            }
                            VStack(alignment: .leading){
                                Text("Bank Name")
                                TextField("Enter Bank Name Here", text: $cardDetails.bank)
                            }
                            HStack {
                                VStack{
                                    Text("Card Type")
                                    Picker("", selection: $cardDetails.type) {
                                        ForEach(CardType.allCases, id: \.self) { type in
                                            Text(type.rawValue).tag(type)
                                        }
                                    }
                                }
                                VStack{
                                    Text("Expiry Date")
                                    DatePicker("", selection: $cardDetails.validity, displayedComponents: .date)
                                }
                            }
                        }

                        // Card Information Section
                        SectionView(header: "CARD INFORMATION") {
                            VStack(alignment: .leading){
                                Text("Card Number")
                                TextField("Enter Card Number Here", text: $cardDetails.number)
                                    .keyboardType(.numberPad)
                                    // Check if the card is amex, card number would be 15 digits, else 16
                                    .onReceive(cardDetails.number.publisher.collect()) { newValue in
                                        let amexDigits = 15;
                                        let otherDigits = 16;
                                        
                                        if cardDetails.type == .amex {
                                            if newValue.count > amexDigits {
                                                cardDetails.number = String(newValue.prefix(amexDigits))
                                            }
                                        } else {
                                            if newValue.count > otherDigits {
                                                cardDetails.number = String(newValue.prefix(otherDigits))
                                            }
                                        }
                                    }
                            }
                            VStack(alignment: .leading){
                                Text("Security Code")
                                TextField("Enter CVV Here", text: $cardDetails.secureCode)
                                    .keyboardType(.numberPad)
                                    // Check if the card is amex, cvv would be 4 digits, else 3
                                    .onReceive(cardDetails.number.publisher.collect()) { newValue in
                                        let amexDigits = 4;
                                        let otherDigits = 3;
                                        
                                        if cardDetails.type == .amex {
                                            if newValue.count > amexDigits {
                                                cardDetails.number = String(newValue.prefix(amexDigits))
                                            }
                                        } else {
                                            if newValue.count > otherDigits {
                                                cardDetails.number = String(newValue.prefix(otherDigits))
                                            }
                                        }
                                    }
                            }
                            VStack(alignment: .leading){
                                Text("Card Color")
                                HStack {
                                    ForEach(CardColor.allCases) { color in
                                        Text(color.rawValue.capitalized)
                                            .padding()
                                            .background(cardDetails.color == color ? color.color : Color.clear)
                                            .foregroundColor(cardDetails.color == color ? .white : .primary)
                                            .cornerRadius(8)
                                            .onTapGesture {
                                                cardDetails.color = color
                                            }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }.frame(maxWidth: .infinity)
                        }

                        // Preview Button
                        NavigationLink(destination: CardPreviewView(cardDetails: cardDetails)) {
                            Text("Add Card To Wallet")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                        }
                        .padding(.horizontal)

                        Spacer()
                    }
                    .padding()
                }
                .navigationBarTitle("Add Card", displayMode: .inline)
            }
        }
    }
}

// Special Section View
struct SectionView<Content: View>: View {
    let header: String
    let content: Content
    
    init(header: String, @ViewBuilder content: () -> Content) {
        self.header = header
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(header)
                .font(.headline)
                .padding(.bottom, 5)
            content
                .padding()
                .background(Color.white)
                .cornerRadius(8)
        }.background(Color.white)
    }
}

// Custom Input Field View
struct InputField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var maxLength: Int? = nil
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .autocapitalization(.words)
                .disableAutocorrection(true)
                .onReceive(text.publisher.collect()) { newValue in
                    if let max = maxLength, newValue.count > max {
                        text = String(newValue.prefix(max))
                    }
                }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// Custom picker selection for 
struct PickerSelectionView<T: Identifiable & Hashable>: View {
    var title: String
    @Binding var selection: T
    var options: [T]

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
            Menu {
                ForEach(options) { option in
                    Button(action: {
                        selection = option
                    }) {
                        Text(option is CardType ? (option as! CardType).rawValue : "\(option)")
                    }
                }
            } label: {
                HStack {
                    Text(selection is CardType ? (selection as! CardType).rawValue : "\(selection)")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
            }
        }
        .padding(.horizontal)
    }
}

// View for card preview (Unchanged)
struct CardPreviewView: View {
    @ObservedObject var cardDetails: CardDetails
    
    var body: some View {
        ScrollView { // Added ScrollView for better handling on smaller screens
            ZStack {
                // Background with selected color gradient
                RoundedRectangle(cornerRadius: 10)
                    .fill(cardDetails.color.color) // Access the color property here
                    .frame(width: 400, height: 250)
                
                VStack(alignment: .leading, spacing: 12) { // Adjusted spacing for better separation
                    // Top row for Bank and Card Type
                    HStack {
                        Text(cardDetails.bank.isEmpty ? "Bank's Name" : cardDetails.bank)
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                        Spacer()
                        Text(cardDetails.type.rawValue)
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                    }
                    .padding([.top, .horizontal, .bottom])
                    Spacer(minLength: 10)
                    
                    // Card Holder Name
                    Text(cardDetails.holderName.isEmpty ? "Card Holder's Name" : cardDetails.holderName)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    // Validity and Security Code
                    HStack {
                        Text("Valid Thru: \(cardDetails.formattedValidity)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                        
                        Spacer(minLength: 5)
                        Text("Secure Code: \(cardDetails.secureCode)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    .padding([.horizontal,.bottom])
                    
                    // Card Number
                    Text(cardDetails.number.isEmpty ? "1234567890123456" : cardDetails.number)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                }
                .frame(width: 400, height: 250, alignment: .topLeading)
            }
        }
    }
}

// ContentView that holds the CardInputView
struct ContentView: View {
    var body: some View {
        CardInputView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
