import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.resize()
  }

  resize() {
    this.inputTarget.style.height = "auto"
    this.inputTarget.style.height = Math.min(this.inputTarget.scrollHeight, 200) + "px"
  }

  submit(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.element.requestSubmit()
    }
  }

  reset() {
    this.inputTarget.value = ""
    this.resize()
    // Scroll chat to bottom
    const chat = document.querySelector("[data-controller='chat']")
    if (chat) {
      setTimeout(() => chat.scrollTop = chat.scrollHeight, 100)
    }
  }
}
