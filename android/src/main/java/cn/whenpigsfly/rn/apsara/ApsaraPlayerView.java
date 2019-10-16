package cn.whenpigsfly.rn.apsara;

import android.os.Environment;
import android.widget.FrameLayout;

import com.aliyun.downloader.AliDownloaderFactory;
import com.aliyun.downloader.AliMediaDownloader;
import com.aliyun.player.AliPlayer;
import com.aliyun.player.AliPlayerFactory;
import com.aliyun.player.bean.ErrorInfo;
import com.aliyun.player.bean.InfoBean;
import com.aliyun.player.bean.InfoCode;
import com.aliyun.player.nativeclass.MediaInfo;
import com.aliyun.player.nativeclass.TrackInfo;
import com.aliyun.player.source.VidSts;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.events.RCTEventEmitter;

import java.util.List;
import java.util.Map;

public class ApsaraPlayerView extends FrameLayout implements
        AliPlayer.OnInfoListener,
        AliPlayer.OnErrorListener,
        AliPlayer.OnPreparedListener,
        AliPlayer.OnSeekCompleteListener {

    public enum Events {
        EVENT_LOAD("onVideoLoad"),
        EVENT_SEEK("onVideoSeek"),
        EVENT_ERROR("onVideoError"),
        EVENT_PROGRESS("onVideoProgress");

        private final String mName;

        Events(final String name) {
            mName = name;
        }

        @Override
        public String toString() {
            return mName;
        }
    }

    private ThemedReactContext mContext;
    private RCTEventEmitter mEventEmitter;
    private AliMediaDownloader mDownloader = null;
    private Promise mDownloaderPromise;

    private Map<String, String> mOptions;
    private AliPlayer mPlayer;
    private boolean mPrepared = false;
    private boolean mRepeat;
    private String mVid;

    public ApsaraPlayerView(ThemedReactContext context, AliPlayer player) {
        super(context);

        mContext = context;
        mPlayer = player;
        mEventEmitter = context.getJSModule(RCTEventEmitter.class);

        init();
    }

    public void init() {
        if (mPlayer != null) {
            return;
        }

        mPlayer = AliPlayerFactory.createAliPlayer(mContext);

        prepare();
    }

    public void prepare() {
        if (mVid == null || mVid.isEmpty()) {
            return;
        }

        VidSts sts = getStsSource();
        if (sts == null) {
            return;
        }

        mPlayer.setDataSource(sts);
        mPlayer.prepare();

        mPlayer.setOnInfoListener(this);
        mPlayer.setOnErrorListener(this);
        mPlayer.setOnPreparedListener(this);
        mPlayer.setOnSeekCompleteListener(this);

        if (mRepeat) {
            mPlayer.setAutoPlay(true);
        }

        mPrepared = true;
    }

    public void setVid(final String vid) {
        mVid = vid;

        if (!mPrepared) {
            prepare();
        }
    }

    public void setPaused(final boolean paused) {
        if (paused) {
            mPlayer.pause();
        } else {
            mPlayer.start();
        }
    }

    public void setRepeat(final boolean repeat) {
        mRepeat = repeat;
        mPlayer.setLoop(repeat);
    }

    public void setMuted(final boolean muted) {
        mPlayer.setMute(muted);
    }

    public void setVolume(final float volume) {
        mPlayer.setVolume(volume);
    }

    public void setOptions(final Map options) {
        mOptions = options;
        prepare();
    }

    public void setSeek(long position) {
        mPlayer.seekTo(position);
    }

    public VidSts getStsSource() {
        if (mOptions == null
                || mOptions.get("accessKeyId").isEmpty()
                || mOptions.get("accessKeySecret").isEmpty()
                || mOptions.get("securityToken").isEmpty()) {
            return null;
        }

        VidSts sts = new VidSts();
        sts.setVid(mVid);
        sts.setAccessKeyId(mOptions.get("accessKeyId"));
        sts.setAccessKeySecret(mOptions.get("accessKeySecret"));
        sts.setSecurityToken(mOptions.get("securityToken"));
        sts.setRegion(mOptions.containsKey("region") ? mOptions.get("region") : "");
        return sts;
    }

    @Override
    public void onInfo(InfoBean info) {
        if (info.getCode() == InfoCode.CurrentPosition) {
            WritableMap map = Arguments.createMap();
            map.putDouble("currentTime", info.getExtraValue());
            mEventEmitter.receiveEvent(getId(), Events.EVENT_PROGRESS.toString(), map);
        }
    }

    @Override
    public void onError(ErrorInfo errorInfo) {
        WritableMap map = Arguments.createMap();
        map.putInt("code", errorInfo.getCode().getValue());
        map.putString("message", errorInfo.getMsg());
        mEventEmitter.receiveEvent(getId(), Events.EVENT_ERROR.toString(), map);

        mPlayer.release();
    }

    @Override
    public void onPrepared() {
        WritableMap map = Arguments.createMap();
        map.putDouble("duration", mPlayer.getDuration());
        mEventEmitter.receiveEvent(getId(), Events.EVENT_LOAD.toString(), map);
    }

    @Override
    public void onSeekComplete() {
        WritableMap map = Arguments.createMap();
        map.putDouble("currentTime", mPlayer.getDuration());
        mEventEmitter.receiveEvent(getId(), Events.EVENT_SEEK.toString(), null);
    }

    public void save(ReadableMap options, Promise promise) {
        mDownloaderPromise = promise;
        mDownloader = AliDownloaderFactory.create(mContext.getApplicationContext());
        mDownloader.setSaveDir(
                Environment
                        .getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
                        .getAbsolutePath()
        );
        mDownloader.prepare(getStsSource());

        mDownloader.setOnCompletionListener(new AliMediaDownloader.OnCompletionListener() {
            @Override
            public void onCompletion() {
                if (mDownloaderPromise == null) {
                    return;
                }

                WritableMap map = Arguments.createMap();
                map.putString("uri", mDownloader.getFilePath());
                mDownloaderPromise.resolve(map);
                release();
            }
        });

        mDownloader.setOnPreparedListener(new AliMediaDownloader.OnPreparedListener() {
            @Override
            public void onPrepared(MediaInfo mediaInfo) {
                List<TrackInfo> trackInfos = mediaInfo.getTrackInfos();
                mDownloader.selectItem(trackInfos.get(0).getIndex());
                mDownloader.start();
            }
        });

        mDownloader.setOnErrorListener(new AliMediaDownloader.OnErrorListener() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                if (mDownloaderPromise != null) {
                    mDownloaderPromise.reject(new Exception(errorInfo.getMsg()));
                }

                release();
            }
        });
    }

    public void release() {
        if (mDownloader == null) {
            return;
        }

        mDownloader.stop();
        mDownloader.release();
    }
}
