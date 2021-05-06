import './App.css';
// import Addv from './Components/Addv';
import { BrowserRouter as Router, Route } from 'react-router-dom';
import Home from './Components/HomePage/Home';
import NavBar from './Components/NavBar/NavBar';
// import Button from "react-bootstrap/Button";

function App() {
  return (
    <Router>

      <div className="App">
        <NavBar />
        {/* <Addv /> */}
        <div className="OuterFeedContainer">
          <Home />
        </div>
      </div>
    </Router>

  );
}

export default App;
