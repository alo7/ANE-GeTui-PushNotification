/**
 * Created by jiongli on 14/11/27.
 */
package com.alo7.ane.getuiPushNotification {
    import flash.events.EventDispatcher;
    import flash.events.StatusEvent;
    import flash.external.ExtensionContext;
    import flash.system.Capabilities;

    public class GetuiPushNotification extends EventDispatcher {

        private static const EXTENSION_ID:String = "com.alo7.ane.GetuiPushNotification";
        private static const FUN_START_WITH_APP_ARGS:String = "startWithAppArgs";


        private static var _instance:GetuiPushNotification;
        private var _extContext:ExtensionContext

        public function GetuiPushNotification() {
            if (!_instance) {
                if (isPushNotificationSupported) {
                    _extContext = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
                    if (_extContext != null) {
                        _extContext.addEventListener(StatusEvent.STATUS, onStatus);
                    } else {
                        trace("extension context is null !!");
                    }
                } else {
                    trace("current platform is not support for push nofification !!");
                }
            } else {
                throw new Error('This is a singleton, use getInstance, do not call the constructor directly !!');
            }

        }

        public static function getInstance():GetuiPushNotification {
            return _instance ? _instance : new GetuiPushNotification();
        }

        /**
         *  only for ios & andorid device
         */
        public static function get isPushNotificationSupported():Boolean {
            var result:Boolean = (Capabilities.manufacturer.search('iOS') > -1 || Capabilities.manufacturer.search('Android') > -1);
            return result;
        }

        private function onStatus(e:StatusEvent):void {
            var level:String = e.level;
            var event:GetuiPushNotificationEvent;
            switch (e.code) {
                case GetuiPushNotificationEvent.TOKEN_SUCCESS:
                    event = new GetuiPushNotificationEvent(GetuiPushNotificationEvent.TOKEN_SUCCESS);
                    event.data = level;
                    break;
                case GetuiPushNotificationEvent.TOKEN_FAIL:
                    event = new GetuiPushNotificationEvent(GetuiPushNotificationEvent.TOKEN_FAIL);
                    event.data = level;
                    break;
                case GetuiPushNotificationEvent.GETUI_DID_REGISTER_CLIENT:
                    event = new GetuiPushNotificationEvent(GetuiPushNotificationEvent.GETUI_DID_REGISTER_CLIENT);
                    event.data = level;
                    break;
                case GetuiPushNotificationEvent.GETUI_DID_RECEIVE_PAYLOAD:
                    event = new GetuiPushNotificationEvent(GetuiPushNotificationEvent.GETUI_DID_RECEIVE_PAYLOAD);
                    event.data = level;
                    break;
                case GetuiPushNotificationEvent.GETUI_DID_OCCUR_ERROR:
                    event = new GetuiPushNotificationEvent(GetuiPushNotificationEvent.GETUI_DID_OCCUR_ERROR);
                    event.data = level;
                    break;
                default:
                    break;
            }
            trace("[getui ane event] : " + e.level + " , " + e.code);
            if (event != null) {
                dispatchEvent(event);
            }
        }

        public function startWithAppArgs(appid:String, appKey:String, appSecret:String, appVersion:String):void {
            if (_extContext) {
                _extContext.call(FUN_START_WITH_APP_ARGS, appid, appKey, appSecret, appVersion);
            }
        }



    }
}
