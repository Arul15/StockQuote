//
//  StockQuoteDetail.swift
//  CentizenStockQuote
//
//  Created by Shanmuganathan, Arulpandiyan (Chennai) on 05/07/18.
//  Copyright © 2018 Shanmuganathan, Arulpandiyan (Chennai). All rights reserved.
//


import Foundation
import Alamofire

class StockQuoteDetail: Codable {
    let metaDataDetail: MetaDataDetail?
    let timeSeriesDaily: [String: [String: String]]?
    
    enum CodingKeys: String, CodingKey {
        case metaDataDetail = "Meta Data"
        case timeSeriesDaily = "Monthly Adjusted Time Series"
    }
    
    init(metaDataDetail: MetaDataDetail?, timeSeriesDaily: [String: [String: String]]?) {
        self.metaDataDetail = metaDataDetail
        self.timeSeriesDaily = timeSeriesDaily
    }
}

class MetaDataDetail: Codable {
    let the1Information: String?
    let the2Symbol: String?
    let the3LastRefreshed: String?
    let the4OutputSize: String?
    let the5TimeZone: String?
    
    enum CodingKeys: String, CodingKey {
        case the1Information = "1. Information"
        case the2Symbol = "2. Symbol"
        case the3LastRefreshed = "3. Last Refreshed"
        case the4OutputSize = "4. Output Size"
        case the5TimeZone = "5. Time Zone"
    }
    
    init(the1Information: String?, the2Symbol: String?, the3LastRefreshed: String?, the4OutputSize: String?, the5TimeZone: String?) {
        self.the1Information = the1Information
        self.the2Symbol = the2Symbol
        self.the3LastRefreshed = the3LastRefreshed
        self.the4OutputSize = the4OutputSize
        self.the5TimeZone = the5TimeZone
    }
}

// MARK: Convenience initializers

extension StockQuoteDetail {
    convenience init(data: Data) throws {
        let me = try JSONDecoder().decode(StockQuoteDetail.self, from: data)
        self.init(metaDataDetail: me.metaDataDetail, timeSeriesDaily: me.timeSeriesDaily)
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

extension MetaDataDetail {
    convenience init(data: Data) throws {
        let me = try JSONDecoder().decode(MetaDataDetail.self, from: data)
        self.init(the1Information: me.the1Information, the2Symbol: me.the2Symbol, the3LastRefreshed: me.the3LastRefreshed, the4OutputSize: me.the4OutputSize, the5TimeZone: me.the5TimeZone)
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
    func responseStockQuoteDetail(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<StockQuoteDetail>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}

