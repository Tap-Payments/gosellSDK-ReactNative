import React from 'react';
import { mount } from 'enzyme';
import Sample from '../src';

describe('<Sample />', () => {
  test('renders correctly', () => {
    const wrapper = mount(<Sample />);
    expect(wrapper).toMatchSnapshot();
  });
});
