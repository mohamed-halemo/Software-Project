import './App.css';
// import Addv from './Components/Addv';
import {
  BrowserRouter as Router, Route, Link, Switch,
} from 'react-router-dom';
import Home from './Components/HomePage/Home';
import NavBar from './Components/NavBar/NavBar';
import About from './Components/NavBar/About';

// import Button from "react-bootstrap/Button";

function App() {
  return (
    <Router>
      <div className="App">
        <NavBar />
        <Switch>
          <Route path="/Home" exact component={Home} />

          <Route path="/about" component={About} />
        </Switch>
      </div>
    </Router>

  );
}

export default App;
