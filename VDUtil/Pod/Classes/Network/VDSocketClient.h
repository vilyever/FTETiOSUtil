//
//  VDSocketClient.h
//  VDUtil
//
//  Created by FTET on 15/5/14.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const VDSocketConnectedNotificationEvent;
extern NSString * const VDSocketDisconnectedNotificationEvent;
extern NSString * const VDSocketConnectingWillTimeOutdNotificationEvent;
extern NSString * const VDSocketReceiveResponseDataNotificationEvent;

extern NSString * const VDSocketDisconnectedNotificationEventUserInfoKeyForError;
extern NSString * const VDSocketReceiveResponseDataNotificationEventUserInfoKeyForData;

typedef NS_ENUM(NSInteger, VDSocketClientState) {
    VDSocketClientStateDisconnected,
    VDSocketClientStateConnecting,
    VDSocketClientStateConnected
};


@class VDSocketClient;


@protocol VDSocketClientDelegate <NSObject>

@required

@optional
- (void)connectToServerFromSocketClient:(VDSocketClient *)client;
- (void)disconnectFromServerFromSocketClient:(VDSocketClient *)client;
- (void)socketClient:(VDSocketClient *)client didDisconnectWithError:(NSError *)error;
- (void)receiveData:(NSData *)responseData fromSocketClient:(VDSocketClient *)client;
- (void)willConnectingTimeOutFromSocketClient:(VDSocketClient *)client;

@end


@interface VDSocketClient : NSObject

@property (nonatomic, weak) id<VDSocketClientDelegate> delegate;

@property (nonatomic, assign) VDSocketClientState state;


#pragma Methods
#pragma Public Class Method
+ (instancetype)sharedClient;

#pragma Public Instance Method
- (void)connectToServerWithIP:(NSString *)ip port:(NSNumber *)port;

- (void)disconnectFromServer;

- (void)sendData:(NSData *)data;

- (void)sendString:(NSString *)string;

- (void)onConnected;
- (void)onDisconnected:(NSError *)error;
- (void)onResponse:(NSData *)data;
- (void)willConnectingTimeOutFromSocketClient;

@end
