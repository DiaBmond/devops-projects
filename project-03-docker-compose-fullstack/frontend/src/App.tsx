import React, { useEffect, useState } from 'react';

function App() {
  const [message, setMessage] = useState('Loading...');
  const [error, setError] = useState('');

  useEffect(() => {
    fetch('/api/')
      .then(res => {
        if (!res.ok) throw new Error('Failed to fetch');
        return res.json();
      })
      .then(data => setMessage(data.message))
      .catch(err => {
        console.error('Error:', err);
        setError('Failed to connect to backend');
      });
  }, []);

  return (
    <div style={{ textAlign: 'center', marginTop: '50px', fontFamily: 'Arial' }}>
      <h1>Project 3: Docker Compose Fullstack</h1>
      {error ? (
        <p style={{ color: 'red' }}>{error}</p>
      ) : (
        <div>
          <h2 style={{ color: '#61dafb' }}>{message}</h2>
          <div style={{ marginTop: '30px' }}>
            <span style={{ margin: '0 10px', padding: '5px 15px', background: '#282c34', color: 'white', borderRadius: '5px' }}>React</span>
            <span style={{ margin: '0 10px', padding: '5px 15px', background: '#092e20', color: 'white', borderRadius: '5px' }}>Django</span>
            <span style={{ margin: '0 10px', padding: '5px 15px', background: '#336791', color: 'white', borderRadius: '5px' }}>PostgreSQL</span>
            <span style={{ margin: '0 10px', padding: '5px 15px', background: '#dc382d', color: 'white', borderRadius: '5px' }}>Redis</span>
            <span style={{ margin: '0 10px', padding: '5px 15px', background: '#009639', color: 'white', borderRadius: '5px' }}>Nginx</span>
          </div>
        </div>
      )}
    </div>
  );
}

export default App;