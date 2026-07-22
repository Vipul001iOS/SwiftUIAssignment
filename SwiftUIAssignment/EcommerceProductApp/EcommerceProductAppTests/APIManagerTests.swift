import XCTest
@testable import EcommerceProductApp

final class APIManagerTests: XCTestCase {
    override func tearDown() {
        URLProtocolMock.requestHandler = nil
        super.tearDown()
    }

    func testRequest_WhenResponseIsSuccessful_DecodesValue() async throws {
        let dto = ProductDTO.mock()
        let data = try JSONEncoder().encode([dto])
        let sut = APIManager(session: makeSession(statusCode: 200, data: data))

        let result: [ProductDTO] = try await sut.request(url: API.productsURL)

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, dto.id)
        XCTAssertEqual(result.first?.title, dto.title)
    }

    func testRequest_WhenUrlIsInvalid_ThrowsInvalidUrl() async {
        let sut = APIManager(session: makeSession(statusCode: 200, data: Data()))

        await assertThrowsApiError(.invalidUrl) {
            let _: [ProductDTO] = try await sut.request(url: "not a url")
        }
    }

    func testRequest_WhenResponseIsNotHttp_ThrowsUnknownError() async {
        let session = makeSession { request in
            (Data(), URLResponse(url: request.url!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil))
        }
        let sut = APIManager(session: session)

        await assertThrowsApiError(.unKnownError) {
            let _: [ProductDTO] = try await sut.request(url: API.productsURL)
        }
    }

    func testRequest_WhenStatusCodeFails_ThrowsServerError() async {
        let sut = APIManager(session: makeSession(statusCode: 500, data: Data("{}".utf8)))

        await assertThrowsApiError(.serverError(500)) {
            let _: [ProductDTO] = try await sut.request(url: API.productsURL)
        }
    }

    func testRequest_WhenDataIsEmpty_ThrowsNoData() async {
        let sut = APIManager(session: makeSession(statusCode: 200, data: Data()))

        await assertThrowsApiError(.noData) {
            let _: [ProductDTO] = try await sut.request(url: API.productsURL)
        }
    }

    func testRequest_WhenDecodingFails_ThrowsDecodingError() async {
        let sut = APIManager(session: makeSession(statusCode: 200, data: Data("{}".utf8)))

        await assertThrowsApiError(.decodingError) {
            let _: [ProductDTO] = try await sut.request(url: API.productsURL)
        }
    }

    func testRequest_WhenSessionFails_ThrowsUnknownError() async {
        let session = makeSession { _ in
            throw URLError(.notConnectedToInternet)
        }
        let sut = APIManager(session: session)

        await assertThrowsApiError(.unKnownError) {
            let _: [ProductDTO] = try await sut.request(url: API.productsURL)
        }
    }

    private func makeSession(statusCode: Int, data: Data) -> URLSession {
        makeSession { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )!
            return (data, response)
        }
    }

    private func makeSession(handler: @escaping (URLRequest) throws -> (Data, URLResponse)) -> URLSession {
        URLProtocolMock.requestHandler = handler
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: configuration)
    }

    private func assertThrowsApiError(
        _ expectedError: ApiError,
        operation: () async throws -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        do {
            try await operation()
            XCTFail("Expected \(expectedError)", file: file, line: line)
        } catch let error as ApiError {
            XCTAssertEqual(error, expectedError, file: file, line: line)
        } catch {
            XCTFail("Expected ApiError but got \(error)", file: file, line: line)
        }
    }
}

private final class URLProtocolMock: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (Data, URLResponse))?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let requestHandler = Self.requestHandler else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }

        do {
            let (data, response) = try requestHandler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
