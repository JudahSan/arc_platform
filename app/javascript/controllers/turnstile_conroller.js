import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
    static values = {
        sitekey: String,
        size: String,
        theme: String,
    }
    static targets = ["turnstile"]

    connect() {
        console.log("Turnstile connected");
        if (this.turnstileTarget && window.turnstile) {
            window.turnstile.render(this.turnstileTarget, {
                sitekey: this.sitekeyValue,
                size: this.sizeValue,
                theme: this.themeValue,
                callback: () => {
                    this._enableClosestSubmitButton();
                }
            })
        }
    }
    _enableClosestSubmitButton() {
        if (this.closestSubmitButton) {
            this.closestSubmitButton.removeAttribute("disabled");
        }
    }

    get closestSubmitButton() {
        return this.element.closest("form").querySelector("button[type=submit]");
    }
}
