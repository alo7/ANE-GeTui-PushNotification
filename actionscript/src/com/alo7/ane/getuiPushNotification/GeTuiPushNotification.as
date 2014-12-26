/**
 * Created by jiongli on 14/11/27.
 */
package com.alo7.ane.getuiPushNotification {
    import flash.events.EventDispatcher;
    import flash.events.StatusEvent;
    import flash.external.ExtensionContext;
    import flash.system.Capabilities;

    public class GetuiPushNotification extends EventDispatcher {

        private static const EXTENSION_ID:String = "com.alo7.ane.getuiPushNotification";
        private static const FUN_INITIALIZE_PUSH_NOTIFICAITON:String = "initializePushNotificaiton";
        private static const FUN_START_GETUI_SDK:String = "startGetuiSdk";
        private static const FUN_STOP_GETUI_SDK:String = "stopGetuiSdk";
        private static const FUN_SET_TAG:String = "setTag";



        private static var _instance:GetuiPushNotification;
        private var _extContext:ExtensionContext;
        private var _isDebug:Boolean = false;

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
            if(_instance==null) {
                _instance = new GetuiPushNotification();
            }
            return _instance;
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
                event = new GetuiPushNotificationEvent(GetuiPushNotificationEvent.OTHER_EVENT);
                event.data = level;
                break;
            }
            if (event != null) {

                if(_isDebug){
                    trace("[getui ane event] : " + event.type + " | " + event.data);
                    this.dispatchEvent(event);
                }else if( event.type!=GetuiPushNotificationEvent.OTHER_EVENT){
                    this.dispatchEvent(event);
                }
            }
        }

        /**
         * ios 需要传入以下参数，android 所需参数会从 app.xml 文件中获取，无需传参
         * @param appid
         * @param appKey
         * @param appSecret
         * @param appVersion
         */
        public function initializePushNotificaiton(appid:String="", appKey:String="", appSecret:String="", appVersion:String=""):void {
            if (_extContext) {
                _extContext.call(FUN_INITIALIZE_PUSH_NOTIFICAITON, appid, appKey, appSecret, appVersion);
            }
        }

        /**
         *  恢复个推的服务
         */
        public function startGetuiSdk():void{
            if(_extContext){
                _extContext.call(FUN_START_GETUI_SDK);
            }
        }

        /**
         *  关闭个推的服务
         */
        public function stopGetuiSdk():void{
            if(_extContext){
                _extContext.call(FUN_STOP_GETUI_SDK);
            }
        }

        public function setTag(tag:String):Boolean{
            var result:Boolean = false;
            if(_extContext){
                result = _extContext.call(FUN_SET_TAG,tag);
            }
            return result;
        }

        public function get isDebug():Boolean {
            return _isDebug;
        }

        public function set isDebug(value:Boolean):void {
            _isDebug = value;
        }
    }
}
