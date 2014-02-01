//
//  CallCenter.m
//  XMPPDemo
//
//  Created by casa on 14-2-1.
//  Copyright (c) 2014年 casa. All rights reserved.
//

#import "CallCenter.h"
#import "XMPP.h"

@interface CallCenter () 

@property (nonatomic, strong) XMPPStream *xmppStream;

@end

@implementation CallCenter

#pragma mark - getters and setters
- (XMPPStream *)xmppStream
{
    if (_xmppStream == nil) {
        _xmppStream = [[XMPPStream alloc] init];
    }
    return _xmppStream;
}

#pragma mark - life cycle
- (void)dealloc
{
    [self.xmppStream removeDelegate:self];
}

#pragma mark - public methods
- (void)login
{
    self.xmppStream.myJID = [XMPPJID jidWithString:@"casa@192.168.5.106"];
    //try not use hostname
    self.xmppStream.hostName = @"192.168.5.106";
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    if (![self.xmppStream connectWithTimeout:5 error:&error]) {
        NSLog(@"here is an error:%@", error);
    }
}

- (void)sendMessage:(NSString *)messageStr
{
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:messageStr];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:@"casatwy@192.168.5.106"];
    [message addChild:body];
    
    [self.xmppStream sendElement:message];
}

- (void)logout
{
    
}

#pragma mark - XMPPStreamDelegate
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSError *error = nil;
    if (![sender authenticateWithPassword:@"casacasa" error:&error]) {
        NSLog(@"authntication error: %@", error);
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    XMPPPresence *presence = [XMPPPresence presence];
    [self.xmppStream sendElement:presence];
}

- (void)xmppStreamWillConnect:(XMPPStream *)sender
{
    
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
    NSLog(@"message = %@", message);
    
    NSString *idStr = [[message attributeForName:@"id"] stringValue];
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    NSString *to = [[message attributeForName:@"to"] stringValue];
    
    [self.delegate receivedMessage:msg];
    
}

@end
