import { useState, useEffect } from 'react'

function App() {
  const [users, setUsers] = useState([])
  const [form, setForm] = useState({ name: '', email: '', password: '' })
  const [message, setMessage] = useState('')

  const fetchUsers = async () => {
    const res = await fetch('/api/users')
    const data = await res.json()
    setUsers(data)
  }

  useEffect(() => { fetchUsers() }, [])

  const register = async (e) => {
    e.preventDefault()
    const res = await fetch('/api/users/register', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(form)
    })
    const data = await res.json()
    setMessage(res.ok ? 'Registered!' : data.error)
    if (res.ok) fetchUsers()
  }

  return (
    <div style={{ fontFamily: 'sans-serif', maxWidth: 600, margin: '40px auto', padding: '0 20px' }}>
      <h1>MERN Stack App</h1>

      <h2>Register User</h2>
      <form onSubmit={register}>
        <input placeholder="Name" value={form.name}
          onChange={e => setForm({...form, name: e.target.value})}
          style={{ display: 'block', margin: '8px 0', padding: 8, width: '100%' }} />
        <input placeholder="Email" value={form.email}
          onChange={e => setForm({...form, email: e.target.value})}
          style={{ display: 'block', margin: '8px 0', padding: 8, width: '100%' }} />
        <input placeholder="Password" type="password" value={form.password}
          onChange={e => setForm({...form, password: e.target.value})}
          style={{ display: 'block', margin: '8px 0', padding: 8, width: '100%' }} />
        <button type="submit" style={{ padding: '8px 20px', marginTop: 8 }}>Register</button>
      </form>
      {message && <p style={{ color: 'green' }}>{message}</p>}

      <h2>Users in MongoDB</h2>
      {users.length === 0 ? <p>No users yet</p> : users.map(u => (
        <div key={u._id} style={{ background: '#f5f5f5', padding: 10, margin: '8px 0', borderRadius: 4 }}>
          <strong>{u.name}</strong> — {u.email}
        </div>
      ))}
    </div>
  )
}

export default App
