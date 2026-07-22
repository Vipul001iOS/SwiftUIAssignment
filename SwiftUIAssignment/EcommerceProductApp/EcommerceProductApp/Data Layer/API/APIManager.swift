import Foundation

public protocol APIServiceProtocol {
    func request<T: Decodable>(url: String) async throws -> T
}

public final class APIManager: APIServiceProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func request<T: Decodable>(url: String) async throws -> T {
        guard let finalUrl = URL(string: url) else {
            throw ApiError.invalidUrl
        }

        var request = URLRequest(url: finalUrl)
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError.unKnownError
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                throw ApiError.serverError(httpResponse.statusCode)
            }

            guard !data.isEmpty else {
                throw ApiError.noData
            }

            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw ApiError.decodingError
            }
        } catch let error as ApiError {
            throw error
        } catch {
            throw ApiError.unKnownError
        }
    }
}
