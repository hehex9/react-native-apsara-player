package cn.whenpigsfly.rn.apsara;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.uimanager.IllegalViewOperationException;
import com.facebook.react.uimanager.NativeViewHierarchyManager;
import com.facebook.react.uimanager.UIBlock;
import com.facebook.react.uimanager.UIManagerModule;

import java.util.Map;

public class ApsaraPlayerModule extends ReactContextBaseJavaModule {
    private ReactApplicationContext mReactContext;

    @Override
    public String getName() {
        return "ApsaraPlayerModule";
    }

    public ApsaraPlayerModule(ReactApplicationContext context) {
        super(context);
        mReactContext = context;
    }

    @ReactMethod
    public void save(final ReadableMap options, final int reactTag, final Promise promise) {
        try {
            UIManagerModule uiManager = mReactContext.getNativeModule(UIManagerModule.class);
            uiManager.addUIBlock(new UIBlock() {
                public void execute (NativeViewHierarchyManager nvhm) {
                    ApsaraPlayerView view = (ApsaraPlayerView) nvhm.resolveView(reactTag);
                    view.save(options, promise);
                }
            });
        } catch (IllegalViewOperationException e) {
            promise.reject("ERROR", e);
        }
    }
}
