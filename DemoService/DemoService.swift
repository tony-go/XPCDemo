//
//  DemoService.swift
//  DemoService
//
//  Created by Tony Gorez on 21/12/2023.
//

import Foundation

/// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
class DemoService: NSObject, DemoServiceProtocol {
    /// This implements the example protocol. Replace the body of this class with the implementation of this service's protocol.
    @objc func uppercase(string: String, with reply: @escaping (String) -> Void) {
        let response = string.uppercased()
        reply(response)
    }
    
    func close() {
        exit(0)
    }
}
