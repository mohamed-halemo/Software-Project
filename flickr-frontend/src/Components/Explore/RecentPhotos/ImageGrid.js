import './ImageGrid.css';

const ImageGrid = () => (
  <div className="container">
    <div className="row justify-content-md-center">
      <div className="col col-lg-2">
        <div className="photo" id="1" />
      </div>
      <div className="col-md-auto">
        Variable width content
      </div>
      <div className="col col-lg-2">
        3 of 3
      </div>
    </div>
    <div className="row">
      <div className="col">
        1 of 3
      </div>
      <div className="col-md-auto">
        Variable width content
      </div>
      <div className="col col-lg-2">
        3 of 3
      </div>
    </div>
  </div>
);

export default ImageGrid;
