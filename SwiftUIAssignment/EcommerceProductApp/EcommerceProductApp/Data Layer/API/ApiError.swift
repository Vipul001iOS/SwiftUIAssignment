import Foundation

enum ApiError: Error, Equatable {
    case serverError(Int)
    case networkError
    case noData
    case invalidUrl
    case decodingError
    case unKnownError
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "No internet connection"
        case .decodingError:
            return "Failed to decode response"
        case .serverError(let code):
            return "Server error occured \(code)"
        case .invalidUrl:
            return "Invalid URL"
        case .noData:
            return "No data"
        case .unKnownError:
            return "Unknown error"
        }
    }
}
