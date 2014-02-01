//
//  CallCenter.h
//  XMPPDemo
//
//  Created by casa on 14-2-1.
//  Copyright (c) 2014年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"

@protocol CallCenterDelegate <NSObject>

- (void)receivedMessage:(NSString *)message;

@end

@interface CallCenter : NSObject <XMPPStreamDelegate>

@property (nonatomic, weak) id<CallCenterDelegate> delegate;

- (void)login;
- (void)sendMessage:(NSString *)message;
- (void)logout;

@end
