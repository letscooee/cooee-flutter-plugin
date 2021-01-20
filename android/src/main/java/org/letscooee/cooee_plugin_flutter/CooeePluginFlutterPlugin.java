package org.letscooee.cooee_plugin_flutter;

import java.util.*;
import java.io.*;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import com.letscooee.cooeesdk.CooeeSDK;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * CooeePluginFlutterPlugin
 */
public class CooeePluginFlutterPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private CooeeSDK cooeeSDK;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "cooee_plugin_flutter");
        cooeeSDK = CooeeSDK.getDefaultInstance(flutterPluginBinding.getApplicationContext());
        channel.setMethodCallHandler(this);
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "hello");
        channel.setMethodCallHandler(new CooeePluginFlutterPlugin());
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("sendEvent")) {

            try {

                cooeeSDK.sendEvent(call.argument("eventName"), call.argument("eventProperties"));
                result.success(" Event Sent ");
            } catch (Exception e) {
                System.out.println("Exception : " + e);
                result.error(e.toString(), " Event Not Sent", e.getCause());
                e.printStackTrace();
            }
            finally{
                System.out.println(call.argument("eventName").toString());
            }
        } else if (call.method.equals("updateUserData")) {
//            System.out.println(call.argument("userData").toString());
            Map<String, String> userData = call.argument("userData");
            System.out.println("UserData"+userData.toString());
            try {

                cooeeSDK.updateUserData(userData);
                result.success(" User Data Updated ");
            } catch (Exception e) {
                System.out.println("Exception : " + e);
                result.error(e.toString(), " User Data Not Updated ", e.getCause());
                e.printStackTrace();
            }
        } else if (call.method.equals("updateUserProperties")) {

            try {
                cooeeSDK.updateUserProperties(call.argument("userProperties"));
                result.success(" User Properties Updated ");
            } catch (Exception e) {
                System.out.println("Exception : " + e);
                result.error(e.toString(), " User Properties Updated Failed ", e.getCause());
                e.printStackTrace();
            }
        } else if (call.method.equals("setScreenName")) {
            //Not working on version 0.0.3, will be implemented on next version
        /*  try{
            cooeeSDK.updateScreenName(String.valueOf(call.arguments));
            result.success(" Screen Name Updated ");
          }
          catch(Exception e){
            System.out.println("Exception : "+e);
            result.error(e," Screen Name Not Update ",e.getCause());
          }

         */
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private Map<String, String> toMap(JSONObject jsonobj) throws JSONException {
        Map<String, String> map = new HashMap<String, String>();
        Iterator<String> keys = jsonobj.keys();
        while (keys.hasNext()) {
            String key = keys.next();
            String value = jsonobj.getString(key);
            map.put(key, value);
        }

        return map;


    }
}
