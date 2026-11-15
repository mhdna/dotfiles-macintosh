// Chart.js set up the way Lichess sets it up (lila ui/chart/src/index.ts and
// chart.ratingHistory.ts): Noto Sans 12px, its exact grid / font / tooltip
// colors per theme, 1.5px straight lines with no resting points, a 6px
// point on hover with a white ring, and each series told apart by color AND
// a dash pattern AND a point shape (so it reads without color too).

/* global Chart */
;(() => {
const series = [
  { color: '#56B4E9', dash: [], point: 'circle' },
  { color: '#E69F00', dash: [6, 3], point: 'rectRot' },
  { color: '#009E73', dash: [12, 4], point: 'rect' },
  { color: '#D55E00', dash: [2, 3], point: 'triangle' },
]

function themeColors () {
  const light = document.documentElement.classList.contains('light')
  return {
    light,
    font: light ? '#2F2F2F' : 'hsl(0 0% 73%)',
    grid: light ? '#ccc' : '#404040',
    zero: light ? '#959595' : '#676664',
    hoverBorder: light ? '#ccc' : 'white',
    tooltipBg: light ? 'rgb(255 255 255 / 0.85)' : 'rgb(22 21 18 / 0.85)',
    // The distribution chart's fill, top to bottom (chart.ratingDistribution.ts).
    area: '#7798bf',
  }
}

function baseOptions (c, { yTitle, money = false, stacked = false } = {}) {
  const rtl = document.documentElement.dir === 'rtl'
  const fmt = v => money ? '$' + Number(v).toLocaleString('en-US') : Number(v).toLocaleString('en-US')
  return {
    animation: false,
    responsive: true,
    maintainAspectRatio: false,
    interaction: { mode: 'index', intersect: false },
    layout: { padding: { top: 8 } },
    scales: {
      x: {
        stacked,
        reverse: rtl,
        grid: { display: false },
        border: { color: c.grid },
        ticks: { color: c.font, maxRotation: 0, autoSkipPadding: 12 },
      },
      y: {
        stacked,
        position: rtl ? 'left' : 'right',
        border: { display: false },
        grid: { color: ctx => (ctx.tick.value === 0 ? c.zero : c.grid), tickLength: 0 },
        ticks: { color: c.font, padding: 10, maxTicksLimit: 7, callback: fmt },
        title: yTitle ? { display: true, text: yTitle, color: c.font } : { display: false },
      },
    },
    plugins: {
      legend: {
        rtl,
        position: 'top',
        align: 'start',
        labels: { color: c.font, usePointStyle: true, boxWidth: 8, boxHeight: 8, padding: 16 },
      },
      tooltip: {
        rtl,
        usePointStyle: true,
        boxPadding: 2, boxWidth: 8, boxHeight: 8, padding: 6,
        backgroundColor: c.tooltipBg,
        bodyColor: c.font, titleColor: c.font,
        borderColor: c.grid, borderWidth: 1,
        caretPadding: 10,
        callbacks: { label: ctx => `${ctx.dataset.label}: ${fmt(ctx.parsed.y)}` },
      },
    },
  }
}

// Line chart: one or more series over time.
function lineDatasets (sets) {
  return sets.map((s, i) => ({
    label: s.label,
    data: s.data,
    borderColor: series[i].color,
    backgroundColor: series[i].color,
    borderDash: series[i].dash,
    pointStyle: series[i].point,
    borderWidth: 1.5,
    tension: 0,
    pointRadius: s.data.length === 1 ? 3 : 0,
    pointHoverRadius: 6,
    pointHoverBorderWidth: 2,
    pointHoverBorderColor: '#fff9',
    pointHitRadius: 20,
  }))
}

// Area chart with Lichess's blue fill gradient (single series).
function areaDataset (s, c, ctx) {
  const g = ctx.createLinearGradient(0, 0, 0, 400)
  g.addColorStop(0, 'rgb(119 152 191 / 1)')
  g.addColorStop(1, 'rgb(119 152 191 / 0.3)')
  return {
    label: s.label, data: s.data, fill: true, backgroundColor: g,
    borderColor: c.area, pointBackgroundColor: c.area, borderWidth: 1.5, tension: 0,
    pointRadius: 4, pointHoverRadius: 6, pointHoverBorderWidth: 2, pointHoverBorderColor: c.hoverBorder,
  }
}

// Bars: flat fills, 2px gaps between neighbours.
function barDatasets (sets) {
  return sets.map((s, i) => ({
    label: s.label, data: s.data,
    backgroundColor: series[i].color, borderColor: 'transparent',
    borderWidth: 0, borderRadius: 2, borderSkipped: 'start', barPercentage: 0.8, categoryPercentage: 0.85,
    pointStyle: series[i].point,
  }))
}

const charts = []

// make(canvasId, build) where build(colors, ctx) returns a Chart.js config.
// Charts rebuild when the theme or direction changes.
function make (id, build) {
  const el = document.getElementById(id)
  if (!el || !window.Chart) return
  const draw = () => {
    Chart.getChart(el)?.destroy()
    const c = themeColors()
    Chart.defaults.font = { family: "'Noto Sans', 'Noto Sans Arabic', 'Lucida Grande', Verdana, Arial, sans-serif", size: 12 }
    new Chart(el, build(c, el.getContext('2d')))
  }
  charts.push(draw)
  draw()
}

document.addEventListener('themechange', () => charts.forEach(draw => draw()))

  window.lichessCharts = { make, baseOptions, lineDatasets, barDatasets, areaDataset, series }
})()
