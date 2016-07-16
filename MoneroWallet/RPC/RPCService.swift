//
//  RPCService.swift
//  MoneroWallet
//
//  Created by Ugo on 7/14/16.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

/*
import Foundation
import Moya

enum RPCService {
    case Getinfo
}

// MARK: - TargetType Protocol Implementation
extension RPCService: TargetType {

    var baseURL: NSURL { return NSURL(string: "http://localhost:18081")! }
    
    var path: String {
        switch self {
        case .Getinfo:
            return "/json_rpc"
        }
    }

    var method: Moya.Method {
        switch self {
        case .Getinfo:
            return .POST
        }
    }

    var parameters: [String: AnyObject]? {
        switch self {
        case .Getinfo:
            return ["jsonrpc":"2.0", "id":"test", "method":"getlastblockheader", "params":[]]
        }
    }

    var sampleData: NSData {
        switch self {
        case .Getinfo:
            return "Half measures are as bad as nothing at all.".UTF8EncodedData
        }
    }
}

// MARK: - Helpers
private extension String {
    var URLEscapedString: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(
            NSCharacterSet.URLHostAllowedCharacterSet())!
    }
    var UTF8EncodedData: NSData {
        return self.dataUsingEncoding(NSUTF8StringEncoding)!
    }
}

public func url (route: TargetType) -> String {
    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
}

let endpointClosure = { (target: RPCService) -> Endpoint<RPCService> in
    return Endpoint<RPCService>(
        URL: url(target),
        sampleResponseClosure: {.NetworkResponse(200, target.sampleData)},
        method: target.method,
        parameters: target.parameters,
        parameterEncoding: .JSON
    )
}

// Create this instance at app launch
let provider = MoyaProvider(endpointClosure: endpointClosure)
*/