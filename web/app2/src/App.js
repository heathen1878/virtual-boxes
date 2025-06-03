import logo from './logo.svg';
import './App.css';

function App() {
  const hostname = window.location.hostname;
  const fullurl = window.location.href;

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Connected to: <strong>{fullurl}</strong>
          
          App 2 served by: <strong>{hostname}</strong>
        </p>
      </header>
    </div>
  );
}

export default App;
