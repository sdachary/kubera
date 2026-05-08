import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["messages"]
  static values = { conversationId: String }

  connect() {
    this.scrollToBottom()
  }

  setPrompt(event) {
    const prompt = event.currentTarget.dataset.prompt
    const input = document.querySelector("[data-chat-form-target='input']")
    if (input) {
      input.value = prompt
      input.dispatchEvent(new Event("input"))
      input.focus()
    }
  }

  scrollToBottom() {
    this.element.scrollTop = this.element.scrollHeight
  }
}
