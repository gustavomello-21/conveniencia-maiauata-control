import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["searchInput", "searchResults", "cartBody", "totalAmount", "discountInput", "finalAmount", "emptyMessage", "submitButton", "itemsPayload"]

  connect() {
    this.items = []
    this.searchTimeout = null
  }

  search() {
    clearTimeout(this.searchTimeout)
    const query = this.searchInputTarget.value.trim()

    if (query.length < 1) {
      this.searchResultsTarget.innerHTML = ""
      this.searchResultsTarget.classList.add("hidden")
      return
    }

    this.searchTimeout = setTimeout(() => {
      this.performSearch(query)
    }, 300)
  }

  async performSearch(query) {
    try {
      const response = await fetch(`/vendas/search?q=${encodeURIComponent(query)}`)
      const products = await response.json()
      this.renderSearchResults(products)
    } catch (error) {
      console.error("Erro ao buscar produtos:", error)
    }
  }

  renderSearchResults(products) {
    const container = this.searchResultsTarget

    if (products.length === 0) {
      container.innerHTML = '<div class="p-3 text-gray-500">Nenhum produto encontrado</div>'
      container.classList.remove("hidden")
      return
    }

    container.innerHTML = products.map(p => `
      <button type="button"
              class="w-full text-left px-4 py-2 hover:bg-blue-50 flex justify-between items-center border-b last:border-b-0"
              data-action="click->cart#addProduct"
              data-product-id="${p.id}"
              data-product-name="${this.escapeHtml(p.name)}"
              data-product-price="${p.price}"
              data-product-stock="${p.stock_quantity}">
        <span class="font-medium">${this.escapeHtml(p.name)}</span>
        <span class="text-sm text-gray-500">R$ ${p.price.toFixed(2)} | Estoque: ${p.stock_quantity}</span>
      </button>
    `).join("")

    container.classList.remove("hidden")
  }

  addProduct(event) {
    const btn = event.currentTarget
    const productId = parseInt(btn.dataset.productId)
    const name = btn.dataset.productName
    const price = parseFloat(btn.dataset.productPrice)
    const stock = parseInt(btn.dataset.productStock)

    const existing = this.items.find(i => i.productId === productId)
    if (existing) {
      if (existing.quantity < stock) {
        existing.quantity += 1
      }
    } else {
      this.items.push({ productId, name, price, stock, quantity: 1 })
    }

    this.searchInputTarget.value = ""
    this.searchResultsTarget.innerHTML = ""
    this.searchResultsTarget.classList.add("hidden")
    this.searchInputTarget.focus()

    this.renderCart()
  }

  removeItem(event) {
    const index = parseInt(event.currentTarget.dataset.index)
    this.items.splice(index, 1)
    this.renderCart()
  }

  updateQuantity(event) {
    const index = parseInt(event.currentTarget.dataset.index)
    const newQty = parseInt(event.currentTarget.value)
    const item = this.items[index]

    if (newQty > 0 && newQty <= item.stock) {
      item.quantity = newQty
    } else if (newQty > item.stock) {
      item.quantity = item.stock
      event.currentTarget.value = item.stock
    } else {
      item.quantity = 1
      event.currentTarget.value = 1
    }

    this.renderCart()
  }

  updateDiscount() {
    this.renderCart()
  }

  renderCart() {
    const tbody = this.cartBodyTarget

    if (this.items.length === 0) {
      this.emptyMessageTarget.classList.remove("hidden")
      tbody.innerHTML = ""
      this.totalAmountTarget.textContent = "R$ 0,00"
      this.finalAmountTarget.textContent = "R$ 0,00"
      this.submitButtonTarget.disabled = true
      this.submitButtonTarget.classList.add("opacity-50", "cursor-not-allowed")
      this.itemsPayloadTarget.value = "[]"
      return
    }

    this.emptyMessageTarget.classList.add("hidden")
    this.submitButtonTarget.disabled = false
    this.submitButtonTarget.classList.remove("opacity-50", "cursor-not-allowed")

    let total = 0

    tbody.innerHTML = this.items.map((item, index) => {
      const subtotal = item.price * item.quantity
      total += subtotal
      return `
        <tr class="border-b">
          <td class="py-3 px-4">${this.escapeHtml(item.name)}</td>
          <td class="py-3 px-4 text-center">R$ ${item.price.toFixed(2)}</td>
          <td class="py-3 px-4 text-center">
            <input type="number" min="1" max="${item.stock}" value="${item.quantity}"
                   class="w-20 border rounded px-2 py-1 text-center"
                   data-action="change->cart#updateQuantity"
                   data-index="${index}">
          </td>
          <td class="py-3 px-4 text-center">R$ ${subtotal.toFixed(2)}</td>
          <td class="py-3 px-4 text-center">
            <button type="button" class="text-red-600 hover:text-red-800 font-bold text-lg"
                    data-action="click->cart#removeItem"
                    data-index="${index}">&times;</button>
          </td>
        </tr>
      `
    }).join("")

    const discount = parseFloat(this.discountInputTarget.value) || 0
    const finalAmount = Math.max(total - discount, 0)

    this.totalAmountTarget.textContent = `R$ ${total.toFixed(2).replace(".", ",")}`
    this.finalAmountTarget.textContent = `R$ ${finalAmount.toFixed(2).replace(".", ",")}`

    // Update hidden payload
    this.itemsPayloadTarget.value = JSON.stringify(
      this.items.map(i => ({ product_id: i.productId, quantity: i.quantity }))
    )
  }

  hideResults(event) {
    // Delay to allow click on result
    setTimeout(() => {
      this.searchResultsTarget.classList.add("hidden")
    }, 200)
  }

  escapeHtml(text) {
    const div = document.createElement("div")
    div.textContent = text
    return div.innerHTML
  }
}
