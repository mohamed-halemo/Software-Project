import './index.css';
import SubNav from './Components/Explore/RecentPhotos/SubNav';
import RecentPhotos from './Components/Explore/RecentPhotos/RecentPhotos';
/* import ImageGrid from './Components/Explore/RecentPhotos/ImageGrid'; */

function App() {
  return (

    <div className="App">
      <SubNav />
      <div>
        <RecentPhotos />
        {/* <ImageGrid /> */}
      </div>

    </div>

  );
}

export default App;
