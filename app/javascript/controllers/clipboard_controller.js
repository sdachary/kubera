import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source"]

  copy(event) {
    const text = event.currentTarget.dataset.clipboardText
    navigator.clipboard.writeText(text).then(() => {
      const button = event.currentTarget
      const original = button.textContent
      button.textContent = "Copied!"
      button.classList.remove("bg-teal-500", "hover:bg-teal-600")
      button.classList.add("bg-green-500")
      setTimeout(() => {
        button.textContent = original
        button.classList.remove("bg-green-500")
        button.classList.add("bg-teal-500", "hover:bg-teal-600")
      }, 2000)
    })
  }
}
