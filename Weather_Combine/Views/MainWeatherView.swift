//
//  MainWeatherView.swift
//  Weather_Combine
//
//  Created by wjdyukyung on 10/24/24.
//

import Combine
import SwiftUI
import MapKit

struct MainWeatherView: View {
    @State private var isSearching = false
    @State private var searchText = ""
    
    @ObservedObject private var viewModel = WeatherViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.lightBlue)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    if let forecastData = viewModel.weatherForecastData,
                       let weatherData = viewModel.weatherData {

                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 16) {
                                searchBar
                                headerView(curDate: weatherData, data: forecastData)
                                todayWeatherView(data: forecastData)
                                weekWeatherView(data: forecastData)
                                weatherLocationView(data: weatherData)
                                weatherKeyPointsView(data: forecastData)
                            }
                            Spacer(minLength: 40)
                        }
                        .padding(.horizontal, 16)
                        .background(Color.lightBlue)
                        .edgesIgnoringSafeArea(.bottom)
                    }
                }
            }
        }
    }

    private var searchBar: some View {
        SearchBar(searchText: $searchText, isSearching: $isSearching)
            .onTapGesture {
                isSearching = true
            }
            .navigationDestination(isPresented: $isSearching) {
                SearchWeatherView(searchText: $searchText, viewModel:  CitySearchViewModel(weatherViewModel: viewModel))
                    .navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true)
            }
    }
    
    private func headerView(curDate: WeatherData, data: WeatherForecastData) -> some View {
        VStack() {
            Spacer(minLength: 32)
            let cityName = viewModel.selectedCity?.name ?? "Seoul"
            Text(cityName)
                .font(.system(size: 40))
                .foregroundColor(.white)

            Spacer(minLength: 24)
            Text(curDate.main.temp.getTemperatureString())
                .font(.system(size: 64))
                .fontWeight(.medium)
                .foregroundColor(.white)

            Spacer()
            Text(curDate.getCurWeather())
                .font(.system(size: 24))
                .foregroundColor(.white)

            Spacer()
            Text(data.getMinMaxTemperature())
                .font(.system(size: 16))
                .foregroundColor(.white)
                .padding(.bottom, 8)
        }
    }

    private func todayWeatherView(data: WeatherForecastData) -> some View {
        VStack(spacing: 0) {
            Text("돌풍의 풍속은 최대 " + data.getWindMaxSpeed() + " 입니다.")
                .font(.subheadline)
                .foregroundColor(.lightGrayBlue)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.midBlue)

            Divider()
                .background(Color.white)
                .frame(height: 0.4)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 4) {

                    let today = data.getDateWeatherList()
                    let tomorrow = data.getDateWeatherList(date: Calendar.current.date(byAdding: .day, value: 1, to: Date()))

                    ForEach(today + tomorrow) { item in
                        VStack(spacing: 2) {
                            Text(item.date.fullDate().formattedTime())
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .frame(height: 16)

                            let id = item.weather[0].id
                            Image(data.getWeatherImage(id: id))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)

                            Text(item.main.temp.getTemperatureString())
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .frame(height: 16)
                        }
                        .frame(width: 64, height: 84)
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.midBlue)
        .cornerRadius(10)
    }

    private func weekWeatherView(data: WeatherForecastData) -> some View {
        return VStack(spacing: 0) {
            Text("5일간의 일기예보")
                .font(.subheadline)
                .foregroundColor(.lightGrayBlue)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.midBlue)

            Divider()
                .background(Color.white)
                .frame(height: 0.4)

            GeometryReader { geometry in
                LazyVStack(spacing: 0) {
                    let weatherList = data.getWeekWeatherList()
                    let geometryWidth = geometry.size.width - 24

                    ForEach(weatherList.indices, id: \ .self) { idx in
                        let data = weatherList[idx]

                        HStack {
                            Text(data.dayOfWeek)
                                .font(.body)
                                .frame(width: geometryWidth * 0.3, alignment: .leading)
                                .foregroundColor(.white)

                            Text(data.temp.getTemperatureString())
                                .font(.headline)
                                .frame(width: geometryWidth * 0.2, alignment: .center)
                                .foregroundColor(.white)

                            Text(data.getMinMaxTemperature())
                                .font(.subheadline)
                                .frame(width: geometryWidth * 0.5, alignment: .trailing)
                                .foregroundColor(.white)
                        }
                        .frame(height: 40)

                        if idx < weatherList.count - 2 {
                            Divider()
                                .background(Color.white)
                                .frame(height: 0.4)
                        }
                    }
                }
            }
            .frame(height: CGFloat(40 * 5))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.midBlue)
        .cornerRadius(10)
    }

    func weatherLocationView(data: WeatherData) -> some View {
        VStack {
            VStack(spacing: 0) {
                Text("강수량")
                    .font(.subheadline)
                    .foregroundColor(.lightGrayBlue)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.midBlue)

                MapView(coordinate: CLLocationCoordinate2D(latitude: data.coord.lat,
                                                           longitude: data.coord.lon))
                .frame(height: 300)
                .cornerRadius(8)
                Spacer()
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.midBlue)
        .cornerRadius(10)
    }

    private func weatherKeyPointsView(data: WeatherForecastData) -> some View {
        GeometryReader { geometry in
            let itemWidth = (geometry.size.width - 20) / 2

            LazyVGrid(columns: [GridItem(.fixed(itemWidth), spacing: 20),
                                GridItem(.fixed(itemWidth), spacing: 20)],
                      spacing: 16) {

                ForEach(data.getKeyPointsData()) { item in
                    VStack {
                        Text(item.title)
                            .font(.subheadline)
                            .frame(width: itemWidth, alignment: .leading)
                            .padding(.leading, 16)
                            .foregroundColor(.white)

                        Spacer()

                        Text(item.description)
                            .font(.system(size: 32))
                            .frame(width: itemWidth, alignment: .leading)
                            .padding(.leading, 16)
                            .foregroundColor(.white)

                        Spacer()

                        if let sub = item.subDescription {
                            Text(sub)
                                .font(.subheadline)
                                .frame(width: itemWidth, alignment: .leading)
                                .padding(.leading, 16)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.vertical, 16)
                    .frame(width: itemWidth, height: itemWidth, alignment: .center)
                    .background(Color.midBlue)
                    .cornerRadius(10)
                }
            }
        }
        .frame(height: UIScreen.main.bounds.width - 36)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        MainWeatherView()
    }
}
