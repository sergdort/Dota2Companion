import Foundation

public struct Resource: Equatable {
  public typealias Headers = [String: String]
  public typealias Query = [URLQueryItem]
  
  public enum Method: String {
    case OPTIONS
    case GET
    case HEAD
    case POST
    case PUT
    case PATCH
    case DELETE
    case TRACE
    case CONNECT
  }
  
  public let path: String
  public let method: Method
  public var headers: Headers
  public var parameters: [String: Any]?
  public var query: Query
  public let percentEncodedQuery: Query
  
  public init(path: String = "",
              method: Method = .GET,
              headers: Headers = [:],
              parameters: [String: Any]? = nil,
              query: Query = [],
              percentEncodedQuery: Query = []
  ) {
    self.path = path.hasPrefix("/") ? path : "/" + path
    self.method = method
    self.headers = headers
    self.parameters = parameters
    self.query = query
    self.percentEncodedQuery = percentEncodedQuery
  }
  
  public var description: String {
    return "Path:\(path)\nMethod:\(method.rawValue)\nHeaders:\(headers)"
  }
  
  public var nonSensitiveDescription: String {
    return "\(method.rawValue) \(path)"
  }
}

public func == (lhs: Resource, rhs: Resource) -> Bool {
  return lhs.path == rhs.path && lhs.method == rhs.method && lhs.query == rhs.query && lhs.percentEncodedQuery == rhs.percentEncodedQuery
}

extension Resource {
  public func toRequest(_ baseURL: URL) -> URLRequest {
    let query = QueryParameters(query: self.query)
    
    let url = baseURL.components(addingResourcePath: path)
      .flatMap { try? $0.url(with: query).get() }
    
    var request = URLRequest(url: url ?? baseURL)
    
    if let value = parameters,
      let data = try? JSONSerialization.data(withJSONObject: value, options: []) {
      request.httpBody = data
    }
    
    request.allHTTPHeaderFields = headers
    request.httpMethod = method.rawValue
    
    return request
  }
}

struct QueryParameters {
  let query: Resource.Query
}

extension URLComponents {
  /// Generate a URL with each parameter defined
  internal func url(with parameters: QueryParameters) -> Result<URL, CoreError> {
    let combinedQueryItems = (self.queryItems ?? [])
    + parameters.query
    
    var components = self
    components.queryItems = combinedQueryItems.isNotEmpty ? combinedQueryItems : nil
    
    guard let url = components.url else {
      return .failure(.other("Cannot form a valid URL. (2)"))
    }
    
    return .success(url)
  }
  
  private func createQueryItems(_ query: [String: String]) -> [URLQueryItem]? {
    guard query.isEmpty == false else { return nil }
    
    return query.map { (key, value) in
      return URLQueryItem(name: key, value: value)
    }
  }
}

extension Resource {
  /// Creates a new Resource by adding the new header.
  public func addHeader(_ value: String, key: String) -> Resource {

    guard value.isEmpty == false else {
      return self
    }

    var headers = self.headers
    headers[key] = value
    
    return Resource(path: path, method: method, headers: headers, parameters: parameters, query: query)
  }
}

protocol NonSensitiveDescriptionConvertible {
  var nonSensitiveDescription: String { get }
}

extension Resource: NonSensitiveDescriptionConvertible {}

extension URLRequest: NonSensitiveDescriptionConvertible {
  var nonSensitiveDescription: String {
    return "Method: \(self.httpMethod ?? "") Path: \(url?.path ?? "")"
  }
}

extension URL {
  public func deconstruct() -> (URL, Resource)? {
    guard
      let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
      let host = components.host,
      let scheme = components.scheme,
      let url = URL(string: scheme + "://" + host)
      else {
        return nil
    }
    
    return (url, Resource(path: components.path))
  }
  
  public func components(addingResourcePath path: String) -> URLComponents? {
    let base = absoluteString
    
    switch (base.hasSuffix("/"), path.hasPrefix("/")) {
    case (true, true):
      return URLComponents(string: base + path.dropFirst())
    case (false, false):
      return URLComponents(string: base + "/" + path)
    case (true, false), (false, true):
      return URLComponents(string: base + path)
    }
  }
}

extension Array {
    public var isNotEmpty: Bool {
        return isEmpty == false
    }
}

extension Dictionary {
    public var isNotEmpty: Bool {
        return isEmpty == false
    }
}
