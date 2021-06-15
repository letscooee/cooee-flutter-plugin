package com.letscooee.flutter;

import com.letscooee.init.AppController;

/**
 * Manage and bind {@link ActivityLifecycleCallbacks} and
 * by extending {@link AppController} gives control to
 * Native Android SDK.
 *
 * @author Ashish Gaikwad on 11/06/21
 * @version 0.0.24
 */
public class FlutterPluginController extends AppController {

    @Override
    public void onCreate() {
        super.onCreate();

        registerActivityLifecycleCallbacks(new ActivityLifecycle());
    }
}
