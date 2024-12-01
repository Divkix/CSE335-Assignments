//
//  WeatherView.swift
//  NomadNavigator
//
//  Created by Divanshu Chauhan on 11/30/24.
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var weatherVM = WeatherViewModel()
    var place: Place?
    
    var body: some View {
        ZStack {
            backgroundView(for: weatherVM.weather?.current.condition.code ?? 1000)
                .edgesIgnoringSafeArea(.all)
            
            if let weather = weatherVM.weather {
                VStack(spacing: 20) {
                    Text(weather.location.name)
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    
                    if let iconURL = URL(string: "https:\(weather.current.condition.icon)") {
                        AsyncImage(url: iconURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    
                    Text("\(Int(weather.current.temp_c))°C")
                        .font(.system(size: 70))
                        .bold()
                    
                    Text(weather.current.condition.text)
                        .font(.title2)
                    
                    HStack {
                        VStack {
                            Text("Wind")
                            Text("\(weather.current.wind_kph, specifier: "%.1f") kph")
                        }
                        Spacer()
                        VStack {
                            Text("Humidity")
                            Text("\(weather.current.humidity)%")
                        }
                        Spacer()
                        VStack {
                            Text("UV Index")
                            Text("\(weather.current.uv, specifier: "%.1f")")
                        }
                    }
                    .padding()
                    .foregroundColor(.white)
                }
                .foregroundColor(.white)
            } else {
                ProgressView()
                    .onAppear {
                        if let place = place {
                            weatherVM.fetchWeather(for: "\(place.coordinate.latitude),\(place.coordinate.longitude)")
                        } else {
                            weatherVM.fetchWeather(for: "auto:ip")
                        }
                    }
            }
        }
    }
    
    func backgroundView(for code: Int) -> some View {
        // Background changes based on weather condition code
        switch code {
        case 1000:
            return LinearGradient(gradient: Gradient(colors: [Color.blue, Color("lightBlue")]), startPoint: .top, endPoint: .bottom)
        case 1003, 1006, 1009:
            return LinearGradient(gradient: Gradient(colors: [Color.gray, Color.black]), startPoint: .top, endPoint: .bottom)
        case 1063, 1150...1189:
            return LinearGradient(gradient: Gradient(colors: [Color("darkGray"), Color.blue]), startPoint: .top, endPoint: .bottom)
        default:
            return LinearGradient(gradient: Gradient(colors: [Color.gray, Color.black]), startPoint: .top, endPoint: .bottom)
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Item.self, inMemory: true)
}

