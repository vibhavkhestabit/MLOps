import { useEffect, useState } from "react";

function App() {
  const [users, setUsers] = useState([]);
  const [products, setProducts] = useState([]);
  const [orders, setOrders] = useState([]);

  useEffect(() => {
    fetch("http://localhost:5000/api/users/users")
      .then((res) => res.json())
      .then((data) => setUsers(data));

    fetch("http://localhost:5000/api/products/products")
      .then((res) => res.json())
      .then((data) => setProducts(data));

    fetch("http://localhost:5000/api/orders/orders")
      .then((res) => res.json())
      .then((data) => setOrders(data));
  }, []);

  return (
    <div style={{ padding: "20px", fontFamily: "Arial" }}>
      <h1>Week 3 Final Project</h1>

      <h2>Users</h2>
      <pre>{JSON.stringify(users, null, 2)}</pre>

      <h2>Products</h2>
      <pre>{JSON.stringify(products, null, 2)}</pre>

      <h2>Orders</h2>
      <pre>{JSON.stringify(orders, null, 2)}</pre>
    </div>
  );
}

export default App;