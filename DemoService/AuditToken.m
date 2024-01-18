//
//  AuditToken.m
//  DemoService
//
//  Created by Tony Gorez on 18/01/2024.
//

#import <Foundation/Foundation.h>

#import "AuditToken.h"

@implementation AuditToken
+(NSData *)extractTokenFromNSXPCConnection:(NSXPCConnection *)connection {
    audit_token_t at = connection.auditToken;
    // Convert to NSata
    NSData *raw_at = [NSData dataWithBytes:&at length:sizeof(audit_token_t)];
    return raw_at;
}
@end
