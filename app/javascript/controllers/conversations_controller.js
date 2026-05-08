import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  async new() {
    const response = await fetch("/conversations", {
      method: "POST",
      headers: { "Content-Type": "application/json", "X-CSRF-Token": this.csrfToken() },
      body: JSON.stringify({ title: "New Conversation" })
    })
    if (response.ok) {
      const data = await response.json()
      window.location.href = `/?conversation_id=${data.id}`
    }
  }

  csrfToken() {
    return document.querySelector('meta[name="csrf-token"]')?.content
  }
}
