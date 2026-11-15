# My own rules

These are my rules for the design-without-ai-look skill, kept apart from the
author's original text so I can read and edit them in one place. They are
always on, in light mode and full mode, and they override the skill's defaults
when the two disagree.

## Never do

**Live dots and status circles.** The small colored circle (red, green or orange, often pulsing or glowing) placed next to a clock, a "live" or "online" label, a breaking news line, a status, a menu item or a card title. This includes the red dot next to a live time display, the pulsing "LIVE" badge, green "online" dots and colored bullet dots used as decoration. Alternative: let the content itself show that it is live or current (the time ticking, a fresh timestamp such as "قبل دقيقتين", the word "مباشر" set in the headline type, a change in color or weight of the text itself, or an element from the concept's universe). Only use a dot when it is the established, functional convention of the interface (for example an unread indicator a user actually acts on), and never as decoration. Why: it is one of the most repeated tics of generated dashboards and news sites, and it adds urgency the content has not earned.

**Long dashes, anywhere.** No em dash (—) or en dash (–) in any text a person will see: page and dialog titles, labels, buttons, menus, tooltips, messages, copy, release notes, Arabic or English. This includes the title pattern "Action — Context" (for example «تعديل الرموز — فئة الطبيب»). Alternatives: a colon («تعديل الرموز: فئة الطبيب»), a comma, a period, or the context on its own line in a smaller or lighter style. For a range use "to" or «إلى» («من ١ إلى ٥»), or a plain hyphen only in numeric ranges like 10-20. Why: long dashes are one of the most recognizable habits of generated text.

**Dots as separators.** No middle dot (·), bullet (•) or similar dot between items in a line ("5 events · last 24h", «زيارة • ٢٥$», "Admin · 3 users"). Alternatives: a comma, a line break, real space between the items (a gap in the layout), a thin vertical line drawn in CSS, or different weight or color for each part. Why: it is the stock separator of generated metadata lines.

**Tonal is allowed.** Vuetify's `variant="tonal"` (and Material's tonal style) is fine, and for buttons a neutral grey tonal (tonal with no color) is the preferred default. Give a tonal element a color only when the color has a job (a delete or warning action); do not tint statuses, labels or decorations in pale green, blue or similar just to make them look lively.

**Rounded and pill shapes.** No pills, fully rounded buttons or chips, or big soft corners. Prefer square or the library's default small radius. Never `rounded="pill"`, `rounded="xl"`, `border-radius: 999px` or a radius bigger than the library default.

**Restyling the component library.** When the project uses Vuetify, Material UI or another component library, use its components with their default look: default variant (neutral grey tonal for buttons), default density, default radius, default elevation. Do not add custom CSS to restyle them, custom shadows, gradients or decorative wrappers. Only set what the task needs (color, size, disabled). If the project already restyled components, leave its existing styling alone unless asked, and do not add more.

All of these apply in light mode and full mode, in new text and in any text you touch.

## What makes it feel designed by a person

These principles sit above the habit list. When a habit and a principle seem to conflict, follow the principle and say why.

- **Small, intentional imperfections.** One element that breaks the grid on purpose (an image that bleeds off the edge, a headline that overlaps a photo, a hand drawn underline, a slightly rotated sticker of real content). One or two per page, each with a reason. Never random jitter, and never imperfection that looks like a bug.
- **Meaning and flow over strict alignment.** Align things that belong together, and let things that are different sit differently. A quote can hang outside the text column, a price can sit close to what it prices. Perfect alignment of everything to one grid reads as generated.
- **Clear visual judgments, not uniform layouts.** Decide what matters most and make it much bigger, much bolder or much emptier around it. Give unequal space to unequal content: one large item and two small ones, not three equal ones. If every block has the same weight, nothing was decided.
- **Typography with personality.** Chosen for this concept, as Step 1 says, and then used with intent: real contrast in size and weight, a considered line length, one typographic moment per page that only this concept would have.
- **Copy the way people actually speak.** Short, direct, specific. Buttons say what happens ("احجز طاولة", "Send the file"), not "Get started" or "Learn more". Errors and empty states say what went wrong and what to do, in a human voice.
- **Small pauses and feedback in interactions.** Hover, press, loading and success states for everything that can be touched. Short, purposeful timing (about 120 to 250 ms), easing that feels physical, a brief confirmation after an action. Respect `prefers-reduced-motion`. No entrance animation on every block.
- **Design for real, messy content early.** Test with the longest name, a two line title, a missing photo, one item and fifty items, a very long Arabic word next to a Latin one, a price with many digits. The layout must survive the worst real case, not just the demo.
- **Personality sparingly and with intent.** One or two brand moments (the brand element of Step 1, a line of copy with a wink, an illustration in an empty state). Everywhere else stays quiet so those moments land.
- **Clarity and calm over polish.** Fewer colors, fewer sizes, fewer effects, more space. A calm page that is easy to use beats a busy page full of details. When in doubt, remove something.

## Arabic and right-to-left

When the piece is in Arabic (or any right-to-left language), design right-to-left from the start, not a left-to-right layout flipped at the end.

- The reading order starts at the right: the dominant element, the anchor of an off center layout and the first thing read sit where an Arabic reader looks first. Do not just mirror a Latin composition: decide the composition for right-to-left reading.
- In code: `dir="rtl"` and `lang="ar"` on the root, and logical CSS properties (`margin-inline-start`, `padding-inline-end`, `inset-inline-start`, `text-align: start`) instead of left and right. Mixed Arabic and Latin runs (names, URLs, prices) are isolated with `<bdi>` or `unicode-bidi: isolate` so they do not jump around.
- Mirror what has direction (arrows, progress, chevrons, a timeline, a carousel order) and do not mirror what does not (logos, media play icons, clocks, charts with numeric axes, phone numbers).
- Arabic punctuation: ، ؛ ؟ and Arabic quotation marks « ». Choose Western digits (123) or Arabic-Indic digits (١٢٣) once for the project and use them consistently.
- Arabic needs more line height than Latin (often 1.6 to 1.9 for body text) and does not use letter spacing or fake uppercase. Never add `letter-spacing` to Arabic: it breaks the joining. The "tiny uppercase label" habit has no Arabic form, so do not invent one with small bold text and tracking.
- Copy in a real Arabic voice, not translated marketing English. Use the register the audience actually reads (Modern Standard Arabic or the local dialect, as the brief says).
- In the final review, render with real Arabic text and check: joining is intact, diacritics do not clip at line edges, nothing is left aligned by mistake, mixed runs read in the right order.
