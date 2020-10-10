//
//  ApiHiringFetch.swift
//  Fetch Rewards
//
//  Created by Jason Cox on 10/10/20.
//

import Foundation


protocol ApiHiringFetchDelegate: class
{
    func ApiHiringFetch_Complete(status: Api.Status, output: [ApiHiringFetch.Hiring]?);
}

extension ApiHiringFetchDelegate
{
    func ApiHiringFetch_Complete(status: Api.Status, output: [ApiHiringFetch.Hiring]?)
    {
    }
}

class ApiHiringFetch: NSObject
{
    // Setup the delegate
    weak var delegate: ApiHiringFetchDelegate?;
    
    // MARK: - Structures
    
    /// Define a structure to handle the data
    internal struct Hiring : Codable, Equatable
    {
        var intId: Int;
        var intListId: Int;
        var stringName: String?;
        
        // Convert from API names to local names
        enum CodingKeys: String, CodingKey
        {
            case intId = "id";
            case intListId = "listId";
            case stringName = "name";
        }
    }
    
    // MARK: - API
    
    internal func sendRequest()
    {
        // Setup the URLRequest
        let urlRequest = Api().createRequest(path: "/hiring.json", method: .get, parameters: nil);
        
        // Setup the URLSessionDownloadTask
        let dataTask: URLSessionDownloadTask = URLSession.shared.downloadTask(with: urlRequest, completionHandler: { (urlLocation: URL?, urlResponse: URLResponse?, error: Error?) in
            //Check to see if an error occured
            if (error != nil)
            {
                // Indicate that an error occured off the local device
                self.receiveRequest(status: .ErrorRemote, response: nil);
            }
            else
            {
                // Attempt to decode the response
                do
                {
                    // Setup the JSON Decoder
                    let decoder: JSONDecoder = JSONDecoder();
                    
                    // Indicate that the request was completed successfully
                    self.receiveRequest(status: .Success,
                                        response: try decoder.decode([Hiring].self, from: Data(contentsOf: urlLocation!)));
                }
                catch
                {
                    // Indicate that an error occured on the local device
                    self.receiveRequest(status: .ErrorLocal, response: nil);
                }
            }
        });
        
        // Execute the URLSessionDataTask
        dataTask.taskDescription = String(describing: type(of: self));
        dataTask.resume();
    }
    
    private func receiveRequest(status: Api.Status, response: [Hiring]?)
    {
        // Execute asynchronously on the main thread
        DispatchQueue.main.async {
            // Inform the delegate that the API call has completed
            self.delegate?.ApiHiringFetch_Complete(status: status, output: response);
        }
    }
}
