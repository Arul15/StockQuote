//
//  Stock.swift
//  CentizenStockQuote
//
//  Created by Shanmuganathan, Arulpandiyan (Chennai) on 04/07/18.
//  Copyright © 2018 Shanmuganathan, Arulpandiyan (Chennai). All rights reserved.
//

import Foundation
import Alamofire

class StockQuote: Codable {
    let metaData: MetaData?
    let stockQuotes: [StockQuoteElement]?
    
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case stockQuotes = "Stock Quotes"
    }
    
    init(metaData: MetaData?, stockQuotes: [StockQuoteElement]?) {
        self.metaData = metaData
        self.stockQuotes = stockQuotes
    }
}

class MetaData: Codable {
    let the1Information: String?
    let the2Notes: String?
    let the3TimeZone: String?
    
    enum CodingKeys: String, CodingKey {
        case the1Information = "1. Information"
        case the2Notes = "2. Notes"
        case the3TimeZone = "3. Time Zone"
    }
    
    init(the1Information: String?, the2Notes: String?, the3TimeZone: String?) {
        self.the1Information = the1Information
        self.the2Notes = the2Notes
        self.the3TimeZone = the3TimeZone
    }
}

class StockQuoteElement: Codable {
    let the1Symbol: String?
    let the2Price: String?
    let the3Volume: String?
    let the4Timestamp: String?
    
    enum CodingKeys: String, CodingKey {
        case the1Symbol = "1. symbol"
        case the2Price = "2. price"
        case the3Volume = "3. volume"
        case the4Timestamp = "4. timestamp"
    }
    
    init(the1Symbol: String?, the2Price: String?, the3Volume: String?, the4Timestamp: String?) {
        self.the1Symbol = the1Symbol
        self.the2Price = the2Price
        self.the3Volume = the3Volume
        self.the4Timestamp = the4Timestamp
    }
}

// MARK: Convenience initializers

extension StockQuote {
    convenience init(data: Data) throws {
        let me = try JSONDecoder().decode(StockQuote.self, from: data)
        self.init(metaData: me.metaData, stockQuotes: me.stockQuotes)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension MetaData {
    convenience init(data: Data) throws {
        let me = try JSONDecoder().decode(MetaData.self, from: data)
        self.init(the1Information: me.the1Information, the2Notes: me.the2Notes, the3TimeZone: me.the3TimeZone)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension StockQuoteElement {
    convenience init(data: Data) throws {
        let me = try JSONDecoder().decode(StockQuoteElement.self, from: data)
        self.init(the1Symbol: me.the1Symbol, the2Price: me.the2Price, the3Volume: me.the3Volume, the4Timestamp: me.the4Timestamp)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Alamofire response handlers

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try JSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseStockQuote(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<StockQuote>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}

