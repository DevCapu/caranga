//
//  CarService.swift
//  Caranga
//
//  Created by Felipe Moreno Borges on 25/10/23.
//

import Foundation


enum CarServiceError: Error {
    case badURL
    case taskError
    case noResponse
    case invalidStatusCode(Int)
    case decodingError
    case unknown
    
    var errorMessage: String {
        switch self {
        case .badURL:
            return "URL inválida"
        case .taskError:
            return "Erro de conxão"
        case .noResponse:
            return "Servidor não retornou uma resposta"
        case .invalidStatusCode(let statusCode):
            return "Status Code inválido \(statusCode)"
        case .decodingError:
            return "Erro de decode"
        default:
            return "Erro desconhecido"
        }
    }
}

final class CarService {
    
    private let basePath = "https://carangas.herokuapp.com/cars"
    
    private let configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = true
        configuration.timeoutIntervalForRequest = 60
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        configuration.httpMaximumConnectionsPerHost = 6
        
        return configuration
    }()
    
    private lazy var session = URLSession(configuration: configuration)
    
    
    func loadCars() async -> Result<[Car], CarServiceError> {
        guard let url = URL(string: basePath) else { return .failure(.badURL) }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let response = response as? HTTPURLResponse else {
                return Result.failure(.noResponse)
            }
            
            if !(200...299 ~= response.statusCode) {
                return .failure(.invalidStatusCode(response.statusCode))
            }
    
            let cars = try JSONDecoder().decode([Car].self, from: data)
            return .success(cars)
        } catch {
            print(error)
            return .failure(.decodingError)
        }
    }
    
    @discardableResult func createCar(_ car: Car) async -> Result<Void, CarServiceError> {
        await request(car: car, httpMethod: "POST")
    }
    
    @discardableResult func deleteCar(_ car: Car) async -> Result<Void, CarServiceError> {
        await request(car: car, httpMethod: "DELETE")
    }
    
    @discardableResult func updateCar(_ car: Car) async -> Result<Void, CarServiceError> {
        await request(car: car, httpMethod: "PUT")
    }
    
    private func request(
        car: Car,
        httpMethod: String
    ) async -> Result<Void, CarServiceError>  {
        let urlString = basePath + "/" + (car._id ?? "")
        guard let url = URL(string: urlString) else {
            return .failure(.badURL)
        }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod
            request.httpBody = try JSONEncoder().encode(car)
            
            let (_, response) = try await session.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                return Result.failure(.noResponse)
            }
            
            if !(200...299 ~= response.statusCode) {
                return .failure(.invalidStatusCode(response.statusCode))
            }
    
            return .success(())
        } catch {
            print(error)
            return .failure(.decodingError)
        }
    }
}
