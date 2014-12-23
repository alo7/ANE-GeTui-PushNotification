//
//  GetuiDelegate.m
//  GetuiPushNotification
//
//  Created by jiong.li on 14/11/28.
//
//

#import "GetuiDelegateImpl.h"

@implementation GetuiDelegateImpl

@synthesize freContext = _freContext;
@synthesize gexinPusher = _gexinPusher;
@synthesize appKey = _appKey;
@synthesize appSecret = _appSecret;
@synthesize appVersion = _appVersion;
@synthesize appID = _appID;
@synthesize clientId = _clientId;
@synthesize sdkStatus = _sdkStatus;
@synthesize lastPayloadIndex = _lastPaylodIndex;
@synthesize payloadId = _payloadId;

-(void)dealloc
{
    [_deviceToken release];
    [_gexinPusher release];
    [_appKey release];
    [_appSecret release];
    [_appID release];
    [_appVersion release];
    [_clientId release];
    [_payloadId release];
    
    [super dealloc];
}


// 注册消息推送
- (void)registerRemoteNotification
{
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
}

// 注册成功
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    [_deviceToken release];
    _deviceToken = [[token stringByReplacingOccurrencesOfString:@" " withString:@""] retain];
   
    if ( _freContext != nil )
    {
        FREDispatchStatusEventAsync(_freContext, (uint8_t*)"TOKEN_SUCCESS", (uint8_t*)[_deviceToken UTF8String]);
    }
    
       // [3]:向个推服务器注册deviceToken
    if (_gexinPusher) {
        [_gexinPusher registerDeviceToken:_deviceToken];
    }
}

//注册失败
- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    
    NSString* tokenString = [NSString stringWithFormat:@"Failed to get token, error: %@",error];
    
    if ( _freContext != nil )
    {
        FREDispatchStatusEventAsync(_freContext, (uint8_t*)"TOKEN_FAIL", (uint8_t*)[tokenString UTF8String]);
    }
    
    // [3-EXT]:如果APNS注册失败，通知个推服务器
    if (_gexinPusher) {
        [_gexinPusher registerDeviceToken:@""];
    }
}

- (void)didReceiveRemoteNotification:(NSDictionary *)userinfo
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // [4-EXT]:处理APN
    NSString *payloadMsg = [userinfo objectForKey:@"payload"];
    NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
//    NSLog(@"%@",record);
    if ( _freContext != nil )
    {
        FREDispatchStatusEventAsync(_freContext, (uint8_t*)"RECEIVE_REMOTE_NOTIFICATION", (uint8_t*)[record UTF8String]);
    }
}


- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret appVersion:(NSString *)appVersion
{
    if (!_gexinPusher) {
        _sdkStatus = SdkStatusStoped;
        
        self.appID = appID;
        self.appKey = appKey;
        self.appSecret = appSecret;
        self.appVersion = appVersion;
        
        [_clientId release];
        _clientId = nil;
        
        NSError *err = nil;
        _gexinPusher = [GexinSdk createSdkWithAppId:_appID
                                             appKey:_appKey
                                          appSecret:_appSecret
                                         appVersion:_appVersion
                                           delegate:self
                                              error:&err];
        if (_gexinPusher) {
            _sdkStatus = SdkStatusStarting;
        }
        
    }
}

- (void)stopSdk
{
    if (_gexinPusher) {
        [_gexinPusher destroy];
        [_gexinPusher release];
        _gexinPusher = nil;
        
        _sdkStatus = SdkStatusStoped;
        
        [_clientId release];
        _clientId = nil;
        
    }
}

- (void)startOrStopSdk
{
    if (_sdkStatus == SdkStatusStoped) {
        [self startSdkWith:_appID appKey:_appKey appSecret:_appSecret appVersion:_appVersion ];
    } else {
        [self stopSdk];
    }
}

- (BOOL)checkSdkInstance
{
    if (!_gexinPusher) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"SDK未启动" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        [alertView release];
        return NO;
    }
    return YES;
}

- (void)setDeviceToken:(NSString *)aToken
{
    if (![self checkSdkInstance]) {
        return;
    }
    
    [_gexinPusher registerDeviceToken:aToken];
}

- (BOOL)setTags:(NSArray *)aTags error:(NSError **)error
{
    if (![self checkSdkInstance]) {
        return NO;
    }
    
    return [_gexinPusher setTags:aTags];
}

- (NSString *)sendMessage:(NSData *)body error:(NSError **)error {
    if (![self checkSdkInstance]) {
        return nil;
    }
    
    return [_gexinPusher sendMessage:body error:error];
}


#pragma mark - GexinSdkDelegate
- (void)GexinSdkDidRegisterClient:(NSString *)clientId
{
    // [4-EXT-1]: 个推SDK已注册
    _sdkStatus = SdkStatusStarted;
    [_clientId release];
    _clientId = [clientId retain];
    
    if ( _freContext != nil )
    {
        FREDispatchStatusEventAsync(_freContext, (uint8_t*)"GETUI_DID_REGISTER_CLIENT", (uint8_t*)[_clientId UTF8String]);
    }
}

- (void)GexinSdkDidReceivePayload:(NSString *)payloadId fromApplication:(NSString *)appId
{
    // [4]: 收到个推消息
    [_payloadId release];
    _payloadId = [payloadId retain];
    
    NSData *payload = [_gexinPusher retrivePayloadById:payloadId];
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                                              length:payload.length
                                            encoding:NSUTF8StringEncoding];
        if ( _freContext != nil )
        {
            NSString *record = [NSString stringWithFormat:@"%d, %@, %@", ++_lastPaylodIndex, [NSDate date], payloadMsg];
            FREDispatchStatusEventAsync(_freContext, (uint8_t*)"GETUI_DID_RECEIVE_PAYLOAD", (uint8_t*)[record UTF8String]);
        }
    }

    [payloadMsg release];
}

- (void)GexinSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
//    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
}

- (void)GexinSdkDidOccurError:(NSError *)error
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
//    [_viewController logMsg:[NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]];
    if ( _freContext != nil )
    {
        NSString *logMsg = [NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]];
        FREDispatchStatusEventAsync(_freContext, (uint8_t*)"GETUI_DID_OCCUR_ERROR", (uint8_t*)[logMsg UTF8String]);
    }
    
}


@end

