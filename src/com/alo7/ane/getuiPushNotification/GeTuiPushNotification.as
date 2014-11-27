/**
 * Created by jiongli on 14/11/27.
 */
package com.alo7.ane.getuiPushNotification {
    import flash.external.ExtensionContext;
    import flash.system.Capabilities;

    public class GeTuiPushNotification {

        private static const EXTENSION_ID:String = "com.alo7.ane.getuiPushNotification";
        private static const FUN_START_WITH_APP_ARGS:String = "startWithAppArgs";


        private static var _instance:GeTuiPushNotification;
        private var _extContext:ExtensionContext

        public function GeTuiPushNotification() {
            if(!_instance){
                _extContext = ExtensionContext.createExtensionContext(EXTENSION_ID,null);
                if(_extContext==null){
                    trace("extension context is null !!");
                }
            }else{
                throw new Error('This is a singleton, use getInstance, do not call the constructor directly');
            }

        }

        public static function getInstance():GeTuiPushNotification{
            return _instance ? _instance : new GeTuiPushNotification();
        }

        public function get isPushNotificationSupported():Boolean
        {
            var result:Boolean = (Capabilities.manufacturer.search('iOS') > -1 || Capabilities.manufacturer.search('Android') > -1);
            return result;
        }

        public function startWithAppArgs(appid:String,appKey:String,appSecret:String):void{
            if(_extContext){
                _extContext.call(FUN_START_WITH_APP_ARGS,appid,appKey,appSecret);
            }
        }

    }
}
