import React from 'react';
import './Photo.css';
import { MdMoreHoriz } from 'react-icons/md';
/* eslint-disable react/prop-types */

const Photo = ({ pCard }) => (
  <div className="container">
    <div className="imageHeader">
      <img src={pCard.avatar} alt="Avatar" className="avatar" />
      <h3>{pCard.owner.ownerName}</h3>
      <h3>{pCard.date}</h3>
      <MdMoreHoriz style={{ color: 'rgb(137, 137, 137)', marginLeft: '7px' }} />
    </div>
    <img src={pCard.img} alt="Avatar" className="image" />
    <div className="overlay">
      <h3>
        {pCard.photoName}
        {' '}
        {pCard.favoritsNum}
        {' '}
        {pCard.commentNum}
      </h3>
    </div>

  </div>
);

export default Photo;
