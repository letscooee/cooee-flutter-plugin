package com.letscooee.flutter;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.letscooee.CooeeSDK;
import com.letscooee.utils.CooeeCTAListener;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.renderer.FlutterRenderer;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * Main wrapper of Android's Cooee SDK.
 *
 * @author Abhishek Tapariya
 * @author Raajas Sode
 */
public class CooeeFlutterPlugin implements ActivityAware, FlutterPlugin, MethodCallHandler {

    private static CooeeFlutterPlugin INSTANCE;

    /// The MethodChannel that will the communication between Flutter and native Android
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private CooeeSDK cooeeSDK;
    private Context context;
    private Activity activity;
    private FlutterRenderer flutterRenderer;

    public static CooeeFlutterPlugin getInstance() {
        return INSTANCE;
    }

    public CooeeFlutterPlugin() {
        INSTANCE = this;
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "cooee_plugin");
        cooeeSDK = CooeeSDK.getDefaultInstance(flutterPluginBinding.getApplicationContext());
        channel.setMethodCallHandler(this);
        flutterRenderer = (FlutterRenderer) flutterPluginBinding.getTextureRegistry();
        this.context = flutterPluginBinding.getApplicationContext();
        setupPlugin(flutterPluginBinding.getApplicationContext(), flutterPluginBinding.getBinaryMessenger(), null);
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
            Map<String, Object> userData = call.argument("userData");

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

    CooeeCTAListener listener = new CooeeCTAListener() {
        @Override
        public void onResponse(HashMap<String, Object> payload) {
            invokeMethodOnUiThread("onInAppButtonClick", payload);
        }
    };

    public FlutterRenderer getFlutterRenderer() {
        return flutterRenderer;
    }

    private void setupPlugin(Context context, BinaryMessenger messenger, Registrar registrar) {
        this.context = context.getApplicationContext();
        if (registrar != null) {
            //V1 setup
            this.channel = new MethodChannel(registrar.messenger(), "cooee_plugin");
            this.activity = ((Activity) registrar.activeContext());
        } else {
            //V2 setup
            this.channel = new MethodChannel(messenger, "cooee_plugin");
        }

        this.channel.setMethodCallHandler(this);
        this.cooeeSDK = CooeeSDK.getDefaultInstance(this.context);
        if (this.cooeeSDK != null) {
            this.cooeeSDK.setCTAListener(listener);
        }
    }
}
