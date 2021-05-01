import  './SubNav.css';


const SubNav = () => {
    return (
        <div className ='subNav'>
           <div className ='subNavbar'>
                {/* <div className='subNavbar-items'> */}
                    <div className ='container'>
                        <div>
                            <a className='selectedLink' href='/'> Explore </a> {/* To be edited in status as item selected */}
                            <a href='/'> Trending </a> 
                            <a href='/'> Events </a>
                        </div>
                        <div className='more'>
                            <a href='/' className ='dropDown'>More &nbsp; <div className='arrow down'> </div> </a>
                            <ul className='dropDownContent'>
                                <li> <a href='/'>The Commons</a></li>
                                <li> <a href='/'>Galleries</a></li>
                                <li><a href='/'>The World Map</a></li>
                                <li><a href='/'>App Garden</a></li>
                                <li><a href='/'>Flickr Blog</a></li>
                            </ul>
                        </div>
                     </div>
                {/* </div> */}
            </div> 
        </div>
     );
}
 
export default SubNav;