import React, {Component} from 'react';
import {StyleSheet, View, Alert, Text} from 'react-native';
import Slider from '@react-native-community/slider';
import ApsaraPlayer from 'react-native-apsara-player';
import Button from './button';

const options = {
  type: 'vidSts',
  region: 'cn-shanghai',
  securityToken:
    'CAIS6gF1q6Ft5B2yfSjIr47QE9GCnZRz7rqsdxXgkGEFX8gYpLzAuDz2IHpNdXJtA+0fsPk/lWtW6vYdlq1zRp9IHYsKtiLFq8Y5yxioRqacke7XhOV2pf/IMGyXDAGBr622Su7lTdTbV+6wYlTf7EFayqf7cjPQND7Mc+f+6/hdY88QQxOzYBdfGd5SPXECksIBMmbLPvvfWXyDwEioVRQx51sk2D4hsv7ukpDAuiCz1gOqlrUnwK3qOYWhYsVWO5Nybsy4xuQedNCaincBsEUQqf4o0fwVommb7o6HbEdW7w+BN+fEblCO2POk4cIagAEJFJ8bXD0DxQPYUfZibW7k2olIMZlSA1XtuuWv+5i/YxpgDRuDRC9JbZQSf7NbGqmrPOvEMbYhz4wpFLX9VqdiVPD3BD6UEvFNMBU5pxTcnpw4yh5S3BCsuVUn6F88ZzHIpfAE+cf851iKTFVxoZ51Q9NSF2DNgPwMw3US6f69Iw==',
  accessKeyId: 'STS.NMeXk6pKRYxGu3QtaPSG4KykZ',
  accessKeySecret: 'GMJWFUsFox8GioEDYWRFGPbZ6QkDTX1QoSrH6qqY9ZLg',
};

export default class App extends Component {
  state = {
    paused: true,
    duration: 20,
    currentTime: 0,
  };

  start = () => {
    this.setState({paused: false});
  };

  stop = () => {
    this.setState({paused: true});
  };

  save = () => {
    Alert.alert(
      '确认下载',
      '',
      [
        {
          text: '取消',
          style: 'cancel',
        },
        {
          text: '确认',
          onPress: () => {
            this._player
              .save()
              .then(rs => {
                console.log('result:', rs);
              })
              .catch(e => {
                console.warn(e);
              });
          },
        },
      ],
      {cancelable: false},
    );
  };

  _onSeek = pos => {
    this._player.seek(pos);
  };

  _onSeekEnd = () => {
    console.log('onSeek completed');
  };

  _onLoad = data => {
    this.setState({duration: data.duration});
  };

  _onError = data => {
    Alert.alert('ERROR', data.message);
  };

  _onProgress = data => {
    this.setState({currentTime: data.currentTime});
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
          onError={this._onError}
          onSeek={this._onSeekEnd}
          onProgress={this._onProgress}
          options={options}
        />

        <Text>
          {Math.round(this.state.currentTime / 1000)}-
          {Math.round(this.state.duration / 1000)}s
        </Text>

        <Slider
          style={styles.slider}
          value={this.state.currentTime}
          minimumValue={0}
          maximumValue={this.state.duration}
          onValueChange={this._onSeek}
        />

        <View style={styles.buttons}>
          <Button
            title={this.state.paused ? '播放' : '暂停'}
            onPress={this.state.paused ? this.start : this.stop}
          />

          <Button title="下载" onPress={this.save} style={styles.button} />
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
    marginBottom: 30,
  },

  slider: {
    width: '90%',
    height: 12,
    marginTop: 30,
    marginBottom: 30,
  },

  buttons: {
    width: '100%',
    flexDirection: 'row',
    justifyContent: 'center',
    paddingHorizontal: 12,
  },

  button: {
    marginLeft: 12,
  },
});
