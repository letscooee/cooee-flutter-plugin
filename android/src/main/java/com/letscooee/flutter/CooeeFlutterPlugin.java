package com.letscooee.flutter;

import java.util.*;
import java.io.*;

import androidx.annotation.NonNull;

import android.util.Log;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;

import com.letscooee.CooeeSDK;

import com.letscooee.trigger.EngagementTriggerActivity;
import com.letscooee.utils.InAppNotificationClickListener;
import com.letscooee.utils.OnInAppPopListener;
import com.letscooee.utils.OnInAppCloseListener;
import com.letscooee.utils.CooeeSDKConstants;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Context;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Main wrapper of Android's Cooee SDK.
 *
 * @author Abhishek Tapariya
 * @author Raajas Sode
 */
public class CooeeFlutterPlugin implements ActivityAware, FlutterPlugin, MethodCallHandler {

    /// The MethodChannel that will the communication between Flutter and native Android
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private CooeeSDK cooeeSDK;
    private Context context;
    private Activity activity;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "cooee_plugin");
        cooeeSDK = CooeeSDK.getDefaultInstance(flutterPluginBinding.getApplicationContext());
        channel.setMethodCallHandler(this);
        this.context = flutterPluginBinding.getApplicationContext();
        setupPlugin(flutterPluginBinding.getApplicationContext(), flutterPluginBinding.getBinaryMessenger(), null);
        System.out.println("Constant : " + CooeeSDKConstants.LOG_PREFIX);
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
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "cooee_plugin");
        channel.setMethodCallHandler(new CooeeFlutterPlugin());
        CooeeFlutterPlugin plugin = new CooeeFlutterPlugin();
        plugin.setupPlugin(registrar.context(), null, registrar);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
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
        } else if (call.method.equals("updateUserData")) {
            Map<String, String> userData = call.argument("userData");

            try {
                cooeeSDK.updateUserData(userData);
                result.success("User Data Updated ");
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
        } else if (call.method.equals("setCurrentScreen")) {
            try {
                cooeeSDK.setCurrentScreen(call.argument("screenName"));
                result.success(" Screen Name Updated ");
            } catch (Exception e) {
                System.out.println("Exception : " + e);
                result.error(e.toString(), " Screen Name Not Update ", e.getCause());
            }
        } else if (call.method.equals("setBitmap")) {
            try {
                cooeeSDK.setBitmap(call.argument("base64encode"));
                result.success(" Screen Name Updated ");
            } catch (Exception e) {
                System.out.println("Exception : " + e);
                result.error(e.toString(), " Screen Name Not Update ", e.getCause());
            }
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private void invokeMethodOnUiThread(final String methodName, final Map map) {
        final MethodChannel channel = this.channel;
        runOnMainThread(() -> channel.invokeMethod(methodName, map));
    }

    private void runOnMainThread(final Runnable runnable) {
        if (activity != null) {
            activity.runOnUiThread(runnable);
        } else {
            try {
                ((Activity) context).runOnUiThread(runnable);
            } catch (Exception e) {
                Log.e("TAG", "Exception while running on main thread - ");
                e.printStackTrace();
            }
        }


    }

    InAppNotificationClickListener listener = new InAppNotificationClickListener() {
        @Override
        public void onInAppButtonClick(HashMap<String, Object> payload) {
            invokeMethodOnUiThread("onInAppButtonClick", payload);
        }
    };

    OnInAppPopListener onInAppPopListener = new OnInAppPopListener() {
        @Override
        public void onInAppTriggered() {
            android.util.Log.d("TAG", "onInAppTriggered: ");
            invokeMethodOnUiThread("onInAppTriggered", new HashMap());
        }
    };

    OnInAppCloseListener onInAppCloseListener = new OnInAppCloseListener() {
        @Override
        public void onInAppClosed() {
            invokeMethodOnUiThread("onInAppCloseTriggered", new HashMap());
        }
    };

    private void setupPlugin(Context context, BinaryMessenger messenger, Registrar registrar) {
        if (registrar != null) {
            //V1 setup
            this.channel = new MethodChannel(registrar.messenger(), "cooee_plugin");
            this.activity = ((Activity) registrar.activeContext());
        } else {
            //V2 setup
            this.channel = new MethodChannel(messenger, "cooee_plugin");
        }
        this.channel.setMethodCallHandler(this);
        this.context = context.getApplicationContext();
        this.cooeeSDK = CooeeSDK.getDefaultInstance(this.context);
        if (this.cooeeSDK != null) {
            this.cooeeSDK.setInAppNotificationButtonListener(listener);
            EngagementTriggerActivity.onInAppPopListener = onInAppPopListener;
            EngagementTriggerActivity.onInAppCloseListener = onInAppCloseListener;
        }
        System.out.println("Constant : " + CooeeSDKConstants.LOG_PREFIX);
    }

}
