//
//  main.swift
//  DemoService
//
//  Created by Tony Gorez on 21/12/2023.
//

import Foundation

class XPCClientValidator {
    var secCodeOptional: SecCode? = nil;
    
    func identifyGuest(for connection: NSXPCConnection) -> Bool {
        let auditToken = AuditToken.extractToken(from: connection)
        let hostSecCode: SecCode? = nil; // This is a way to indicate that the code signing root of trust hould be used as host.
        let attributes = [ kSecGuestAttributeAudit: auditToken ] as CFDictionary
        let secFlags = SecCSFlags(rawValue: 0)
        
        // Asks a code host to identify the guest given the audit token
        let status: OSStatus = SecCodeCopyGuestWithAttributes(hostSecCode, attributes, secFlags, &self.secCodeOptional)
        if (status != errSecSuccess) {
            let msg = SecCopyErrorMessageString(status, nil)!
            print("Cannot get SecCode: \(status) - \(msg)")
            print("Audit token: \(String(describing: auditToken))")
            return false
        }
        
        guard let _ = secCodeOptional else {
            NSLog("Couldn't unwrap the secCode")
            return false
        }
        
        return true
    }
}

class ServiceDelegate: NSObject, NSXPCListenerDelegate {
    
    /// This method is where the NSXPCListener configures, accepts, and resumes a new incoming NSXPCConnection.
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        
        let connectionValidatior = XPCClientValidator()
        if connectionValidatior.identifyGuest(for: newConnection) {
            // Configure the connection.
            // First, set the interface that the exported object implements.
            newConnection.exportedInterface = NSXPCInterface(with: DemoServiceProtocol.self)
            
            // Next, set the object that the connection exports. All messages sent on the connection to this service will be sent to the exported object to handle. The connection retains the exported object.
            let exportedObject = DemoService()
            newConnection.exportedObject = exportedObject
            
            // Resuming the connection allows the system to deliver more incoming messages.
            newConnection.resume()
            
            // Returning true from this method tells the system that you have accepted this connection. If you want to reject the connection for some reason, call invalidate() on the connection and return false.
            return true
        }
        
        return false
    }
}

// Create the delegate for the service.
let delegate = ServiceDelegate()

// Set up the one NSXPCListener for this service. It will handle all incoming connections.
let listener = NSXPCListener.service()
listener.delegate = delegate

// Resuming the serviceListener starts this service. This method does not return.
listener.resume()
