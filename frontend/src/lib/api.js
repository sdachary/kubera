const API = import.meta.env.VITE_API_URL || ''

async function request(path, options = {}) {
  const token = localStorage.getItem('token')
  const res = await fetch(`${API}${path}`, {
    headers: { 'Content-Type': 'application/json', ...token ? { Authorization: `Bearer ${token}` } : {}, ...options.headers },
    ...options,
  })
  if (!res.ok) throw new Error((await res.json().catch(() => ({}))).error || res.statusText)
  return res.status === 204 ? null : res.json()
}

export const api = {
  request: (path, opts) => request(path, opts),
  register: (data) => request('/api/v1/auth/register', { method: 'POST', body: JSON.stringify(data) }),
  login: (data) => request('/api/v1/auth/login', { method: 'POST', body: JSON.stringify(data) }),
  me: () => request('/api/v1/auth/me'),
  logout: () => request('/api/v1/auth/logout', { method: 'POST' }),
  dashboard: () => request('/api/v1/dashboard'),
}
