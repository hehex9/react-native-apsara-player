# react-native-apsara-player
A react-native wrapper for [aliyun video player](https://help.aliyun.com/document_detail/125579.html)

Check the `example` for more details


## Installation

Using npm:
```shell
npm install --save react-native-apsara-player
```

or yarn:
```shell
yarn add --save react-native-apsara-player
```

### Installation
<details>
  <summary>Standard Method</summary>

**React Native 0.60 and above**

Run `pod install` in the `ios` directory.

**React Native 0.59 and below**

Run `react-native link react-native-video` to link the react-native-video library.
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


## Usage
```javascript
import ApsaraPlayer from 'react-native-apsara-player';

const uri = "https://player.alicdn.com/video/aliyunmedia.mp4"

export default function() {
  return (
    <ApsaraPlayer
      ref={ref => {
        this.player = ref
      })
      source={{ uri }}
      paused={true}
      onLoad={this._onLoad}
      onSeek={this._onSeek}
      onError={this._onError}
    />
  )
};
```
