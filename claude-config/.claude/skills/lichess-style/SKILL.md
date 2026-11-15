---
name: "lichess-style"
description: "Only when the person explicitly asks for the Lichess style, Lichess look or Lichess theme for a web app. Gives the exact Lichess web app look (warm dark theme, Noto Sans and Roboto, metal buttons, zebra tables, uppercase top nav, boxes on a gradient page) as a ready stylesheet, the patterns to build with, and an example site. Never use it by default."
---

# Lichess style

The look of the Lichess web app, taken from its source (github.com/lichess-org/lila,
`ui/lib/css`, commit 4a427ef, read 2026-11-15) so it can be reproduced exactly.
Use it **only when the person asks for it**. It is a style to follow, not a brand
to copy (see "What never to copy").

Files in this folder:

- `lichess-style.css`: the whole system as plain CSS with the real values. **Copy it
  into the project unchanged** and build on its classes. Do not retype values from
  memory.
- `example/`: a complete multi-page example site (an original pharmacy stock app,
  "stockroom.app") using every pattern below. Open `example/index.html` to see the
  target look, then copy its structure:
  - `index.html`: dashboard (headline numbers, line chart with period buttons, bar
    chart, area chart, short table, activity feed)
  - `products.html`: list page (side menu, search, filters, segmented radio, tabs per
    store, table, pagination, empty state, warning flash, add and import dialogs)
  - `product.html`: detail page (failure flash, facts list, actions, chart, tabbed
    tables, adjust, delete-confirm and success dialogs)
  - `orders.html`: tabs of tables, order detail dialog with a totals row, a receive
    dialog with checkboxes, a form dialog with toggles
  - `reports.html`: four-series chart with a metric switch, bar charts, area chart,
    data tables under charts, collapsible boxes
  - `settings.html`: long form (split fields, help and error text, segmented radios,
    toggles including disabled), users table, danger zone
  - `components.html`: every component and seven kinds of dialog side by side
  - `assets/app.js`: header, theme and direction switches (remembered), dialogs
    (`data-open` / `data-close`), tabs (`data-tabs` / `data-panel`), toggle boxes
  - `assets/charts.js`: Chart.js themed exactly like Lichess (see Charts below)

## How it works with my other rules

When this style is requested, the exact Lichess look wins over the default-look and
shape rules of design-without-ai-look (its 7px corners, uppercase Roboto buttons,
metal gradients and inset shadows, colored primary buttons are all part of the
style). These rules from my-rules.md still always apply: no long dashes, no dot
separators, no decorative live or online dots (Lichess shows a green dot for online
users; leave it out), real copy, and the Arabic and right-to-left rules.

## What never to copy

Not the name, the wordmark "lichess.org", the knight logo, the `lichess` icon font,
the `Noto Chess` font, piece sets, board themes, chess-specific screens, or any of
its text. The project keeps its own name and icons; only the visual system is used.
Use a simple inline SVG icon set (stroke 2, round caps) in place of the icon font.

## Foundations

**Theme switching.** Dark is the default. `html.light` switches to light. Both are
in the CSS. Every color is a CSS variable (`--c-*`) so components never hard-code a
color. The whole dark palette is warm: one hue, `---site-hue: 37deg`, tints every
background (a very slightly brown grey, never a cold or blue grey).

**Dark palette (the values that set the feel).**

| Token | Value | Job |
|---|---|---|
| `--c-bg-page` | hsl(37 10% 8%) | page background under everything |
| `--c-body-gradient` | hsl(37 12% 16%) | top 116px of the page fades from this into bg-page |
| `--c-bg` / `--c-bg-box` | hsl(37 7% 14%) | boxes (the main surfaces) |
| `--c-bg-zebra` | hsl(37 5% 19%) | every other table row, quiet panels |
| `--c-bg-low` / popup | hsl(37 7% 22%) | dropdowns, popups |
| `--c-font` | hsl(0 0% 73%) | body text, a soft grey, never white |
| `--c-font-dim` | hsl(0 0% 58%) | secondary text, placeholders |
| `--c-font-clear` / clearer | 80% / 89% lightness | emphasized text, hover |
| `--c-border` | hsl(0 0% 25%) | 1px borders |
| `--c-primary` | hsl(209 79% 56%) | the blue: links, primary buttons, focus, active nav |
| `--c-secondary` / `--c-good` | hsl(88 62% 37%) | the green: success, toggles on, pressed buttons, save |
| `--c-accent` | hsl(22 100% 42%) | the orange: active tab underline, mobile nav marker |
| `--c-brag` | hsl(37 74% 43%) | gold: highlights and warnings |
| `--c-bad` / error | hsl(0 60% 50%) | red: destructive and errors |
| metal top / bottom | hsl(37 7% 22%) / hsl(37 5% 19%) | neutral raised buttons and table heads |

**Light palette.** White boxes (`--c-bg` 100%), page hsl(37 10% 92%), page gradient
hsl(37 12% 84%), text hsl(0 0% 30%), dim text 47%, borders 85%, primary
hsl(209 77% 46%), metal 96% to 93%.

**Type.**

- Text: Noto Sans 400, bold 700. Headings, buttons, table heads, tabs: Roboto 300
  (buttons 500). For Arabic add Noto Sans Arabic as the fallback in both stacks (the
  CSS already does).
- Root size is fluid: 12px at 320px wide to 14px at 1200px wide. Everything else is
  in rem or em, so the whole UI scales with the window.
- h1 fluid 19px to 38px, h2 16px to 30px, both Roboto **300 (light)**. Light, big
  headings next to small Noto text is the signature contrast.
- Top nav labels and buttons are UPPERCASE. Body text never is.
- Antialiased font smoothing on.

**Shape and depth.**

- Corner radius 7px (`---ui-roundness`) for boxes, buttons, inputs, toggles; half
  (3.5px) for small things (pagination cells, dropdown corners). Only the dialog close
  button is round.
- Boxes have a soft three-layer Material shadow, no border.
- Buttons have depth from inset shadows: a light line on the top edge and a darker
  band at the bottom edge, plus a 1px drop shadow. Hover brightens (filter 1.15)
  and deepens the drop shadow. Never flat, never glowing.
- Transitions 150ms ease. Reduced motion turns all of it off.

**Layout.**

- Header `#top`: 40px tall, 60px when the window is at least 600px tall; sticky; on
  scroll it gets the body gradient, a 1px border and a faint shadow (`.scrolled`).
- Left: wordmark at 25px (30px tall header), name in the font color, the domain
  suffix in the dim color, hover turns it blue. Then the top nav.
- Top nav: uppercase section labels in the dim page color, 35px (53px) tall. Hover
  opens a dropdown under the section: popup background, 2px blue border on its
  start edge, square top-start corner, items 0.6rem 0.7rem, item hover = solid blue
  with white text. Hidden below 1020px wide (a hamburger takes over).
- Right: plain icon links, 1.1rem, 0.7rem side padding, font color, hover to the
  clearest text. The signed-in username sits at the end.
- Main: a 5-column grid centering one column of max 1300px, with 1vw outer margins
  from 800px up. Gaps between blocks 10px, 15px from 800px.
- Page with a menu: `.page-menu` = side `.subnav` (max-content wide) + content. Subnav
  links: dim page color, 0.7rem padding, 7px radius; hover a 7% grey wash; the active
  link takes the box background so it looks joined to the content box. Under 800px the
  subnav becomes a horizontal scroll row, active link marked by a 4px orange bar.
- Text placed directly on the page background (outside a box) uses the page font
  color with a 1px text shadow (`.page-text`).

## Components (classes in lichess-style.css)

- **Box** `.box`: the content surface. `.box__top` = title row (h1 left, actions right,
  wraps), padding 4vh vertical and fluid 10px to 50px horizontal. `.box-pad` pads the
  whole box. `.box__pad` pads horizontally only. Tables run edge to edge inside a box.
- **Buttons** `.button`: blue, white uppercase Roboto 500, padding 0.8em 1em.
  - `.button-green` (save, confirm, positive), `.button-red` (destructive).
  - `.button-metal`: the neutral raised grey button with a vertical gradient (secondary
    actions like Export, Cancel).
  - `.button-empty`: text only in blue (or `-red`, `-green`, `-dim`); shows the metal
    surface on hover. Used for actions inside table rows.
  - `.button-thin` (small rows), `.button-fat` (hero call to action), `.button-no-upper`.
  - `.active`: pressed or selected, green with an inset shadow.
  - `.button-set`: a row of buttons with 1.5em gaps.
- **Tables** `.slist`: full width; head row is the metal gradient with Roboto 300
  labels and a bottom border; body cells 1rem padding; even rows zebra; first cell
  1.5rem start padding (`.slist-pad` uses the box padding on both ends so the table
  lines up with the box title). Wrap in `.slist-wrapper` for horizontal scroll.
- **Tabs** `.tabs-horiz`: equal-width Roboto 300 labels with a 2px bottom border;
  hover shows a half-transparent orange line, active is solid orange text and line.
- **Forms** `.form3`: `.form-group` (3rem below), `.form-split` with `.form-half` /
  `.form-third`, bold `.form-label`, `.form-control` inputs 2.7em tall on the input
  background with a 1px border and 7px radius, `.form-help` dim at 90%, `.error` red,
  `.form-actions` row with a top border (reset or cancel at the start, the green save
  at the end).
- **Toggle** `.cmn-toggle` (input + label): 40 by 24, 7px radius, dimmer grey track,
  metal square knob; on = green track, knob slides 16px. Never a round iOS switch.
- **Flash** `.flash`: solid green bar with white text; `.flash-warning` gold,
  `.flash-failure` red, `.flash-box` / `.flash-quiet` neutral zebra panel with a blue
  link. Solid fills, never pale tints.
- **Pagination** `.pagination`: 2rem square cells with 3.5px corners, dimmer text,
  hover a 10% blue wash, current page solid blue with white text.
- **Dialog** native `<dialog>`: centered, 7px radius, large soft shadow, page mask
  60% black (40% white in light); content padded 2em and centered; a 32px round close
  button hanging off the top end corner that turns red on hover.
- **Links**: blue, no underline; hover a lighter, more saturated blue.
- **Scrollbars**: 0.5rem, thumb in the shade grey on the box background.

## Charts

Lichess draws charts with Chart.js (lila `ui/chart`). Reuse `example/assets/charts.js`;
its values come from that source:

- Font Noto Sans 12px. Text color hsl(0 0% 73%) dark, #2F2F2F light. Grid lines
  #404040 dark, #ccc light; a zero line #676664 dark, #959595 light. No vertical grid
  lines; the value axis sits on the right (left in RTL) with no axis border, up to
  7 ticks, 10px padding.
- Lines 1.5px, straight (no curve), no points at rest; on hover a 6px point with a
  2px light ring. Animation off.
- Series colors in this order (Lichess's own, the Okabe-Ito set): #56B4E9 blue,
  #E69F00 orange, #009E73 green, #D55E00 red-orange. Up to 4 series per chart. Each
  series also gets its own dash pattern and point shape (solid circle, short dash
  diamond, long dash square, dotted triangle), as Lichess does, so lines are told
  apart without color.
- Single-series area: fill gradient rgb(119 152 191) from 100% to 30% opacity, line
  #7798bf, 4px points.
- Tooltip: background rgb(22 21 18 / 0.85) dark or rgb(255 255 255 / 0.85) light, 1px
  grid-colored border, 6px padding, 8px point-style swatch, "Label: value" lines.
- Legend on top, start-aligned, point-style swatches.
- Period buttons above the chart: `.time-selector-buttons` (joined metal buttons,
  uppercase, the chosen one sunk to #262421 dark or #dbebfc light).
- Every chart has a one-line takeaway under it and a "Show the numbers" table.
  In light mode the blue and orange have under 3:1 contrast on white, so the table
  and labels are required, not optional.
- Watch for JavaScript globals: never name a top-level variable `top`, `name`,
  `status` or reuse a function name from a shared script. Wrap shared scripts in an
  IIFE (as charts.js does), or the whole page script dies silently.

## Building a page in this style

1. Copy `lichess-style.css` into the project and load the three Google Fonts (see
   the example's `<head>`). Set `dir="rtl"` and `lang="ar"` for Arabic.
2. Structure: `header#top` > (`.site-title-nav` > `.site-title` + `nav#topnav`) and
   `.site-buttons`; then `#main-wrap > main`. Use `main.page-menu` with an
   `aside.subnav` when the page has sections.
3. Put content in `.box` blocks with a `.box__top` title row; stack boxes with the
   block gap. Lists of records are `.slist` tables inside a box, with `.pagination`
   under them.
4. Primary action blue `.button`, secondary `.button-metal`, row actions
   `.button-empty .button-thin`, save `.button-green`, delete `.button-red` or
   `.button-empty.button-red`.
5. Offer the light theme with a header icon button that toggles `html.light`.
6. Check against `example/index.html` side by side: background gradient at the top,
   warm greys, light Roboto headings, uppercase nav, metal table head, zebra rows.

## In a Vuetify or other component-library app

Use the library's components but theme them to these tokens: map `primary` to the
blue, `secondary`/`success` to the green, `error` to the red, surface to `--c-bg`,
background to `--c-bg-page`; set `rounded` to 7px (not pill); set the fonts; make
table headers use the metal gradient and rows zebra; buttons uppercase Roboto 500.
Keep the library's behavior; change only the look.
