package com.letscooee.flutter;

/**
 * Manage and bind {@link ActivityLifecycleCallbacks} and
 * by extending {@link com.letscooee.init.AppController} gives control to
 * Native Android SDK.
 *
 * @author Ashish Gaikwad on 11/06/21
 * @version 0.0.24
 */
public class AppController extends com.letscooee.init.AppController {

    @Override
    public void onCreate() {
        super.onCreate();

        registerActivityLifecycleCallbacks(new ActivityLifecycle());
    }
}
