import React from 'react';
import {
  View,
  Platform,
  StyleSheet,
  NativeModules,
  findNodeHandle,
  requireNativeComponent,
} from 'react-native';
import PropTypes from 'prop-types';

export default class ApsaraPlayer extends React.Component {
  get _module() {
    return Platform.OS === 'ios'
      ? NativeModules.ApsaraPlayerManager
      : NativeModules.ApsaraPlayerModule;
  }

  componentWillUnmount() {
    this._module.destroy(findNodeHandle(this._player));
  }

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

  save = options => {
    return this._module.save(options, findNodeHandle(this._player));
  };

  render() {
    const style = [styles.base, this.props.style];

    return (
      <View style={style}>
        <RNApsaraPlayer
          ref={r => {
            this._player = r;
          }}
          style={StyleSheet.absoluteFill}
          source={this.props.source}
          paused={this.props.paused}
          volume={this.props.volume}
          muted={this.props.muted}
          onVideoEnd={this.props.onEnd}
          onVideoLoad={this._onLoad}
          onVideoSeek={this._onSeek}
          onVideoError={this._onError}
          onVideoProgress={this._onProgress}
        />
      </View>
    );
  }
}

ApsaraPlayer.defaultProps = {
  volume: 1,
  muted: false,
  paused: false,
  repeat: false,
}

ApsaraPlayer.propTypes = {
  repeat: PropTypes.bool,
  paused: PropTypes.bool,
  muted: PropTypes.bool,
  volume: PropTypes.number,
  source: PropTypes.shape({
    uri: PropTypes.string,
    sts: PropTypes.shape({
      vid: PropTypes.string,
      region: PropTypes.string,
      accessKeyId: PropTypes.string,
      accessKeySecret: PropTypes.string,
      securityToken: PropTypes.string,
    }),
    auth: PropTypes.shape({
      vid: PropTypes.string,
      region: PropTypes.string,
      playAuth: PropTypes.string,
    }),
  }),
  onEnd: PropTypes.func,
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
