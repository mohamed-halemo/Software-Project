import React, { Fragment, useState, useEffect } from 'react';
import Column from './Column';
import 'Gallery.css';

// getColumns Hook
const getColumns = (imgarr, col) => {
  const images = [];
  for (let i = 0; i < col; i++) {
    images.push([]);
  }

  let sum = 0;
  imgarr.forEach((img) => {
    sum += img.height;
  });

  const threshold = Math.floor(sum / col);
  let current = 0;
  let l = 0;

  imgarr.forEach((img) => {
    console.log(l);
    if ((current + img.height) >= threshold) {
      if (l != col - 1) { l += 1; }
      current = img.height;
      images[l].push(img);
    } else {
      current += img.height;
      images[l].push(img);
    }
  });
  return images;
};

function Gallery({ imgarr }) {
  const [columns, setColumns] = useState([]);

  useEffect(() => {
    const mql = window.matchMedia('all and (max-width: 800px)');
    if (mql.matches) {
      setColumns(getColumns(imgarr, 2));
    } else {
      setColumns(getColumns(imgarr, 4));
    }
  }, []);

  return (
    <>
      {

        columns.map((img, i) => <Column key={i} images={img} />)
      }

    </>
  );
}

export default Gallery;
