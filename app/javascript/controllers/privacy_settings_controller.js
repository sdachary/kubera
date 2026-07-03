import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static FEATURES = [
    { key: "financial_tracking", label: "Financial Tracking", desc: "Record and manage transactions, expenses, and income" },
    { key: "trip_data", label: "Trip Data", desc: "Store trip plans, expenses, and member information" },
    { key: "email_updates", label: "Email Updates", desc: "Receive account notifications, reports, and reminders" },
    { key: "marketing", label: "Marketing", desc: "Receive product updates and promotional content" },
  ]

  connect() {
    this.loadConsents()
    this.checkDeletionStatus()
  }

  async loadConsents() {
    try {
      const res = await this.fetchWithAuth("/api/dpdp/consent")
      if (!res.ok) throw new Error("Failed to load consents")
      const data = await res.json()
      this.renderConsents(data.consent || {})
    } catch (err) {
      document.getElementById("consent-list").innerHTML =
        `<p class="text-sm text-red-400">Failed to load consent settings.</p>`
    }
  }

  renderConsents(consents) {
    const container = document.getElementById("consent-list")
    container.innerHTML = PrivacySettingsController.FEATURES.map(f => {
      const granted = consents[f.key] || false
      return `
        <div class="flex items-center justify-between py-3 border-b border-slate-800 last:border-0">
          <div>
            <div class="text-sm font-medium text-slate-200">${f.label}</div>
            <div class="text-xs text-slate-500">${f.desc}</div>
          </div>
          <label class="relative inline-flex items-center cursor-pointer">
            <input type="checkbox" class="sr-only peer consent-toggle" data-feature="${f.key}" ${granted ? "checked" : ""} data-action="change->privacy-settings#toggleConsent">
            <div class="w-9 h-5 bg-slate-700 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-teal-600"></div>
          </label>
        </div>`
    }).join("")
  }

  async toggleConsent(event) {
    const checkbox = event.target
    const feature = checkbox.dataset.feature
    const granted = checkbox.checked

    try {
      const res = await this.fetchWithAuth("/api/dpdp/consent", {
        method: "POST",
        headers: { "Content-Type": "application/json", "X-CSRF-Token": this.csrfToken() },
        body: JSON.stringify({ feature, granted })
      })
      if (!res.ok) throw new Error("Failed to update consent")
    } catch (err) {
      checkbox.checked = !granted
      this.showToast("Failed to update consent preference", "error")
    }
  }

  async checkDeletionStatus() {
    try {
      const res = await this.fetchWithAuth("/api/dpdp/consent")
      if (!res.ok) return
    } catch { return }
  }

  async exportData(event) {
    event.preventDefault()
    const btn = event.currentTarget
    btn.textContent = "Exporting..."
    btn.disabled = true

    try {
      const res = await this.fetchWithAuth("/api/dpdp/full-export", { method: "POST" })
      if (!res.ok) throw new Error("Export failed")
      const data = await res.json()
      const blob = new Blob([JSON.stringify(data, null, 2)], { type: "application/json" })
      const url = URL.createObjectURL(blob)
      const a = document.createElement("a")
      a.href = url
      a.download = `kubera-export-${new Date().toISOString().split("T")[0]}.json`
      a.click()
      URL.revokeObjectURL(url)
      this.showToast("Data exported successfully", "success")
    } catch (err) {
      this.showToast(err.message || "Export failed", "error")
    } finally {
      btn.textContent = "Download My Data"
      btn.disabled = false
    }
  }

  async submitGrievance(event) {
    event.preventDefault()
    const form = event.target
    const formData = new FormData(form)
    const resultEl = this.element.querySelector('[id$="grievance-result"]')
    const submitBtn = form.querySelector('[type="submit"]')

    submitBtn.textContent = "Submitting..."
    submitBtn.disabled = true
    resultEl.classList.add("hidden")

    try {
      const res = await this.fetchWithAuth("/api/dpdp/grievance", {
        method: "POST",
        headers: { "Content-Type": "application/json", "X-CSRF-Token": this.csrfToken() },
        body: JSON.stringify(Object.fromEntries(formData))
      })
      if (!res.ok) throw new Error("Failed to submit grievance")
      const data = await res.json()
      resultEl.className = "text-sm text-teal-400 mt-2"
      resultEl.textContent = `Grievance submitted. Reference: ${data.reference_number}. We will respond within 72 hours.`
      form.reset()
    } catch (err) {
      resultEl.className = "text-sm text-red-400 mt-2"
      resultEl.textContent = err.message || "Failed to submit grievance"
    } finally {
      submitBtn.textContent = "Submit Grievance"
      submitBtn.disabled = false
    }
  }

  showToast(message, type) {
    const existing = document.querySelector("[data-toast]")
    if (existing) existing.remove()

    const toast = document.createElement("div")
    toast.setAttribute("data-toast", "")
    toast.className = `fixed bottom-6 left-1/2 -translate-x-1/2 px-6 py-3 rounded-xl text-sm font-medium z-50 transition-all duration-300 ${
      type === "success"
        ? "bg-teal-900/80 border border-teal-700/50 text-teal-200"
        : "bg-red-900/80 border border-red-700/50 text-red-200"
    }`
    toast.textContent = message
    document.body.appendChild(toast)
    setTimeout(() => toast.remove(), 3000)
  }

  async fetchWithAuth(url, options = {}) {
    const token = document.querySelector('meta[name="csrf-token"]')?.content
    const headers = options.headers || {}
    headers["Accept"] = "application/json"
    if (token && !options.headers?.["X-CSRF-Token"]) {
      headers["X-CSRF-Token"] = token
    }
    return fetch(url, { ...options, headers })
  }

  csrfToken() {
    return document.querySelector('meta[name="csrf-token"]')?.content
  }
}
