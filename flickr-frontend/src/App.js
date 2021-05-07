import './index.css';
import React, { useEffect, Fragment } from 'react';
import SubNav from './Components/Explore/SubNav';
import RecentPhotos from './Components/Explore/RecentPhotos';
import Gallery from './Components/Explore/Gallery';

function App() {
  const fetchPhoto = async () => {
    const res = await fetch('http://localhost:5000/data');
    const data = await res.json();
    return data;
  };

  useEffect(() => {
    const getPhoto = async () => {
      const photoFromServer = await fetchPhoto();
      getPhotoData(photoFromServer);
    };
  });

  return (

    <div className="App">
      <SubNav />
      <div>
        <RecentPhotos />
        <>
          <div className="gallery">
            <Gallery imgarr={fetchPhoto} />
          </div>
        </>
      </div>

    </div>

  );
}

export default App;
