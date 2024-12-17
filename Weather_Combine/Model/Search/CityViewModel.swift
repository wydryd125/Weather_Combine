//
//  CitySearchViewModel.swift
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
        
        setupSearchQueryPublisher()
        loadCities()
    }
    
    // MARK: - Private Methods
    private func setupSearchQueryPublisher() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map { query in
                query.lowercased().replacingOccurrences(of: " ", with: "")
            }
            .sink { [weak self] query in
                guard let self = self else { return }
                self.filterCities(by: query)
            }
            .store(in: &cancellables)
    }
    
    private func loadCities() {
        repository.loadCities()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cities in
                guard let self = self else { return }
                self.filteredCities = cities
            }
            .store(in: &cancellables)
    }
    
    private func filterCities(by query: String) {
        if query.isEmpty {
            filteredCities = repository.cities
        } else {
            filteredCities = repository.cities.filter { city in
                let cityName = city.name.lowercased().replacingOccurrences(of: " ", with: "")
                let countryName = city.country.lowercased().replacingOccurrences(of: " ", with: "")
                return cityName.contains(query) || countryName.contains(query)
            }
            .sorted { $0.name < $1.name }
        }
    }
    
    // MARK: - Public Methods
    func selectCity(_ city: City) {
        weatherViewModel.selectedCity = city
    }
}
