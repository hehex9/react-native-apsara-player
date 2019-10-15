import React, {Component} from 'react';
import {StyleSheet, View} from 'react-native';
import Slider from '@react-native-community/slider';
import ApsaraPlayer from 'react-native-apsara-player';
import Button from './button';

const options = {
  type: 'vidSts',
  region: 'cn-shanghai',
  securityToken:
    'CAIS6gF1q6Ft5B2yfSjIr4/RfOuCuKVWzpufcRL7olU8fbpo3qjBjzz2IHpNdXJtA+0fsPk/lWtW6vYdlq1zRp9IHdQmo1HEq8Y5yxioRqacke7XhOV2pf/IMGyXDAGBr622Su7lTdTbV+6wYlTf7EFayqf7cjPQND7Mc+f+6/hdY88QQxOzYBdfGd5SPXECksIBMmbLPvvfWXyDwEioVRQx51sk2D4hsv7ukpDAuiCz1gOqlrUnwK3qOYWhYsVWO5Nybsy4xuQedNCaincBsEUQqf4o0fwVommb7o6HbEdW7w+BN+fEblCO2POk4cIagAE9B5Q90NZTF4Kpga3B2ez0NQwrIYqv0sHK6CgIKfcjj4hpeCtiroPpffobqTDo1QEdBqXXUdGjHZXsWXNWyjJoS0vWxQ48XgRVVLjE03xYxfwKj1A/DL+DT9IBGLYHoFCe8rWTBZa00nYJOIIzAh1OfK498pfgtogKLcfpKjmncQ==',
  accessKeyId: 'STS.NLd7Q6UzwyYts4JFUiq5D1mjm',
  accessKeySecret: 'CzdnwQzsBrC8i4wFXeBP5JKxBkdUwayHsczGmDvzZKkC',
};

export default class App extends Component {
  state = {
    paused: true,
    duration: 20,
  };

  start = () => {
    this.setState({paused: false});
  };

  stop = () => {
    this.setState({paused: true});
  };

  _onSeek = pos => {
    this._player.seek(pos);
  };

  _onLoad = data => {
    this.setState({duration: data.duration});
  };

  _onProgress = data => {
    console.log(data);
  };

  render() {
    return (
      <View style={styles.container}>
        <ApsaraPlayer
          ref={player => (this._player = player)}
          vid="ee692baf69514da0a755863fc874b39c"
          style={styles.player}
          paused={this.state.paused}
          onLoad={this._onLoad}
          options={options}
        />

        <Slider
          style={styles.slider}
          minimumValue={0}
          maximumValue={this.state.duration}
          onValueChange={this._onSeek}
        />

        <View style={styles.buttons}>
          <Button
            title={this.state.paused ? '播放' : '暂停'}
            onPress={this.state.paused ? this.start : this.stop}
          />
        </View>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },

  player: {
    height: 220,
    width: 360,
    backgroundColor: '#f0f0f0',
    marginBottom: 20,
  },

  slider: {
    width: '80%',
    height: 12,
    marginTop: 20,
    marginBottom: 20,
  },

  buttons: {
    width: '100%',
    flexDirection: 'row',
    justifyContent: 'center',
    paddingHorizontal: 12,
  },
});
