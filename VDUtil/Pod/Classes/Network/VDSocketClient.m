//
//  VDSocketClient.m
//  VDUtil
//
//  Created by FTET on 15/5/14.
//  Copyright (c) 2015年 Vilyever. All rights reserved.
//

#import "VDSocketClient.h"

#import <VDKit/VDKit.h>

#import <CocoaAsyncSocket/GCDAsyncSocket.h>

NSString * const VDSocketConnectedNotificationEvent = @"VDSocketConnectedNotificationEvent";
NSString * const VDSocketDisconnectedNotificationEvent = @"VDSocketDisconnectedNotificationEvent";
NSString * const VDSocketConnectingWillTimeOutdNotificationEvent = @"VDSocketConnectingWillTimeOutdNotificationEvent";
NSString * const VDSocketReceiveResponseDataNotificationEvent = @"VDSocketReceiveResponseDataNotificationEvent";

NSString * const VDSocketDisconnectedNotificationEventUserInfoKeyForError = @"VDSocketDisconnectedNotificationEventUserInfoKeyForError";
NSString * const VDSocketReceiveResponseDataNotificationEventUserInfoKeyForData = @"VDSocketReceiveResponseDataNotificationEventUserInfoKeyForData";

long const ReadTimeOut = 20l;
long const ReadTimeOutExtension = 10l;
long const WriteTimeOut = -1l;

long const ReadRespondTag = 0l;
long const WriteMessageTag = 0l;


@interface VDSocketClient () <GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;

@end


@implementation VDSocketClient

#pragma Overrides
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initial];
    }
    
    return self;
}

- (void)dealloc
{
    
}


#pragma Initial
- (void)initial
{
    
}


#pragma Accessors
#pragma Private Accessors

#pragma Public Accessors
- (void)setDelegate:(id<VDSocketClientDelegate>)delegate
{
    _delegate = delegate;
}

- (GCDAsyncSocket *)asyncSocket {
    if (!_asyncSocket) {
        _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    
    return _asyncSocket;
}


#pragma Delegates
#pragma GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)socket didConnectToHost:(NSString *)host port:(UInt16)port
{
    [socket performBlock:^{
        if ([socket enableBackgroundingOnSocket]) {
            
        }
    }];
    
    self.state = VDSocketClientStateConnected;
    [self onConnected];
    if ([self.delegate respondsToSelector:@selector(connectToServerFromSocketClient:)]) {
        [self.delegate connectToServerFromSocketClient:self];
    }
    [VDDefaultNotificationCenter postNotificationName:VDSocketConnectedNotificationEvent object:self userInfo:nil];
}


- (void)socket:(GCDAsyncSocket *)socket didWriteDataWithTag:(long)tag
{
    if (tag == WriteMessageTag) {
        [self.asyncSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:ReadTimeOut tag:ReadRespondTag];
    }
}

- (void)socket:(GCDAsyncSocket *)socket didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    VDLog(@"didReadPartialDataOfLength %@   :   %@", @(partialLength) , @(tag));
}

- (void)socket:(GCDAsyncSocket *)socket didReadData:(NSData *)data withTag:(long)tag
{
    [self onResponse:data];
    if ([self.delegate respondsToSelector:@selector(receiveData:fromSocketClient:)]) {
        [self.delegate receiveData:data fromSocketClient:self];
    }
    [VDDefaultNotificationCenter postNotificationName:VDSocketReceiveResponseDataNotificationEvent object:self userInfo:@{VDSocketReceiveResponseDataNotificationEventUserInfoKeyForData : data}];
    [self.asyncSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:ReadTimeOut tag:ReadRespondTag];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)socket withError:(NSError *)err
{
    self.state = VDSocketClientStateDisconnected;
    [self onDisconnected:err];
    if ([self.delegate respondsToSelector:@selector(disconnectFromServerFromSocketClient:)]) {
        [self.delegate disconnectFromServerFromSocketClient:self];
    }
    if ([self.delegate respondsToSelector:@selector(socketClient:didDisconnectWithError:)]) {
        [self.delegate socketClient:self didDisconnectWithError:err];
    }
    
    NSString *error = @"";
    GCDAsyncSocketError errorType = (GCDAsyncSocketError)err.code;
    switch (errorType) {
        case GCDAsyncSocketNoError: {
            break;
        }
        case GCDAsyncSocketBadConfigError: {
            error = @"配置出现问题";
            break;
        }
        case GCDAsyncSocketBadParamError: {
            error = @"参数出现问题";
            break;
        }
        case GCDAsyncSocketConnectTimeoutError: {
            error = @"连接超时";
            break;
        }
        case GCDAsyncSocketReadTimeoutError: {
            error = @"读取包超时";
            break;
        }
        case GCDAsyncSocketWriteTimeoutError: {
            error = @"写入包超时";
            break;
        }
        case GCDAsyncSocketReadMaxedOutError: {
            error = @"读取池溢出";
            break;
        }
        case GCDAsyncSocketClosedError: {
            error = @"远程关闭连接";
            break;
        }
        case GCDAsyncSocketOtherError: {
            error = @"未知错误";
            break;
        }
        default: {
            break;
        }
    }

    [VDDefaultNotificationCenter postNotificationName:VDSocketDisconnectedNotificationEvent object:self userInfo:@{VDSocketDisconnectedNotificationEventUserInfoKeyForError : error}];
    
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)socket shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length
{
    if (elapsed <= ReadTimeOut)
    {
        [self willConnectingTimeOutFromSocketClient];
        if ([self.delegate respondsToSelector:@selector(willConnectingTimeOutFromSocketClient:)]) {
            [self.delegate willConnectingTimeOutFromSocketClient:self];
        }
        [VDDefaultNotificationCenter postNotificationName:VDSocketConnectingWillTimeOutdNotificationEvent object:self userInfo:nil];
        
        return ReadTimeOutExtension;
    }
    
    return 0.0;
}


#pragma Methods
#pragma Private Class Method

#pragma Private Instance Method

#pragma Public Class Method
+ (instancetype)sharedClient
{
    static id _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [ [ [self class] alloc] init];
    } );
    
    return _sharedClient;
}

#pragma Public Instance Method
//- (void)reloadData 
//{
//    
//}

- (void)connectToServerWithIP:(NSString *)ip port:(NSNumber *)port
{
    if (self.state == VDSocketClientStateConnecting) {
        return;
    }
    NSError *error = nil;
    if (![self.asyncSocket connectToHost:ip onPort:[port integerValue] error:&error] ) {
        [self.asyncSocket.delegate socketDidDisconnect:self.asyncSocket withError:error];
    } else {
        self.state = VDSocketClientStateConnecting;
    }
}

- (void)disconnectFromServer
{
    [self.asyncSocket disconnect];
}

- (void)sendData:(NSData *)data
{
    [self.asyncSocket writeData:data withTimeout:WriteTimeOut tag:WriteMessageTag];
}

- (void)sendString:(NSString *)string {
    NSString *sender = [string stringByAppendingString:VDLineBreakLetter];
    VDLog(@"send %@", sender);
    [self sendData:[sender dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)onConnected {
    
}

- (void)onDisconnected:(NSError *)error {
    
}

- (void)onResponse:(NSData *)data {
    
}

- (void)willConnectingTimeOutFromSocketClient {
    
}

@end
