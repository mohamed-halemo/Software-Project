import './App.css';
// import Addv from './Components/Addv';
import Home from './Components/HomePage/Home';
import NavBar from './Components/NavBar/NavBar';
// import Button from "react-bootstrap/Button";

function App() {
  return (

    <div className="App">
      <NavBar />
      {/* <Addv /> */}
      <div className="content">
        <Home />
      </div>
    </div>
  );
}

export default App;
