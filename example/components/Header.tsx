import React, {
  ReactElement,
  JSXElementConstructor,
  ReactNode,
  ReactPortal,
} from 'react';
import {StyleSheet, Text, View} from 'react-native';

const Header = (props: {
  title:
    | string
    | number
    | boolean
    | ReactElement<any, string | JSXElementConstructor<any>>
    | Iterable<ReactNode>
    | ReactPortal
    | null
    | undefined;
}) => {
  return (
    <View style={styles.header}>
      <Text style={styles.title}>{props.title}</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  header: {
    backgroundColor: '#000',
    height: 60,
    alignItems: 'center',
    justifyContent: 'center',
  },
  title: {
    color: '#F3F3F3',
    fontSize: 28,
    fontWeight: '900',
    textTransform: 'uppercase',
  },
});

export default Header;
