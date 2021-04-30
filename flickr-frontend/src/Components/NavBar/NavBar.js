import { MdCloudUpload } from 'react-icons/md';
import { BsBell } from 'react-icons/bs';

import './NavBar.css';

const NavBar = () => (
  <div>
    <nav className="navbar">
      <img
        src="https://www.flickr.com/images/opensearch-flickr-logo.png"
        alt="Logo.png"
        style={{ sizes: '5px' }}
        height="20"
        width="20"
      />
      <h1>flicker</h1>
      <div className="links">
        <a href="/">You </a>
        <a href="/create">Explore</a>
        <a href="/">Prints</a>
        <a href="/">Get Pro</a>
      </div>
      <div className="navRight">
        <MdCloudUpload color="white" size="30px" className="icon" />
        <BsBell color="white" size="30px" className="icon" />
      </div>
    </nav>
  </div>
);

export default NavBar;
