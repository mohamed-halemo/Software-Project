import { BsGrid3X3GapFill, BsSquareFill } from 'react-icons/bs';
import { RiLayoutMasonryFill } from 'react-icons/ri';
import { AiFillCaretDown } from 'react-icons/ai';
import './Home.css';

const Home = () => (
  <div className="HomePage">
    <div className="LayoutBar">
      <div className="LayoutBarLeft">
        <h1>All Activity</h1>
        <AiFillCaretDown style={{ color: 'rgb(137, 137, 137)' }} />
      </div>
      <div className="LayoutBarRight">
        <BsGrid3X3GapFill />
        <BsSquareFill />
        <RiLayoutMasonryFill />
      </div>
    </div>
  </div>
);

export default Home;
