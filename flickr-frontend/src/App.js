// import { router } from 'json-server';
import React from 'react';
import {
  BrowserRouter as Router, Route, Link, Switch,
} from 'react-router-dom';
<<<<<<< HEAD
import StartPage from './Components/StartPage/StartPage';
import FormSignup from './Components/StartPage/SingUP/FormSignup';
=======
// import StartPage from './Components/StartPage/StartPage';
// import FormSignup from './Components/StartPage/SingUP/FormSignup';
>>>>>>> ad61b92 (Fix Home)
// import './App.css';
// import Addv from './Components/Addv';
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
<<<<<<< HEAD
          <Route path="/" exact>
=======
          {/* <Route path="/" exact>
>>>>>>> ad61b92 (Fix Home)
            <StartPage />
          </Route>

          <Route path="/SignUp" exact>
            <FormSignup />
<<<<<<< HEAD
          </Route>
=======
          </Route> */}
>>>>>>> ad61b92 (Fix Home)
          <Route path="/about" component={About} />
        </Switch>
      </div>
    </Router>

  );
}

export default App;
