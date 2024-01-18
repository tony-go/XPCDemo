//
//  AuditToken.h
//  DemoApp
//
//  Created by Tony Gorez on 18/01/2024.
//
#import <Foundation/Foundation.h>

@interface NSXPCConnection(PrivateAuditToken)
@property (nonatomic, readonly) audit_token_t auditToken;
@end


@interface AuditToken : NSObject
+(NSData *)extractTokenFromNSXPCConnection:(NSXPCConnection *)connection;
@end
