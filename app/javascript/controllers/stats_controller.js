import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Stats are server-rendered, this controller handles
    // any interactive refresh functionality
  }
}
