/*
 
 Copyright (c) 2012, DIVIJ KUMAR
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met: 
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer. 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution. 
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 The views and conclusions contained in the software and documentation are those
 of the authors and should not be interpreted as representing official policies, 
 either expressed or implied, of the FreeBSD Project.
 
 
 */

/*
 * GetuiPushNotification.m
 * GetuiPushNotification
 *
 * Created by jiong.li on 14/11/27.
 * Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
 */

#import <objc/runtime.h>
#import <objc/message.h>
#import "GetuiPushNotification.h"
#import "GetuiDelegateImpl.h"


@implementation GetuiPushNotification

//empty delegate functions, stubbed signature is so we can find this method in the delegate
//and override it with our custom implementation
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{}

//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{return YES;}


+ (void) cancelAllLocalNotificationsWithId:(NSNumber*) notifId
{
    // we remove all notifications with the localNotificationId
    for (UILocalNotification* notif in [UIApplication sharedApplication].scheduledLocalNotifications)
    {
        if (notif.userInfo != nil)
        {
            if ([notif.userInfo objectForKey:[notifId stringValue]])
            {
                [[UIApplication sharedApplication] cancelLocalNotification:notif];
            }
        } else if ([notifId intValue] == 0) // for migration purpose (all the notifications without userInfo will be removed)
        {
            [[UIApplication sharedApplication] cancelLocalNotification:notif];
        }
    }
}


@end


GetuiDelegateImpl *getuiDelegate;
FREContext myCtx = nil;

//custom implementations of empty signatures above. Used for push notification delegate implementation.
void didRegisterForRemoteNotificationsWithDeviceToken(id self, SEL _cmd, UIApplication* application, NSData* deviceToken)
{
    NSLog(@"ANE_GETUI: didRegisterForRemoteNotificationsWithDeviceToken ");
    if(getuiDelegate){
        [getuiDelegate didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    }
}

//custom implementations of empty signatures above. Used for push notification delegate implementation.
void didFailToRegisterForRemoteNotificationsWithError(id self, SEL _cmd, UIApplication* application, NSError* error)
{
    NSLog(@"ANE_GETUI: didFailToRegisterForRemoteNotificationsWithError ");
    if(getuiDelegate){
        [getuiDelegate didFailToRegisterForRemoteNotificationsWithError:error];
    }
}

//custom implementations of empty signatures above. Used for push notification delegate implementation.
void didReceiveRemoteNotification(id self, SEL _cmd, UIApplication* application,NSDictionary *userInfo)
{
    NSLog(@"ANE_GETUI: didReceiveRemoteNotification ");
    if(getuiDelegate){
        [getuiDelegate didReceiveRemoteNotification:userInfo];
    }

}

//custom implementations of empty signatures above. Used for push notification delegate implementation.
//BOOL didFinishLaunchingWithOptions(id self,SEL _cmd, UIApplication* application,NSDictionary* launchOptions)
//{
//    NSLog(@"ANE_GETUI: didFinishLaunchingWithOptions:%@ ",launchOptions);
//    return YES;
//}



/* GetuiPushNotificationExtInitializer()
 * The extension initializer is called the first time the ActionScript side of the extension
 * calls ExtensionContext.createExtensionContext() for any context.
 *
 * Please note: this should be same as the <initializer> specified in the extension.xml 
 */
void GetuiPushNotificationExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) 
{
    NSLog(@"Entering GetuiPushNotificationExtInitializer()");

    *extDataToSet = NULL;
    *ctxInitializerToSet = &ContextInitializer;
    *ctxFinalizerToSet = &ContextFinalizer;

    NSLog(@"Exiting GetuiPushNotificationExtInitializer()");
}

/* GetuiPushNotificationExtFinalizer()
 * The extension finalizer is called when the runtime unloads the extension. However, it may not always called.
 *
 * Please note: this should be same as the <finalizer> specified in the extension.xml 
 */
void GetuiPushNotificationExtFinalizer(void* extData) 
{
    NSLog(@"Entering GetuiPushNotificationExtFinalizer()");

    // Nothing to clean up.
    NSLog(@"Exiting GetuiPushNotificationExtFinalizer()");
    return;
}

/* ContextInitializer()
 * The context initializer is called when the runtime creates the extension context instance.
 */
void ContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    NSLog(@"Entering ContextInitializer()");
    
    //injects our modified delegate functions into the sharedApplication delegate
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    Class objectClass = object_getClass(delegate);
    
    NSString *newClassName = [NSString stringWithFormat:@"Custom_%@", NSStringFromClass(objectClass)];
    Class modDelegate = NSClassFromString(newClassName);
    if (modDelegate == nil) {
        // this class doesn't exist; create it
        // allocate a new class
        modDelegate = objc_allocateClassPair(objectClass, [newClassName UTF8String], 0);
        
        SEL selectorToOverride1 = @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:);
        
        SEL selectorToOverride2 = @selector(application:didFailToRegisterForRemoteNotificationsWithError:);
        
        SEL selectorToOverride3 = @selector(application:didReceiveRemoteNotification:);
        
//        SEL selectorToOverride4 = @selector(application:didFinishLaunchingWithOptions:);
        
        // get the info on the method we're going to override
        Method m1 = class_getInstanceMethod(objectClass, selectorToOverride1);
        Method m2 = class_getInstanceMethod(objectClass, selectorToOverride2);
        Method m3 = class_getInstanceMethod(objectClass, selectorToOverride3);
//        Method m4 = class_getInstanceMethod(objectClass, selectorToOverride4);
        
        // add the method to the new class
        class_addMethod(modDelegate, selectorToOverride1, (IMP)didRegisterForRemoteNotificationsWithDeviceToken, method_getTypeEncoding(m1));
        class_addMethod(modDelegate, selectorToOverride2, (IMP)didFailToRegisterForRemoteNotificationsWithError, method_getTypeEncoding(m2));
        class_addMethod(modDelegate, selectorToOverride3, (IMP)didReceiveRemoteNotification, method_getTypeEncoding(m3));
//        class_addMethod(modDelegate, selectorToOverride4, (IMP)didFinishLaunchingWithOptions, method_getTypeEncoding(m4));
        
        // register the new class with the runtime
        objc_registerClassPair(modDelegate);
    }
    // change the class of the object
    object_setClass(delegate, modDelegate);
    
    ///////// end of delegate injection / modification code
    
    
    
    /* The following code describes the functions that are exposed by this native extension to the ActionScript code.
     */
    static FRENamedFunction func[] = 
    {
        MAP_FUNCTION(isSupported, NULL),
        MAP_FUNCTION(initializePushNotificaiton, NULL),
        MAP_FUNCTION(startGetuiSdk, NULL),
        MAP_FUNCTION(stopGetuiSdk, NULL),
        MAP_FUNCTION(setTag, NULL),
        MAP_FUNCTION(sendLocalNotification, NULL),
        MAP_FUNCTION(cancelLocalNotification, NULL),
        MAP_FUNCTION(setIsAppInForeground, NULL)
    };
    
    *numFunctionsToTest = sizeof(func) / sizeof(FRENamedFunction);
    *functionsToSet = func;
    
    myCtx = ctx;
    NSLog(@"Exiting ContextInitializer()");
}

/* ContextFinalizer()
 * The context finalizer is called when the extension's ActionScript code
 * calls the ExtensionContext instance's dispose() method.
 * If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls ContextFinalizer().
 */
void ContextFinalizer(FREContext ctx) 
{
    NSLog(@"Entering ContextFinalizer()");

    // Nothing to clean up.
    NSLog(@"Exiting ContextFinalizer()");
    return;
}


/* This is a TEST function that is being included as part of this template. 
 *
 * Users of this template are expected to change this and add similar functions 
 * to be able to call the native functions in the ANE from their ActionScript code
 */
ANE_FUNCTION(isSupported)
{
    NSLog(@"Entering IsSupported()");
    
    FREObject fo;
    
    FREResult aResult = FRENewObjectFromBool(YES, &fo);
    NSLog(@"Result = %d", aResult);
	return fo;
}

ANE_FUNCTION(initializePushNotificaiton){
    NSString *kAppId = getStringFromFREObject(argv[0]);
    NSString *kAppKey = getStringFromFREObject(argv[1]);
    NSString *kAppSecret = getStringFromFREObject(argv[2]);
    NSString *kAppVersion = getStringFromFREObject(argv[3]);
    
    NSLog(@"start with app args:%@,%@,%@,%@",kAppId,kAppKey,kAppSecret,kAppVersion);
    
    getuiDelegate = [[GetuiDelegateImpl alloc] init];
    if(getuiDelegate){
        getuiDelegate.freContext = myCtx;
        
        // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
        [getuiDelegate startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret appVersion:kAppVersion];
        
        // [2]:注册APNS
        [getuiDelegate registerRemoteNotification];

    }
    return NULL;
}

ANE_FUNCTION(startGetuiSdk){
    if(getuiDelegate && getuiDelegate.sdkStatus==SdkStatusStoped){
        [getuiDelegate startOrStopSdk];
    }
    return NULL;
}

ANE_FUNCTION(stopGetuiSdk){
    if(getuiDelegate && getuiDelegate.sdkStatus != SdkStatusStoped){
        [getuiDelegate startOrStopSdk];
    }
    return NULL;
}

ANE_FUNCTION(setTag){
    NSString *tagName = getStringFromFREObject(argv[0]);
    NSArray *tagNames = [tagName componentsSeparatedByString:@","];
    NSError *err = nil;
    BOOL success = false;
    if(getuiDelegate){
      success = [getuiDelegate setTags:tagNames error:&err];
    }
    return createFREBool(success);
}

// sends local notification to the device.
ANE_FUNCTION(sendLocalNotification)
{
    
    uint32_t string_length;
    const uint8_t *utf8_message;
    // message
    if (FREGetObjectAsUTF8(argv[0], &string_length, &utf8_message) != FRE_OK)
    {
        return nil;
    }
    
    NSString* message = [NSString stringWithUTF8String:(char*)utf8_message];
    
    // timestamp
    uint32_t timestamp;
    if (FREGetObjectAsUint32(argv[1], &timestamp) != FRE_OK)
    {
        return nil;
    }
    
    // recurrence
    uint32_t recurrence = 0;
    if (argc >= 4 )
    {
        FREGetObjectAsUint32(argv[3], &recurrence);
    }
    
    // local notif id: 0 is default
    uint32_t localNotificationId = 0;
    if (argc == 5)
    {
        if (FREGetObjectAsUint32(argv[4], &localNotificationId) != FRE_OK)
        {
            localNotificationId = 0;
        }
    }
    
    NSNumber *localNotifIdNumber =[NSNumber numberWithInt:localNotificationId];
    
    [GetuiPushNotification cancelAllLocalNotificationsWithId:localNotifIdNumber];
    
    NSDate *itemDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return NULL;
    localNotif.fireDate = itemDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotif.alertBody = message;
    localNotif.alertAction = @"View Details";
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    
    localNotif.userInfo = [NSDictionary dictionaryWithObject:@"" forKey:[localNotifIdNumber stringValue]];
    if (recurrence > 0)
    {
        if (recurrence == 1)
        {
            localNotif.repeatInterval = NSDayCalendarUnit;
        } else if (recurrence == 2)
        {
            localNotif.repeatInterval = NSWeekCalendarUnit;
        } else if (recurrence == 3)
        {
            localNotif.repeatInterval = NSMonthCalendarUnit;
        } else if (recurrence == 4)
        {
            localNotif.repeatInterval = NSYearCalendarUnit;
        }
        
    }
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [localNotif release];
    return NULL;
}

// sends local notification to the device.
ANE_FUNCTION(cancelLocalNotification)
{
    uint32_t localNotificationId;
    if (argc == 1)
    {
        if (FREGetObjectAsUint32(argv[0], &localNotificationId) != FRE_OK)
        {
            return nil;
        }
    } else
    {
        localNotificationId = 0;
    }
    
    [GetuiPushNotification cancelAllLocalNotificationsWithId:[NSNumber numberWithInt:localNotificationId]];
    return nil;
    
}

// nothing to do for ios
ANE_FUNCTION(setIsAppInForeground)
{
    return NULL;
}

//将FREObject转成NSString
NSString * getStringFromFREObject(FREObject obj)
{
    uint32_t length;
    const uint8_t *value;
    FREGetObjectAsUTF8(obj, &length, &value);
    return [NSString stringWithUTF8String:(const char *)value];
}
//将BOOL转成FREObject
FREObject createFREBool(BOOL value)
{
    FREObject fo;
    FRENewObjectFromBool(value, &fo);
    return fo;
}
//发送消息到as
void dispatchExtensionStatusEvent(const uint8_t* code ,const uint8_t* level){
    if (myCtx != nil) {
        FREDispatchStatusEventAsync(myCtx, code, level);
    }
}


