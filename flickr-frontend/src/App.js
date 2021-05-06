// import { router } from 'json-server';
import React from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import StartPage from './Components/StartPage/StartPage';
import FormSignup from './Components/StartPage/SingUP/FormSignup';
// import './App.css';
// import Addv from './Components/Addv';
// import Home from './Components/HomePage/Home';
// import NavBar from './Components/NavBar/NavBar';
// import Button from "react-bootstrap/Button";

function App() {
  return (
    <Router>
      <Switch>
        <Route path="/" exact>
          <StartPage />
        </Route>

        <Route path="/SignUp" exact>
          <FormSignup />
        </Route>
      </Switch>
    </Router>

  );
}

export default App;
