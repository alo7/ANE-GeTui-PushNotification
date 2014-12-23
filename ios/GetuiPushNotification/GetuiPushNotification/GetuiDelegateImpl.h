//
//  GetuiDelegate.h
//  GetuiPushNotification
//
//  Created by jiong.li on 14/11/28.
//
//

#import <UIKit/UIKit.h>
#import "GexinSdk.h"
#import "FlashRuntimeExtensions.h"

typedef enum {
    SdkStatusStoped,
    SdkStatusStarting,
    SdkStatusStarted
} SdkStatus;

@interface GetuiDelegateImpl : NSObject <GexinSdkDelegate>

@property (assign, nonatomic) FREContext freContext;
@property (strong, nonatomic) GexinSdk *gexinPusher;
@property (retain, nonatomic) NSString *deviceToken;
@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *appSecret;
@property (retain, nonatomic) NSString *appID;
@property (retain, nonatomic) NSString *appVersion;
@property (retain, nonatomic) NSString *clientId;
@property (assign, nonatomic) SdkStatus sdkStatus;
@property (assign, nonatomic) int lastPayloadIndex;
@property (retain, nonatomic) NSString *payloadId;


- (void)registerRemoteNotification;
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken;
- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError*)error;
- (void)didReceiveRemoteNotification:(NSDictionary *)userinfo;
- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret appVersion:(NSString *)appVersion;
- (void)stopSdk;
- (void)startOrStopSdk;

- (void)setDeviceToken:(NSString *)aToken;
- (BOOL)setTags:(NSArray *)aTag error:(NSError **)error;
- (NSString *)sendMessage:(NSData *)body error:(NSError **)error;




@end
