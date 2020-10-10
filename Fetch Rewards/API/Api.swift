//
//  Api.swift
//  Fetch Rewards
//
//  Created by Jason Cox on 10/10/20.
//

import Foundation

class Api: NSObject
{
    // MARK: - Enumerations
    
    /// Define endpoints for API calls
    private enum Endpoints: String
    {
        case Development = "https://fetch-hiring.s3.amazonaws.com";
        case Production = "";
    };
    
    /// Define supported HTTP methods
    internal enum HttpMethod: String {
        case delete = "DELETE";
        case get = "GET";
        case post = "POST";
        case put = "PUT";
    }
    
    /// Define status result types for API calls
    internal enum Status
    {
        case ErrorLocal;
        case ErrorRemote;
        case ErrorUnknown;
        case Success;
    };
    
    // Setup any required variables
    private let endpoint: Api.Endpoints = .Development;
//    private let endpoint: Api.Endpoints = .Production;
    
    internal func createRequest(path stringPath: String, method httpMethod: HttpMethod, parameters data: Data?) -> URLRequest
    {
        // Create the URL to the API
        let url: URL = URL(string: endpoint.rawValue + stringPath)!;
        
        // Setup the URLRequest
        var urlRequest: URLRequest = URLRequest(url: url);
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData;
        urlRequest.httpMethod = httpMethod.rawValue;
        urlRequest.httpBody = data;
        urlRequest.timeoutInterval = 30;
        
        return urlRequest;
    }
}
