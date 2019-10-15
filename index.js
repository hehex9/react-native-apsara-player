import React from 'react';
import {
  View,
  StyleSheet,
  NativeModules,
  findNodeHandle,
  requireNativeComponent,
} from 'react-native';
import PropTypes from 'prop-types';

export default class ApsaraPlayer extends React.Component {
  setNativeProps(nativeProps) {
    this._player.setNativeProps(nativeProps);
  }

  seek = time => {
    if (isNaN(time)) throw new Error('Specified time is not a number');
    this.setNativeProps({seek: time});
  };

  _onLoad = event => {
    if (this.props.onLoad) {
      this.props.onLoad(event.nativeEvent);
    }
  };

  _onError = event => {
    if (this.props.onError) {
      this.props.onError(event.nativeEvent);
    }
  };

  _onProgress = event => {
    if (this.props.onProgress) {
      this.props.onProgress(event.nativeEvent);
    }
  };

  _onSeek = event => {
    if (this.props.onSeek) {
      this.props.onSeek(event.nativeEvent);
    }
  };

  save = options =>
    NativeModules.ApsaraPlayerManager.save(
      options,
      findNodeHandle(this._player),
    );

  render() {
    const style = [styles.base, this.props.style];

    return (
      <View style={style}>
        <RNApsaraPlayer
          ref={r => {
            this._player = r;
          }}
          style={StyleSheet.absoluteFill}
          vid={this.props.vid}
          options={this.props.options}
          paused={this.props.paused}
          onVideoLoad={this._onLoad}
          onVideoSeek={this._onSeek}
          onVideoError={this._onError}
          onVideoProgress={this._onProgress}
        />
      </View>
    );
  }
}

ApsaraPlayer.propTypes = {
  repeat: PropTypes.bool,
  paused: PropTypes.bool,
  muted: PropTypes.bool,
  volume: PropTypes.number,
  onLoad: PropTypes.func,
  onSeek: PropTypes.func,
  onError: PropTypes.func,
  onProgress: PropTypes.func,
};

const styles = StyleSheet.create({
  base: {
    overflow: 'hidden',
  },
});

const RNApsaraPlayer = requireNativeComponent('ApsaraPlayer', ApsaraPlayer, {
  nativeOnly: {
    seek: true,
  },
});
