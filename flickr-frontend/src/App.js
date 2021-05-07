// import { router } from 'json-server';
import React from 'react';
import {
  BrowserRouter as Router, Route, Link, Switch,
} from 'react-router-dom';
import StartPage from './Components/StartPage/StartPage';
import FormSignup from './Components/StartPage/SingUP/FormSignup';
// import './App.css';
// import Addv from './Components/Addv';
import Home from './Components/HomePage/Home';
import NavBar from './Components/NavBar/NavBar';
import About from './Components/NavBar/About';
import Footer from './Components/Footer/Footer';
// import Home from './Components/HomePage/Home';
// import NavBar from './Components/NavBar/NavBar';
// import Button from "react-bootstrap/Button";

function App() {
  return (
    <Router>
      <div className="App">
        <NavBar />
        <Switch>
          <Route path="/Home" exact component={Home} />
          <Route path="/" exact component={StartPage} />

          <Route path="/SignUp" exact component={FormSignup} />

          <Route path="/about" component={About} />
        </Switch>
        <Footer />
      </div>
    </Router>

  );
}

export default App;
