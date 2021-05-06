import { MdCloudUpload } from 'react-icons/md';
import { BsBell } from 'react-icons/bs';
import 'bootstrap/dist/css/bootstrap.min.css';
import { useHistory, Link } from 'react-router-dom';

import './NavBar.css';

const NavBar = (props) => {
  const history = useHistory();

  return (
    <nav className="globalNavBar navbar-default navbar-fixed-top ">
      <nav className="Hnavbar ">
        <img
          src="https://www.flickr.com/images/opensearch-flickr-logo.png"
          alt="Logo.png"
          style={{ sizes: '5px' }}
          height="20"
          width="20"
        />
        <Link to="/Home" id="appName">flickr</Link>
        <div className="dropdown">
          <button className="dropbtn" type="button" onClick={() => history.push('/profile')}>You</button>
          <div className="dropdown-content">
            <Link to="/about">About</Link>
            <Link to="/">Photostream</Link>
            <Link to="/">Albums</Link>
            <Link to="/">Faves</Link>
            <Link to="/">Galleries</Link>
            <Link to="/">Groups</Link>
            <Link to="/">Camera Roll</Link>
            <Link to="/">Recent Acrivity</Link>
            <Link to="/">People</Link>
            <Link to="/">Organize</Link>
          </div>
        </div>
        <div className="links">
          <div className="dropdown">
            <button className="dropbtn" type="button">Explore</button>
            <div className="dropdown-content">
              <a href="/">Recent Photos</a>
              <a href="/">Trending</a>
              <a href="/">Events</a>
              <a href="/">The Commons</a>
              <a href="/">Flickr Galleries</a>
              <a href="/">World Map</a>
              <a href="/">Camera Finder</a>
              <a href="/">Flickr Blog</a>
            </div>
          </div>
          <div className="dropdown">
            <button className="dropbtn" type="button">Prints</button>
            <div className="dropdown-content">
              <a href="/">Prints &amp; Wall Art</a>
              <a href="/">Photo Books</a>
              <a href="/">View Cart</a>

            </div>
          </div>
          {' '}
          <a href="/">Get Pro</a>
        </div>
        <div className="HnavRight">
          {/* TODO:Padding in Icons */}
          <MdCloudUpload color="white" size="60px" className="Hicon" />
          <BsBell color="white" size="60px" className="Hicon" />
        </div>
      </nav>
    </nav>
  );
};

export default NavBar;
