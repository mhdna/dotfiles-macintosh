---
name: "design-without-ai-look"
description: "Use when designing or coding templates, websites and other graphic material (posters, slides, social posts, banners, covers) and the result should have an identity of its own instead of the generic AI look: decisions written before drawing, customizable default habits to avoid, realistic copy and a final review you can run."
---

# Design without the AI look

Use this skill whenever you design any graphic material (a website or template, poster, slide, social post, banner, cover), build a design in a tool (Figma, Canva and so on) or turn a design into code. The goal: give each project a better chance of an identity of its own, one that is not the generator default.

## Step 0: the person's adjustments (they override every rule below)

The list of habits in this skill is a starting point. The person can change it in three ways:

1. **Add** their own things to avoid (a decoration that showed up too often, a shape, a writing habit).
2. **Release** default habits they do not want removed (for example, "pills are fine" or "slashes are fine").
3. **Swap the alternative** suggested for a habit, if they prefer another one.

Look for these adjustments in CLAUDE.md, AGENTS.md or whichever instruction file the tool reads, in the README, the brief or the conversation, in a block like this:

```
## Design without the AI look: adjustments
Also avoid: ...
Release (no need to remove): ...
Preferred alternatives: ...
```

If there are no adjustments, ask once, in the same message as the taste question of Step 1, so the person gets one message and not two: "Do you want to add something you never want to see, or release any of the default habits? And how do you like it to look? Shapes, colors, density, what looks beautiful to you and what looks ugly.". If the person answers only one of the two questions, use the answer that came and keep the default habits for the rest. Write the adjustments into the block above and follow them for the whole project. Restate the rules in force at the start of the work.

## Step 1: identity before layout

Before choosing anything, you need the person's taste in one sentence. It is asked in the Step 0 message above; if the adjustments were found in a file and Step 0 asked nothing, ask it alone, for example: "How do you like it to look? Shapes, colors, density, what looks beautiful to you and what looks ugly." If they have references, use them. If they have none, that one sentence is enough. Design without any of this only if the person says they have no preference. If a brief, a brand or earlier answers already show their taste, use that and do not ask again. Why: in tests, with no taste given the result fell to the average of what "looks like good design", and with one sentence of taste it got much better.

Before the four answers below, write three directions in one or two lines each. If the person gave no references, derive them from the real content of the product (its objects, place, customers, what is actually on the page) and make them differ in at least three of these axes: density, color temperature, the voice of the typography, the language of shape. Each axis must differ by category and in a way anyone would notice (warm or cool, sparse or dense, a serif or a rounded sans, curved or orthogonal), not by degree (a bit warmer, a bit denser). Check every pair of directions: if two of the axes you are counting differ only a little, strengthen those axes or replace the direction. A different description is not enough, the choices themselves must differ. Each direction must be justified by the business, not only by being different from the others: different but incoherent also fails. Pick one and say why; the four answers below are for that direction.

Then answer in writing before designing, for the direction you picked:
1. What is the concept's real universe (objects, materials, places, era, sounds)? Start from what the person would really have at hand, such as an owner's counter or a teacher's piano, not from a design metaphor.
2. What is the skeleton (order and shape of the sections, or of the elements on a single piece)?
3. What is the palette (3 to 5 colors, each with a job) and the typography (chosen as the typography paragraph below says)?
4. What is the brand element? Something made only for this concept, that would make no sense in another.

If the person already has brand colors, fonts or a logo, those are the identity. Use them and build the rest (composition, shapes, tone) around them. Question 3 then becomes: which of the brand's colors and fonts do I use, and for what job?

Example of the written answers, for a flyer for a community choir's autumn concert (no brand yet):

1. Universe: sheet music, breath, wooden church benches, October light.
2. Skeleton: one tall piece. The date and place come first and big, the program is a staggered list, the ticket line sits at the bottom. Not a centered title with a button.
3. Palette: ink brown for text, pumpkin for the date, cream for the paper, moss for small details. One serif for the choir's name (headlines) and one plain sans for the program and the ticket line (text and data).
4. Brand element: a row of singers drawn as simple shapes that grow from left to right like a rising scale. It would make no sense on any other piece.

Typography. Use the families the concept calls for and justify each one by its job (headlines, text, data). Work in this order. First write what the small text has to do (prices, dates, captions, fine print) and where it will be read, because that sets what the family must survive. Then propose three candidate pairs (or single families) tied to the concept's universe, such as a sign painter's hand, a ledger, a hymnal, and say why each fits. Pick one and say why. When you choose a family, check that it has complete ã, ç, é and ô, in the weights you will use. Do not start from the reflex pairs given as examples in the habits below.

## Step 2: decide before drawing

Write these decisions down, with real numbers, before you draw. They are also the checklist for the final review.

| Decision | What to write |
|---|---|
| Dominant element | The one thing each screen or page is about, and what gives it room |
| Type scale | Real sizes for headline, subhead, body and small text (for example 72, 32, 18 and 14), with the headline several times the body |
| Spacing unit | One base unit (for example 8) and the few multiples you will use |
| Three composition moves | Three choices that shape the layout, such as an off center anchor, a deliberate crop or a change of density between sections. Not decoration |

## Habits that give AI work away (each one can be released in Step 0)

The principle comes before the list: if your first idea would fit any business of the same type, discard it and start again from this business.

**Status pills and tags.** Rounded labels such as "NEW", "ON SALE", "LIVE", category tags used as decoration. Alternative: plain text placed well, or an element from the concept's real universe. Do not repeat the same alternative in neighboring sections. A label is only worth it when it carries information the visitor needs at that point. Why: generators add a status label to every block to look busy and current, and a label that carries no news is just noise.

**Numbering.** Page, section or card numbers ("01", "02", "Page 2 of 5"), decorative counters and statistics with no source. Real data that is needed (dates, times, durations, prices) is fine. Why: numbers suggest a process or a ranking the content does not have, and statistics with no source look invented.

**Tiny uppercase label** above a big headline, repeated in every section. Alternative: a headline that stands on its own. Why: it is a stock gesture for adding hierarchy, and repeated in every section it becomes a template stamp.

**Glows and shine**, diffuse colored shadows, generic purple and blue gradients. Alternative: flat color with a clear job. Why: they are the default of image models and gradient presets, so they say "generated" at first glance.

**A grid of three identical cards** with icon, title and sentence. Alternative: a layout built for the content. Why: it fills a row without deciding what matters, so the grid shapes the content instead of the other way around.

**Generic line icons** instead of art made for the concept. Why: they come from the same few icon sets everyone uses, so they say nothing about this concept.

**Vague marketing phrases** ("Elevate your sound", "Crafted with passion") and **lorem ipsum**. Write specific copy, with plausible names, places and dates. Why: a phrase that could describe any product describes none, and placeholder text hides whether the layout works with real words.

**Choosing a font pair by reflex.** The habit is picking the pair without thinking, not the pair itself: no font is forbidden. Alternative: the candidates you proposed in Step 1, tied to the concept. Why: the fonts that appear first in generated work say "default" before anyone reads a word. If the concept justifies one of them by its job (headlines, text, data), use it and say why. Examples of pairs models reach for (a guess for the author to review, and a list that ages like the examples below): Playfair Display with Inter or Lato, Fraunces with Inter, DM Serif Display with DM Sans, Cormorant Garamond with Montserrat, Space Grotesk for everything, Poppins or Montserrat alone for everything, Inter alone.

**Illustrating where the person will put their own photo.** Illustration is brand art; photo spaces stay empty and easy to swap. Why: the person will replace it anyway, and it hides the fact that a photo is still missing.

**The same composition in every section** (centered title, button below, image behind). Alternative: one visual idea per section. Why: repeating one layout makes the page read as a single idea stretched out.

## The author's own pet peeves (on by default, release freely)

These are matters of taste more than signs of AI. They are on by default because the author of this skill dislikes them. Release any of them in Step 0.

**Slashes as separators.** A single slash ("/") or double slash ("//") between words, in menus, labels, dates or credits. Alternative: a space, a middle dot, a line, or an element from the concept. Why: it is a decorative stand-in for a separator, common in generated menus, dates and credits.

**Dashes in the text.** Use a comma, a period or a colon. Why: long dashes are one of the most recognizable habits of generated text.

**Italic serif** as an automatic "elegant touch". Why: it is an automatic way of looking elegant that turns up in a lot of generated work.

## Examples observed in tests (an open list that ages)

Seen in November 2026 with Claude Sonnet 5.5, on the prompt "first screen of a neighborhood bakery". Models change, so read this as a sample of defaults, not as a complete list.

- Without the skill: a cream background with brown and terracotta, a serif headline with one word in another color, a two column hero with the object in a rounded rectangle on the right, a floating card or label, a pair of buttons (one filled, one outlined), a footer strip with three columns.
- With an earlier version of this skill: the same "ticket, stamp or order slip" object in every output (the list of alternatives became the next habit), loose decorative lines, a recolored word in the headline, a button with a hard shadow.
- With a rule that said "change palette, type and structure on purpose": the opposite extreme, a giant name on a flat saturated color, one idea shouting. One output had a cut off headline and another a large empty area, because nobody rendered the result.

## Do

- Each section has its own visual idea tied to the concept, not just a block of text on a background.
- Copy in a real person's voice: specific, short, no cliché.
- WCAG AA contrast at minimum. If there is an approved design or brief and it fails, tell the person and propose a fix instead of changing it alone.
- If there is already an approved layout, respect it: if the code or the review needs a change to it, ask first.

## Code

- Semantic HTML, CSS variables at the top for colors, fonts and sizes.
- When turning an existing design into code, keep fidelity to it: same sections, order, texts, colors and fonts.
- Animation with a purpose tied to the concept, not a generic entrance effect on everything.
- Illustrations and brand elements in SVG, not raster images.

## Other formats

Everything above applies to every format: poster, slide, social post, banner, cover and site template. Identity, realistic copy and the final review do not change. Where a rule was written for sites, this is how it reads in other formats:

| On a website or template | In other formats |
|---|---|
| Sections and their order | The order and grouping of the elements on the piece: what is read first, second and last, or the slides of a deck in sequence |
| One visual idea per section | One visual idea per page, slide or panel |
| Photo spaces left empty and easy to swap | A clearly marked empty frame or placeholder box, in the size the photo needs |
| Semantic HTML, CSS variables at the top | Named styles, layers and theme colors, so a color or a font changes in one place |
| Brand art in SVG, not raster images | Brand art as vector shapes, not flattened images |
| Menus, footers and cards | Headers, footers, captions, credits and labels |
| Animation with a purpose | Motion only where the format has it (slide transitions, video, animated banner), with a purpose tied to the concept |
| Fidelity to an existing design | If you convert an approved design to another format or tool, keep the same content, order, colors and fonts |

## Final review (before showing)

1. Check the person's adjustments and the habits above, item by item. Look especially for forgotten pills, numbers, slashes and dashes in menus, footers, cards and supporting text.
2. Check the result against your Step 2 decisions: dominant element, type scale, spacing unit, three composition moves.
3. If you can render, render at desktop and phone sizes and run the first six tests below. If you cannot, say that you did not check the visual result. The last test always applies.
4. Report what you found and what you changed.

| Test | What to look for |
|---|---|
| Blur | Blur or squint at the render: does the hierarchy still show? |
| Gray | Remove the color: does the page still hold together? |
| Swap | Put another business's text in: if nothing about the page objects, it is generic |
| Count | Font sizes, colors and repeated components: more than you decided in Step 2? |
| Cut and empty | Text cut by an edge, overlaps, large empty areas |
| Font swap | Replace the display font with the closest reflex pair for the style you chose (for example Poppins 800 for a heavy rounded headline): if the page looks the same or better, the font choice is not doing any work for the concept |
| Logo | Remove the logo: would anyone know which project this is? If not, identity is missing |
