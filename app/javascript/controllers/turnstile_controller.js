import { Controller } from "@hotwired/stimulus";

/**
 * Cloudflare Turnstile Stimulus controller
 *
 * Responsibilities:
 * - Renders the Turnstile widget into the provided target element once the
 *   Cloudflare script is available (it may arrive asynchronously).
 * - Disables the nearest form submit button until the Turnstile challenge is
 *   solved, then re-enables it via the Turnstile callback.
 * - Supports explicit configuration via Stimulus values: sitekey, size, theme.
 *
 * Requirements:
 * - Include the Turnstile script tag in your layout (already present in
 *   app/views/layouts/application.html.erb):
 *     <%= javascript_include_tag "https://challenges.cloudflare.com/turnstile/v0/api.js?render=explicit", defer: true, async: true %>
 * - Provide a container element with data-controller="turnstile" and a nested
 *   data-turnstile-target="turnstile" div for rendering.
 * - Ensure sitekey value is provided, typically from credentials.
 *
 * Example (see shared/_cloudflare_turnstile.html.erb):
 *   <div data-controller="turnstile"
 *        data-turnstile-sitekey-value="..."
 *        data-turnstile-size-value="flexible"
 *        data-turnstile-theme-value="light">
 *     <div data-turnstile-target="turnstile"></div>
 *   </div>
 */
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
