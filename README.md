# react-native-apsara-player

## Getting started

`$ npm install react-native-apsara-player --save`

### Mostly automatic installation

`$ react-native link react-native-apsara-player`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-apsara-player` and add `ApsaraPlayer.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libApsaraPlayer.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainApplication.java`
  - Add `import cn.whenpigsfly.rn.apsara.ApsaraPlayerPackage;` to the imports at the top of the file
  - Add `new ApsaraPlayerPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-apsara-player'
  	project(':react-native-apsara-player').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-apsara-player/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-apsara-player')
  	```


## Usage
```javascript
import ApsaraPlayer from 'react-native-apsara-player';

// TODO: What to do with the module?
ApsaraPlayer;
```
