import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display"]
  static values = {
    endsAt: String,
    sessionId: Number
  }

  connect() {
    this.updateCountdown()
    this.timer = setInterval(() => {
      this.updateCountdown()
    }, 1000)
  }

  disconnect() {
    if (this.timer) {
      clearInterval(this.timer)
    }
  }

  updateCountdown() {
    const endsAt = new Date(this.endsAtValue)
    const now = new Date()
    const diff = endsAt - now
    const seconds = Math.floor(diff / 1000)

    if (seconds <= 0) {
      this.displayTarget.textContent = "00:00"
      this.updateRowClass(seconds)
      return
    }

    const hours = Math.floor(seconds / 3600)
    const minutes = Math.floor((seconds % 3600) / 60)
    const secs = seconds % 60

    let formatted
    if (hours > 0) {
      formatted = `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(secs).padStart(2, '0')}`
    } else {
      formatted = `${String(minutes).padStart(2, '0')}:${String(secs).padStart(2, '0')}`
    }

    this.displayTarget.textContent = formatted
    this.updateRowClass(seconds)
  }

  updateRowClass(seconds) {
    const row = this.element

    // Remove classes existentes
    row.classList.remove('bg-red-50', 'bg-yellow-50', 'animate-blink')

    if (seconds <= 0) {
      row.classList.add('bg-red-50', 'animate-blink')
    } else if (seconds < 600) {
      row.classList.add('bg-yellow-50')
    }
  }
}
