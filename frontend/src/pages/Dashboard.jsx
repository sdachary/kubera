import { useState, useEffect } from 'react'
import { api } from '../lib/api'
import { useAuth } from '../lib/auth'

export default function Dashboard() {
  const { user } = useAuth()
  const [data, setData] = useState(null)

  useEffect(() => { api.dashboard().then(setData).catch(() => {}) }, [])

  return (
    <div className="p-6 max-w-4xl mx-auto">
      <p className="text-stone-500 text-sm mb-6">Welcome, {user?.first_name || 'there'}</p>
      {data && (
        <div className="grid grid-cols-3 gap-4 mb-8">
          <div className="bg-white rounded-xl border border-stone-200 p-5">
            <p className="text-xs font-medium text-stone-500 uppercase mb-1">Net Worth</p>
            <p className="text-2xl font-semibold">{data.net_worth?.toLocaleString()}</p>
          </div>
          <div className="bg-white rounded-xl border border-stone-200 p-5">
            <p className="text-xs font-medium text-stone-500 uppercase mb-1">Debt</p>
            <p className="text-2xl font-semibold text-red-600">{data.total_debt?.toLocaleString()}</p>
          </div>
          <div className="bg-white rounded-xl border border-stone-200 p-5">
            <p className="text-xs font-medium text-stone-500 uppercase mb-1">Investments</p>
            <p className="text-2xl font-semibold text-emerald-600">{data.total_investments?.toLocaleString()}</p>
          </div>
        </div>
      )}
    </div>
  )
}
