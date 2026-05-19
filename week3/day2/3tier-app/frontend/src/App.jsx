import { useEffect, useState } from "react";

function App() {
  const [users, setUsers] = useState([]);

  useEffect(() => {
    fetch("http://localhost:3000/users")
      .then((res) => res.json())
      .then((data) => setUsers(data))
      .catch((err) => console.error(err));
  }, []);

  return (
    <div style={{ padding: "40px" }}>
      <h1>Docker Compose 3-Tier App</h1>

      <h2>Users from PostgreSQL</h2>

      {users.map((user) => (
        <div key={user.id}>
          <p>
            {user.name} - {user.email}
          </p>
        </div>
      ))}
    </div>
  );
}

export default App;