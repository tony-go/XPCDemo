//
//  XPCClient.swift
//  DemoApp
//
//  Created by Tony Gorez on 02/01/2024.
//

import Foundation

protocol XPCClientProtocol {
    func uppercase(for inputString: String, completion: @escaping (String) -> Void)
    func close()
}

class XPCClient: XPCClientProtocol {
    private let connection: NSXPCConnection
    private let service: DemoServiceProtocol
    
    init() {
        connection = NSXPCConnection(serviceName: "com.tonygo.DemoService")
        connection.remoteObjectInterface = NSXPCInterface(with:
                                                            DemoServiceProtocol.self)
        connection.resume()
        
        service = connection.remoteObjectProxyWithErrorHandler { error in
            print("Error during remote connection: ", error)
        } as! DemoServiceProtocol
        
    }
    
    deinit {
        connection.invalidate()
    }
    
    func uppercase(for inputString: String, completion: @escaping (String) -> Void) {
        service.uppercase(string: inputString, with: { (uppercasedString) in
            completion(uppercasedString)
        })
    }
    
    func close() {
        service.close()
    }
}

class MockedXPCCLient: XPCClientProtocol {
    func uppercase(for inputString: String, completion: @escaping (String) -> Void) {}
    func close() {}
}
