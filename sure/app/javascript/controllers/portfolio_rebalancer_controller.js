import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "results", "suggestions", "loader" ]

  async rebalance() {
    this.loaderTarget.classList.remove("hidden")
    this.resultsTarget.classList.add("hidden")
    
    try {
      const response = await fetch("/api/v1/portfolio/rebalance", {
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')?.content
        }
      })
      
      const data = await response.json()
      
      if (response.ok) {
        this.renderResults(data)
      } else {
        alert(data.error || "An error occurred during rebalancing calculation")
      }
    } catch (error) {
      console.error(error)
      alert("Failed to connect to the server")
    } finally {
      this.loaderTarget.classList.add("hidden")
    }
  }

  renderResults(data) {
    this.suggestionsTarget.innerHTML = ""
    
    data.suggestions.forEach(suggestion => {
      const div = document.createElement("div")
      div.className = "flex justify-between items-center p-3 bg-surface rounded-lg border border-divider"
      
      const tradeType = suggestion.suggested_trade_value > 0 ? "BUY" : "SELL"
      const tradeColor = suggestion.suggested_trade_value > 0 ? "text-green-600" : "text-red-600"
      
      div.innerHTML = `
        <div>
          <p class="font-medium">${suggestion.ticker}</p>
          <p class="text-xs text-secondary">Target Weight: ${(suggestion.target_weight * 100).toFixed(2)}%</p>
        </div>
        <div class="text-right">
          <p class="font-semibold ${tradeColor}">${tradeType} ${Math.abs(suggestion.suggested_trade_value).toLocaleString(undefined, { style: 'currency', currency: 'USD' })}</p>
          <p class="text-xs text-secondary">Diff: ${(suggestion.target_weight - suggestion.current_weight).toFixed(2)}%</p>
        </div>
      `
      this.suggestionsTarget.appendChild(div)
    })
    
    this.resultsTarget.classList.remove("hidden")
  }
}
