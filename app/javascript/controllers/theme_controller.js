import { Controller } from "@hotwired/stimulus"

// Manages light/dark theme toggle with cookie persistence
export default class extends Controller {
  connect() {
    const saved = this.#readCookie("arc_theme") || "mytheme"
    this.#applyTheme(saved)
  }

  toggle() {
    const current = document.documentElement.getAttribute("data-theme") || "mytheme"
    const next = current === "dark" ? "mytheme" : "dark"
    this.#applyTheme(next)
    this.#writeCookie("arc_theme", next, 365)
  }

  #applyTheme(theme) {
    const isDark = theme === "dark"
    document.documentElement.setAttribute("data-theme", theme)

    // Toggle moon/sun icons across ALL toggle buttons on the page
    document.querySelectorAll("[data-theme-moon]").forEach(el => {
      el.style.display = isDark ? "none" : "inline"
    })
    document.querySelectorAll("[data-theme-sun]").forEach(el => {
      el.style.display = isDark ? "inline" : "none"
    })
  }

  #readCookie(name) {
    const match = document.cookie.match(new RegExp("(^| )" + name + "=([^;]+)"))
    return match ? match[2] : null
  }

  #writeCookie(name, value, days) {
    const d = new Date()
    d.setTime(d.getTime() + days * 86400000)
    document.cookie = `${name}=${value};expires=${d.toUTCString()};path=/;SameSite=Lax`
  }
}
