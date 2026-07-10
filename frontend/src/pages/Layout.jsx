import { Outlet, useNavigate } from 'react-router-dom'
import { useAuth } from '../lib/auth'

export default function Layout() {
  const { user, logout } = useAuth()
  const navigate = useNavigate()

  return (
    <div className="min-h-screen bg-stone-50">
      <header className="bg-white border-b border-stone-200 px-6 py-3 flex items-center justify-between">
        <span className="font-semibold text-stone-900">Kubera</span>
        <div className="flex items-center gap-4 text-sm">
          <span className="text-stone-400">{user?.email}</span>
          <button onClick={async () => { await logout(); navigate('/login') }} className="text-stone-500 hover:text-stone-800">Sign out</button>
        </div>
      </header>
      <main><Outlet /></main>
    </div>
  )
}
