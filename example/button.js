import React from 'react';
import {TouchableOpacity, StyleSheet, Text} from 'react-native';

export default function Button({title, onPress}) {
  return (
    <TouchableOpacity
      activeOpacity={0.7}
      onPress={onPress}
      style={styles.button}>
      <Text style={styles.text}>{title}</Text>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  button: {
    backgroundColor: 'black',
    borderRadius: 5,
    paddingVertical: 10,
    width: 100,
    alignItems: 'center',
    justifyContent: 'center',
  },

  text: {
    color: 'white',
  },
});
