//
//  GetuiDelegate.h
//  GetuiPushNotification
//
//  Created by jiong.li on 14/11/28.
//
//

#import <UIKit/UIKit.h>
#import "GeTuiSdk.h"
#import "FlashRuntimeExtensions.h"

@interface GetuiDelegateImpl : NSObject <GeTuiSdkDelegate> {
@private

}

@property (assign, nonatomic) FREContext freContext;

@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *appSecret;
@property (retain, nonatomic) NSString *appID;

@property (assign, nonatomic) int lastPayloadIndex;


- (void)registerRemoteNotification;
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken;
- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError*)error;
- (void)didReceiveRemoteNotification:(NSDictionary *)userinfo;

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret;
- (void)stopSdk;
- (void)reStartSdk;

- (void)setDeviceToken:(NSString *)aToken;
- (BOOL)setTags:(NSArray *)aTag error:(NSError **)error;
- (NSString *)sendMessage:(NSData *)body error:(NSError **)error;

- (NSString *)getVersion;

//- (void)testSdkFunction;
//- (void)testGetClientId;

+ (NSString*)convertToJSonString:(NSDictionary*)dict;


@end
