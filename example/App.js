import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View} from 'react-native';
import ApsaraPlayer from 'react-native-apsara-player';

export default class App extends Component {
  render() {
    return (
      <View style={styles.container}>
        <Text>Aliyun Video Player</Text>
        <ApsaraPlayer />
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
});
