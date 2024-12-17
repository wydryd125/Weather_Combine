//
//  CityViewModel.swift
//  Weather_Combine
//
//  Created by wjdyukyung on 10/24/24.
//

import Foundation
import Combine

class CitySearchViewModel: ObservableObject {
    // MARK: - Property
    @Published var searchQuery: String = ""
    @Published var filteredCities: [City] = []
    
    private let repository = CityRepository()
    private var cancellables = Set<AnyCancellable>()
    private let weatherViewModel: WeatherViewModel
    
    init(weatherViewModel: WeatherViewModel) {
        self.weatherViewModel = weatherViewModel
        
        // 검색어 처리 및 필터링
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map { query in
                query.lowercased().replacingOccurrences(of: " ", with: "")
            }
            .map { [weak self] query -> [City] in
                guard let self = self else { return [] }
                if query.isEmpty {
                    return self.repository.cities
                }
                
                let filterCity = self.repository.cities.filter { city in
                    let cityName = city.name.lowercased().replacingOccurrences(of: " ", with: "")
                    let countryName = city.country.lowercased().replacingOccurrences(of: " ", with: "")
                    return cityName.contains(query) || countryName.contains(query)
                }
                print("검색어'\(query)', \(self.repository.cities.count), \(filterCity.count)")
                return filterCity.sorted { $0.name < $1.name }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$filteredCities)
        
        repository.loadCities()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cities in
                guard let self = self else { return }
                self.filteredCities = cities
            }
            .store(in: &cancellables)
    }
    
    func selectCity(_ city: City) {
        weatherViewModel.selectedCity = city
    }
}
