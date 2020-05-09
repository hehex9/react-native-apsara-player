## react-native-apsara-player
A react-native wrapper around [aliyun video player](https://help.aliyun.com/document_detail/125579.html)

Check the [example](example) for more details


### Installation

Using npm:
```shell
npm install --save react-native-apsara-player
```

or yarn:
```shell
yarn add --save react-native-apsara-player
```

<details>
  <summary>Standard Method</summary>

**React Native 0.60 and above**

Run `pod install` in the `ios` directory.

**React Native 0.59 and below**

Run `react-native link react-native-apsara-video` to link library.
</details>

<details>
  <summary>Manually Method</summary>

#### iOS
[https://facebook.github.io/react-native/docs/linking-libraries-ios](https://facebook.github.io/react-native/docs/linking-libraries-ios)

#### Android

**android/settings.gradle**
```gradle
include ':react-native-apsara-player'
project(':react-native-apsara-player').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-apsara-player/android')
```

**MainApplication.java**

```java
@Override
protected List<ReactPackage> getPackages() {
    return Arrays.asList(
            new MainReactPackage(),
            new ApsaraPlayerPackage()
    );
}
```
</details>


### Usage example
```javascript
import React from 'react'
import ApsaraPlayer from 'react-native-apsara-player';

const uriSource = { uri: "https://player.alicdn.com/video/aliyunmedia.mp4" }

const stsSource = {
  sts: {
    vid: 'YOUR_VID'
    region: 'YOUR_REGION',
    accessKeyId: 'YOUR_ACCESS_KEY_ID',
    accessKeySecret: 'YOUR_ACCESS_KEY_SECRET',
    securityToken: 'YOUR_SECURITY_TOKEN',
  },
}

const authSource = {
  auth: {
    vid: 'YOUR_VID'
    region: 'YOUR_REGION',
    playAuth: 'YOUR_PLAY_AUTH',
  },
}

export default class extends React.Component {
  render() {
    return (
      <ApsaraPlayer
        ref={ref => {
          this.player = ref
        })
        source={uriSource /* or stsSource or authSource */}
        paused={true}
        onEnd={this._onEnd}
        onLoad={this._onLoad}
        onSeek={this._onSeek}
        onError={this._onError}
        onProgress={this._onProgress}
      />
    )
  }
};
```

### Component props
| prop | default | type | description |
| ---- | ---- | ----| ---- |
| paused | false | Boolean | Whether the video is paused |
| repeat | false | Boolean | Whether to repeat the video |
| muted | false | Boolean | Whether the audio is muted |
| volume | 1 | Number | Adjust the volume |
| source | none | Object | Source of the video |
| onEnd | none | Function | Callback function that is called when the player reaches the end of the media |
| onLoad | none | Function | Callback function that is called when the video is loaded |
| onSeek | none | Function | Callback function that is called when a seek completes |
| onError | none | Function | Function that is invoked when the video load fails |
| onProgress | none | Function | Function that is invoked when the video is updates |

### License
MIT
