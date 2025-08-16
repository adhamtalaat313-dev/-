import React, { useEffect, useState } from 'react'
import { createRoot } from 'react-dom/client'
import axios from 'axios'

const API = 'http://localhost:4000/api'

function App() {
  const [token, setToken] = useState('')
  const [users, setUsers] = useState([])
  const [listings, setListings] = useState([])
  const [settings, setSettings] = useState(null)

  const auth = { headers: { Authorization: `Bearer ${token}` } }

  async function loginAdmin(email, password) {
    const r = await axios.post(`${API}/auth/login`, { email, password })
    setToken(r.data.token)
  }

  async function load() {
    if (!token) return
    const u = await axios.get(`${API}/admin/users`, auth)
    setUsers(u.data)
    const l = await axios.get(`${API}/listings`, { }) // public approved
    setListings(l.data)
    const s = await axios.get(`${API}/admin/settings`, auth)
    setSettings(s.data)
  }

  useEffect(() => { load() }, [token])

  return (
    <div style={{ padding: 16 }}>
      <h2>Admin Dashboard</h2>
      {!token && <Login onLogin={loginAdmin} />}
      {token && <>
        <section>
          <h3>Settings</h3>
          {settings && <div>Commission: {settings.commissionPercent}%</div>}
        </section>
        <section>
          <h3>Users ({users.length})</h3>
          <ul>{users.map(u => <li key={u.id}>{u.email} — {u.role} {u.banned ? '(banned)' : ''}</li>)}</ul>
        </section>
        <section>
          <h3>Approved Listings ({listings.length})</h3>
          <ul>{listings.map(l => <li key={l.id}>{l.title} — {l.city} — {l.price} {l.currency}</li>)}</ul>
        </section>
      </>}
    </div>
  )
}

function Login({ onLogin }) {
  const [email, setEmail] = useState('admin@example.com')
  const [password, setPassword] = useState('password')
  return (
    <div>
      <input placeholder="email" value={email} onChange={e => setEmail(e.target.value)} />
      <input placeholder="password" type="password" value={password} onChange={e => setPassword(e.target.value)} />
      <button onClick={() => onLogin(email, password)}>Login</button>
    </div>
  )
}

const root = createRoot(document.getElementById('root'))
root.render(<App />)
