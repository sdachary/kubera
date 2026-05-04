import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  connect() {
    this.loadDashboard()
  }
  async loadDashboard() {
    const response = await fetch('/api/v1/journey/dashboard', {
      headers: { 'X-API-Key': process.env.API_KEY }
    })
    const data = await response.json()
    this.updateUI(data)
  }
  updateUI(data) {
    // Update debt progress, SIP progress, net worth chart
    console.log('Journey data:', data)
  }
}
