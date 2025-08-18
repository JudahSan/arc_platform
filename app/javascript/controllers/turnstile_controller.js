import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    sitekey: String,
    size: String,
    theme: String,
  }
  static targets = ["turnstile"]

  connect() {
    // Disable submit until challenge solved (if button exists)
    if (this.closestSubmitButton) {
      this.closestSubmitButton.setAttribute("disabled", "disabled")
    }

    this._setupRender()
  }

  disconnect() {
    if (this._waitInterval) {
      clearInterval(this._waitInterval)
      this._waitInterval = null
    }
  }

  _setupRender() {
    if (!this.turnstileTarget) return

    const render = () => {
      window.turnstile.render(this.turnstileTarget, {
        sitekey: this.sitekeyValue,
        size: this.sizeValue,
        theme: this.themeValue,
        callback: () => this._enableClosestSubmitButton(),
      })
    }

    if (window.turnstile) {
      render()
      return
    }

    // Fallback: wait for Turnstile to be available (e.g., script still loading)
    this._waitInterval = setInterval(() => {
      if (window.turnstile) {
        clearInterval(this._waitInterval)
        this._waitInterval = null
        render()
      }
    }, 100)

    // Safety timeout to stop polling after 7 seconds
    setTimeout(() => {
      if (this._waitInterval) {
        clearInterval(this._waitInterval)
        this._waitInterval = null
      }
    }, 7000)
  }

  _enableClosestSubmitButton() {
    if (this.closestSubmitButton) {
      this.closestSubmitButton.removeAttribute("disabled")
    }
  }

  get closestSubmitButton() {
    const form = this.element.closest("form")
    return form ? form.querySelector("button[type=submit]") : null
  }
}
