import logo from './logo.svg';
import './App.css';

function App() {
  const hostname = window.__RUNTIME_CONFIG__?.HOSTNAME || 'unknown';
  const fullurl = window.location.href;

  return (
    <div className="App">
      <header className="App-header">
        Connected to: <strong>{fullurl}</strong>
        <img src={logo} className="App-logo" alt="logo" />
        App served by: <strong>{hostname}</strong>
      </header>
    </div>
  );
}

export default App;