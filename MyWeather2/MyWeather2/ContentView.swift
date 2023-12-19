import SwiftUI

struct CityWeather {
    var name: String
    var temperature: Int
    var high: Int
    var low: Int
    var description: String
}

// Sample data
let citiesWeather = [
    CityWeather(name: "Montreal, Canada", temperature: 19, high: 24, low: 18, description: "Mid Rain"),
    CityWeather(name: "Istanbul, Turkey", temperature: 23, high: 27, low: 20, description: "Sunny"),
    // Add more cities as needed
]


struct WeatherData: Codable {
    let main: Main
    let weather: [Weather]
    let name: String

    struct Main: Codable {
        let temp: Double
    }

    struct Weather: Codable {
        let description: String
        let icon: String
    }
}


// Define a simple model for districts
struct District {
    var name: String
}

// Sample data for all districts in Istanbul
let districts = [
    District(name: "Adalar"),
    District(name: "Arnavutköy"),
    District(name: "Ataşehir"),
    District(name: "Avcılar"),
    District(name: "Bağcılar"),
    District(name: "Bahçelievler"),
    District(name: "Bakırköy"),
    District(name: "Başakşehir"),
    District(name: "Bayrampaşa"),
    District(name: "Beşiktaş"),
    District(name: "Beykoz"),
    District(name: "Beylikdüzü"),
    District(name: "Beyoğlu"),
    District(name: "Büyükçekmece"),
    District(name: "Çatalca"),
    District(name: "Çekmeköy"),
    District(name: "Esenler"),
    District(name: "Esenyurt"),
    District(name: "Eyüpsultan"),
    District(name: "Fatih"),
    District(name: "Gaziosmanpaşa"),
    District(name: "Güngören"),
    District(name: "Kadıköy"),
    District(name: "Kağıthane"),
    District(name: "Kartal"),
    District(name: "Küçükçekmece"),
    District(name: "Maltepe"),
    District(name: "Pendik"),
    District(name: "Sancaktepe"),
    District(name: "Sarıyer"),
    District(name: "Silivri"),
    District(name: "Sultanbeyli"),
    District(name: "Sultangazi"),
    District(name: "Şile"),
    District(name: "Şişli"),
    District(name: "Tuzla"),
    District(name: "Ümraniye"),
    District(name: "Üsküdar"),
    District(name: "Zeytinburnu")
]


// SwiftUI View for displaying districts

import SwiftUI

// ... (Your existing code for WeatherData, District, WeatherService remains the same)


// ... (Your existing code for WeatherData, District, WeatherService remains the same)

struct DistrictsView: View {
    @State private var weatherDataForDistricts: [String: WeatherData] = [:]

    // Sorted districts
    private var sortedDistricts: [District] {
        districts.sorted { $0.name < $1.name }
    }

    var body: some View {
        NavigationView {
            
            ScrollView {
                
                VStack(spacing: 20) {
                    
                    ForEach(sortedDistricts, id: \.name) { district in
                        NavigationLink(destination: WeatherDetailView(district: district)) {
                            ZStack {
                                
                                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
                                    .cornerRadius(10)
                                    .frame(height: 200)

                                HStack {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("\(weatherDataForDistricts[district.name]?.main.temp ?? 0, specifier: "%.0f")°")
                                            .font(.system(size: 50, weight: .bold))
                                            .foregroundColor(.white)

                                        Text(district.name)
                                            .foregroundColor(.white)
                                            .font(.title2)
                                    }

                                    Spacer()

                                    VStack(alignment: .trailing, spacing: 10) {
                                        Image(systemName: "cloud.rain.fill") // Example icon
                                            .font(.largeTitle)
                                            .foregroundColor(.white)

                                        Text(weatherDataForDistricts[district.name]?.weather.first?.description ?? "")
                                            .foregroundColor(.white)
                                            .font(.headline)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .buttonStyle(PlainButtonStyle()) // To ensure the entire ZStack is tappable
                        .onAppear {
                            loadWeatherData(for: district)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Istanbul Districts")
        }
    }

    private func loadWeatherData(for district: District) {
        WeatherService().fetchWeather(forDistrict: district.name) { data in
            weatherDataForDistricts[district.name] = data
        }
    }
}

// ... (Rest of your code, including WeatherDetailView and Preview provider)



// ... (Rest of your code, including WeatherDetailView and Preview provider)




class WeatherService {
    func fetchWeather(forDistrict district: String, completion: @escaping (WeatherData?) -> Void) {
        let apiKey = "eff6aebe49fceeddf28f1ca4bd45071e"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(district)&appid=\(apiKey)&units=metric"

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data)
            DispatchQueue.main.async {
                completion(weatherData)
            }
        }.resume()
    }
}


// Placeholder view for weather details
// ... (Your existing code for WeatherData, District, WeatherService remains the same)

struct WeatherDetailView: View {
    var district: District
    @State private var weatherData: WeatherData?

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                if let weatherData = weatherData {
                    // Weather details
                    VStack(spacing: 10) {
                        Text("\(Int(weatherData.main.temp))°")
                            .font(.system(size: 80, weight: .bold))
                            .foregroundColor(.white)

                        HStack {
                            Text("H:\(Int(weatherData.main.temp + 5))°") // Example High
                                .foregroundColor(.white)
                                .font(.title)
                            Text("L:\(Int(weatherData.main.temp - 5))°") // Example Low
                                .foregroundColor(.white)
                                .font(.title)
                        }

                        Text(district.name)
                            .foregroundColor(.white)
                            .font(.title2)

                        Text(weatherData.weather.first?.description ?? "")
                            .foregroundColor(.white)
                            .font(.headline)

                        // Weather icon can be an SF Symbol or a custom image
                        Image(systemName: "cloud.rain.fill") // Example icon
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        
                    }
                } else {
                    Text("Loading...")
                        .foregroundColor(.white)
                        .font(.title)
                }
                Spacer()
            }
        }
        .navigationTitle(district.name)
        .onAppear {
            WeatherService().fetchWeather(forDistrict: district.name) { data in
                self.weatherData = data
            }
        }
    }
}

// ... (Rest of your code, including DistrictsView and Preview provider)



// Preview provider
struct DistrictsView_Previews: PreviewProvider {
    static var previews: some View {
        DistrictsView()
    }
}

