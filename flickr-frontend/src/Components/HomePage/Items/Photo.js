import React from 'react';
import './Photo.css';
import { MdMoreHoriz } from 'react-icons/md';
import { AiOutlinePlusSquare, AiOutlineStar } from 'react-icons/ai';
import { RiChat3Line } from 'react-icons/ri';
import { Link } from 'react-router-dom';

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
    <div className="imgOverlay">
      <div className="overlayLeftCont">
        <Link to="/viewImage">{pCard.photoName}</Link>

      </div>
      <div className="overlayRightCont" />
      <span className="overlayFave" role="button">
        <AiOutlineStar />
        <span>{pCard.favoritsNum}</span>

      </span>
      <span className="overlayComment" role="button">
        <RiChat3Line />
        <span>{pCard.commentNum}</span>

      </span>

      <span className="overlayAddTo" role="button">
        <AiOutlinePlusSquare />
      </span>

    </div>

  </div>
);

export default Photo;
