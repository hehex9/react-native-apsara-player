import React from 'react';
import {TouchableOpacity, StyleSheet, Text} from 'react-native';

export default function Button({title, onPress, style}) {
  return (
    <TouchableOpacity onPress={onPress} style={[styles.button, style]}>
      <Text style={styles.text}>{title}</Text>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  button: {
    backgroundColor: 'black',
    borderRadius: 5,
    paddingVertical: 15,
    width: 100,
    alignItems: 'center',
    justifyContent: 'center',
  },

  text: {
    color: 'white',
  },
});
