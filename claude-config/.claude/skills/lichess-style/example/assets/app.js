// Shared behavior for the example pages: the header, theme and direction
// switches (remembered between pages), dialogs, tabs and toggle boxes.

const store = {
  get(key) { try { return localStorage.getItem(key) } catch { return null } },
  set(key, value) { try { localStorage.setItem(key, value) } catch { /* private mode */ } },
}

const root = document.documentElement
if (store.get('theme') === 'light') root.classList.add('light')
if (store.get('dir') === 'rtl') root.dir = 'rtl'

const icons = {
  logo: '<svg class="icon" viewBox="0 0 24 24"><path d="M3 7l9-4 9 4v10l-9 4-9-4z"/><path d="M3 7l9 4 9-4M12 11v10"/></svg>',
  sun: '<svg class="icon" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4"/></svg>',
  search: '<svg class="icon" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="M20 20l-4-4"/></svg>',
  bell: '<svg class="icon" viewBox="0 0 24 24"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10 21a2 2 0 0 0 4 0"/></svg>',
}

const nav = [
  ['Stock', 'products.html', [['All products', 'products.html'], ['Panadol 500 mg', 'product.html'], ['Low stock', 'products.html#low'], ['Expiring soon', 'products.html#expiring']]],
  ['Orders', 'orders.html', [['Open orders', 'orders.html'], ['Received', 'orders.html#received'], ['Suppliers', 'orders.html#suppliers']]],
  ['Reports', 'reports.html', [['Sales and profit', 'reports.html'], ['Stock value', 'reports.html#value'], ['Expiry', 'reports.html#expiry']]],
  ['More', 'components.html', [['Settings', 'settings.html'], ['Every component', 'components.html']]],
]

function renderHeader () {
  const top = document.getElementById('top')
  if (!top) return
  top.innerHTML = `
    <div class="site-title-nav">
      <a class="site-title" href="index.html">${icons.logo}<div>stockroom<span>.app</span></div></a>
      <nav id="topnav">
        ${nav.map(([label, href, items]) => `
          <section>
            <a href="${href}">${label}</a>
            <div>${items.map(([text, link]) => `<a href="${link}">${text}</a>`).join('')}</div>
          </section>`).join('')}
      </nav>
    </div>
    <div class="site-buttons">
      <button class="link" id="dir-toggle" title="Switch reading direction">ع</button>
      <button class="link" id="theme-toggle" title="Switch light or dark">${icons.sun}</button>
      <a class="link" href="products.html" title="Search">${icons.search}</a>
      <button class="link" data-open="notifications" title="Notifications">${icons.bell}</button>
      <a class="link user-tag" href="settings.html">rana.haddad</a>
    </div>`

  document.getElementById('theme-toggle').onclick = () => {
    root.classList.toggle('light')
    store.set('theme', root.classList.contains('light') ? 'light' : 'dark')
    document.dispatchEvent(new Event('themechange'))
  }
  document.getElementById('dir-toggle').onclick = () => {
    root.dir = root.dir === 'rtl' ? 'ltr' : 'rtl'
    store.set('dir', root.dir)
    document.dispatchEvent(new Event('themechange'))
  }
  addEventListener('scroll', () => top.classList.toggle('scrolled', scrollY > 0), { passive: true })
}

// The notifications dialog lives on every page.
function renderNotifications () {
  const dlg = document.createElement('dialog')
  dlg.id = 'notifications'
  dlg.innerHTML = `
    <button class="close-button" data-close aria-label="Close">&times;</button>
    <div class="dialog-content" style="text-align:start;width:min(420px,92vw)">
      <h2>Notifications</h2>
      <table class="slist" style="margin-top:1em">
        <tbody>
          <tr><td>Order 1042 from Mersaco arrived</td><td><time>10:42</time></td></tr>
          <tr><td>Panadol 500 mg is below its minimum</td><td><time>09:15</time></td></tr>
          <tr><td>Batch 2291 of Augmentin expires in 12 days</td><td><time>Yesterday</time></td></tr>
        </tbody>
      </table>
    </div>`
  document.body.append(dlg)
}

// data-open="dialog-id" opens a dialog, data-close closes the one it's in,
// and a click on the dark mask around a dialog closes it too.
function wireDialogs () {
  document.addEventListener('click', e => {
    const opener = e.target.closest('[data-open]')
    if (opener) document.getElementById(opener.dataset.open)?.showModal()
    const closer = e.target.closest('[data-close]')
    if (closer) closer.closest('dialog')?.close()
    if (e.target.tagName === 'DIALOG') e.target.close()
  })
}

// .tabs-horiz with data-tabs="group": each tab's data-tab shows the matching
// [data-panel] in that group.
function wireTabs () {
  document.querySelectorAll('.tabs-horiz[data-tabs]').forEach(bar => {
    const group = bar.dataset.tabs
    bar.addEventListener('click', e => {
      const tab = e.target.closest('[data-tab]')
      if (!tab) return
      bar.querySelectorAll('[data-tab]').forEach(t => t.classList.toggle('active', t === tab))
      document.querySelectorAll(`[data-panel-group="${group}"]`).forEach(p => { p.hidden = p.dataset.panel !== tab.dataset.tab })
    })
  })
  document.querySelectorAll('.time-selector-buttons').forEach(bar => {
    bar.addEventListener('click', e => {
      const b = e.target.closest('button')
      if (!b) return
      bar.querySelectorAll('button').forEach(x => x.classList.toggle('active', x === b))
      bar.dispatchEvent(new CustomEvent('range', { detail: b.dataset.range, bubbles: true }))
    })
  })
}

function wireToggleBoxes () {
  document.querySelectorAll('.toggle-box legend').forEach(legend => {
    legend.addEventListener('click', () => legend.parentElement.classList.toggle('toggle-box--off'))
  })
}

// Mark the current page in the side menu.
function markSubnav () {
  const here = location.pathname.split('/').pop() + location.hash
  document.querySelectorAll('.subnav a').forEach(a => {
    if (a.getAttribute('href') === here) a.classList.add('active')
  })
}

renderHeader()
renderNotifications()
wireDialogs()
wireTabs()
wireToggleBoxes()
markSubnav()
