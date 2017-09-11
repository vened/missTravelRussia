import React, { Component } from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';
import { PhotosData } from './api/index';

class Photos extends Component {
  constructor(props) {
    super(props);
  }

  componentDidMount (){
    console.log('get');
    PhotosData.get('59b3ad70050df43e0efd81e0').then((response) => {
      console.log(response);
    }, (err) => {
      console.error(err);
    });
  }

  render() {
    return (
        <div>
          Photos
        </div>
    );
  }
}

Photos.propTypes = {
  PROP: PropTypes.string.isRequired,
};

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
      <Photos />,
      document.getElementById('profile-photos'),
  );
});
