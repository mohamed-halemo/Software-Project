import { BsGrid3X3GapFill, BsSquareFill } from 'react-icons/bs';
import { RiLayoutMasonryFill } from 'react-icons/ri';
import { AiFillCaretDown } from 'react-icons/ai';
import { IconContext } from 'react-icons';

const HomeToolBar = () => {
  const handleClick = (e) => {
    console.log('All Activity test button', e);
  };
  return (
    <div className="layoutBar">
      <div className="HomeFilterContainer">
        <button type="button" onClick={handleClick}>All Activity</button>
        <AiFillCaretDown style={{ color: 'rgb(137, 137, 137)', marginLeft: '7px' }} />
      </div>
      <div className="TabLayoutContainer">
        <IconContext.Provider value={{ className: 'layoutIcons' }}>
          <BsGrid3X3GapFill />
          <RiLayoutMasonryFill />
          <BsSquareFill />
        </IconContext.Provider>
      </div>
    </div>
  );
};

export default HomeToolBar;
