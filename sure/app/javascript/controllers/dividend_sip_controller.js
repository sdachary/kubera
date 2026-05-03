import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["monthlyInvestment", "targetIncome"]

  async calculate(event) {
    event.preventDefault()

    const monthlyInvestment = this.monthlyInvestmentTarget.value
    const targetIncome = this.targetIncomeTarget.value

    const response = await fetch(`/api/v1/dividend_sip/suggest?monthly_investment=${monthlyInvestment}&target_income=${targetIncome}`, {
      headers: {
        "Accept": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      }
    })

    if (response.ok) {
      const data = await response.json()
      this.renderResults(data)
    } else {
      console.error("Failed to fetch suggestions")
    }
  }

  renderResults(data) {
    const resultsContainer = document.getElementById("dividend_sip_results")
    
    // We can either render a client-side template or fetch a partial from the server
    // For simplicity here, let's build the HTML or use a template
    
    let stocksHtml = data.suggestions.map(stock => `
      <tr class="border-b last:border-0">
        <td class="py-3">
          <div class="font-medium text-gray-900">${stock.symbol}</div>
          <div class="text-xs text-gray-500">${stock.name}</div>
        </td>
        <td class="py-3 text-right text-green-600 font-semibold">
          ${stock.dividend_yield}%
        </td>
        <td class="py-3 text-right">
          <span class="px-2 py-1 text-xs rounded-full ${this.getRiskClass(stock.risk)}">
            ${stock.risk.charAt(0).toUpperCase() + stock.risk.slice(1)}
          </span>
        </td>
      </tr>
    `).join('')

    resultsContainer.innerHTML = `
      <div class="space-y-8">
        <div class="bg-white shadow rounded-lg p-6 animate-fade-in">
          <h2 class="text-xl font-semibold mb-4">SIP Timeline Projection</h2>
          <div class="grid grid-cols-2 gap-4">
            <div class="p-4 bg-blue-50 rounded-lg">
              <div class="text-sm text-blue-600 font-medium">Months to Target</div>
              <div class="text-2xl font-bold text-blue-900">${data.timeline.months} months</div>
              <div class="text-sm text-blue-700">(~${data.timeline.years} years)</div>
            </div>
            <div class="p-4 bg-green-50 rounded-lg">
              <div class="text-sm text-green-600 font-medium">Target Corpus</div>
              <div class="text-2xl font-bold text-green-900">₹${new Intl.NumberFormat('en-IN').format(Math.round(data.timeline.target_corpus))}</div>
              <div class="text-sm text-green-700">@ ${data.timeline.avg_yield_percent}% avg yield</div>
            </div>
          </div>
        </div>

        <div class="bg-white shadow rounded-lg p-6 animate-fade-in">
          <h2 class="text-xl font-semibold mb-4">Stock Suggestions (NSE/BSE)</h2>
          <div class="overflow-x-auto">
            <table class="w-full text-left">
              <thead>
                <tr class="border-b">
                  <th class="py-2 font-medium text-gray-700">Symbol</th>
                  <th class="py-2 font-medium text-gray-700 text-right">Yield (%)</th>
                  <th class="py-2 font-medium text-gray-700 text-right">Risk</th>
                </tr>
              </thead>
              <tbody>
                ${stocksHtml}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    `
  }

  getRiskClass(risk) {
    switch (risk) {
      case "low": return "bg-green-100 text-green-800"
      case "medium": return "bg-yellow-100 text-yellow-800"
      case "high": return "bg-red-100 text-red-800"
      default: return "bg-gray-100 text-gray-800"
    }
  }
}
