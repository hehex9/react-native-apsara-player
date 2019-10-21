import React, {Component} from 'react';
import {StyleSheet, View, Alert, Text, Switch} from 'react-native';
import Slider from '@react-native-community/slider';
import ApsaraPlayer from 'react-native-apsara-player';
import Button from './button';

const source = {
  auth: null,
  sts: null,
  uri: 'https://player.alicdn.com/video/aliyunmedia.mp4',
};

export default class App extends Component {
  state = {
    paused: true,
    duration: 20,
    currentTime: 0,
    enable: true,
  };

  init(props) {
    this.setState({
      paused: true,
      duration: 0,
      currentTime: 0,
      enable: true,
      ...props,
    });
  }

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
                Alert.alert('下载完成', rs.uri);
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

  renderVideo() {
    return (
      <>
        <ApsaraPlayer
          ref={player => (this._player = player)}
          style={styles.player}
          source={source}
          paused={this.state.paused}
          onLoad={this._onLoad}
          onError={this._onError}
          onSeek={this._onSeekEnd}
          onProgress={this._onProgress}
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

          {(source.sts || source.auth) && (
            <Button title="下载" onPress={this.save} style={styles.button} />
          )}
        </View>
      </>
    );
  }

  render() {
    return (
      <View style={styles.container}>
        <Switch
          style={styles.switch}
          value={this.state.enable}
          onValueChange={enable => {
            this.init({enable});
          }}
        />

        {this.state.enable && this.renderVideo()}
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

  switch: {
    marginBottom: 30,
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
