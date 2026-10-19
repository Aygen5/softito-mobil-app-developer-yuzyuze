---
name: Sessiz Defter
colors:
  surface: '#fef8f6'
  surface-dim: '#ded9d7'
  surface-bright: '#fef8f6'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f8f2f0'
  surface-container: '#f2edeb'
  surface-container-high: '#ede7e5'
  surface-container-highest: '#e7e1df'
  on-surface: '#1d1b1a'
  on-surface-variant: '#434842'
  inverse-surface: '#32302f'
  inverse-on-surface: '#f5efed'
  outline: '#747872'
  outline-variant: '#c3c8c0'
  surface-tint: '#516351'
  primary: '#485949'
  on-primary: '#ffffff'
  primary-container: '#607260'
  on-primary-container: '#e2f6e0'
  inverse-primary: '#b8ccb7'
  secondary: '#516352'
  on-secondary: '#ffffff'
  secondary-container: '#d1e5cf'
  on-secondary-container: '#556756'
  tertiary: '#6a4d54'
  on-tertiary: '#ffffff'
  tertiary-container: '#84656c'
  on-tertiary-container: '#ffecee'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d4e8d2'
  primary-fixed-dim: '#b8ccb7'
  on-primary-fixed: '#0f1f12'
  on-primary-fixed-variant: '#3a4b3b'
  secondary-fixed: '#d4e8d2'
  secondary-fixed-dim: '#b8ccb7'
  on-secondary-fixed: '#0f1f12'
  on-secondary-fixed-variant: '#3a4b3b'
  tertiary-fixed: '#ffd9e1'
  tertiary-fixed-dim: '#e3bdc5'
  on-tertiary-fixed: '#2b151b'
  on-tertiary-fixed-variant: '#5b3f46'
  background: '#fef8f6'
  on-background: '#1d1b1a'
  surface-variant: '#e7e1df'
typography:
  display:
    fontFamily: Playfair Display
    fontSize: 36px
    fontWeight: '600'
    lineHeight: 44px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Playfair Display
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Playfair Display
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 30px
    letterSpacing: 0em
  headline-sm:
    fontFamily: Playfair Display
    fontSize: 18px
    fontWeight: '500'
    lineHeight: 26px
    letterSpacing: 0em
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 17px
    fontWeight: '400'
    lineHeight: 28px
    letterSpacing: -0.01em
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0em
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
    letterSpacing: 0.04em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1.25rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2.25rem
---

## Brand & Style

The design system translates the intimate, sensory experience of a fine linen-bound paper diary into an uncluttered mobile space. It serves thoughtful individuals seeking an emotional sanctuary for daily reflection, mindfulness, and memory preservation. 

The aesthetic is grounded in a Tactile Editorial Minimalist style:
- Generous margins and deliberate pauses between thoughts, mirroring the margins of hand-pressed stationery.
- Rejection of loud digital metaphors, hyper-saturated accents, gamified badges, or plastic glassmorphism.
- Understated tactile qualities conveyed through hairline rules, unhurried typography, and organic parchment hues.
- Evokes quietude, security, focus, and timeless craftsmanship.

## Colors

The palette balances warm cream fiber bases with grounding sage botanicals and natural charcoal pigments:

- **Canvas & Surfaces:**
  - Base canvas: `#FAF8F5` (Alabaster Cream)
  - Secondary canvas / Inset blocks: `#F5F1EB` (Parchment Mist)
  - Tertiary canvas / Grouped containers: `#EFEAE1` (Pressed Fiber)
  - Card & sheet surface: `#FFFFFF` tinted subtly by surrounding cream ambient light.

- **Primary & Tonal Accents:**
  - Primary (`#607260`, Muted Sage): Key interactive triggers, active date indicators, and focal states.
  - Deep Sage (`#4A5A4A`): High-contrast text links, primary button presses, and active navigation icons.
  - Soft Sage (`#7A8D7A`): Secondary tags, streak dots, and muted progress strokes.

- **Typographic Neutral Hierarchy:**
  - Primary text (`#2C2A29`): Warm charcoal for primary headings and long-form journal entries.
  - Secondary text (`#4A4644`): Body descriptors, dates, and metadata labels.
  - Muted text (`#736E69`): Timestamps, inactive states, and placeholder hints.

- **Structural Outlines:**
  - Delicate boundary border (`#E6E0D6`): Micro hairline borders that distinguish cards and lists without visual noise.

## Typography

The typographic system relies on deliberate friction between the literary authority of `Playfair Display` and the quiet, geometric legibility of `Plus Jakarta Sans`.

- Turkish character sets (ç, ğ, ı, İ, ö, ş, ü) must render natively across all weights without glyph substitution.
- Long-form reflection entries require generous line-height (`body-lg` at 28px on a 17px base) to emulate the rhythm of book typesetting and prevent eye fatigue.
- Display and headline levels leverage italic styles sparingly for emotional subheadings, quotes, or meditative prompts.
- All functional metadata (word counts, timestamps, mood indicators) are kept cleanly grounded in `Plus Jakarta Sans` medium weights to preserve functional hierarchy.

## Layout & Spacing

The layout is built on a mobile-first, single-column reading column with a strict 4px/8px vertical rhythm.

- **Screen Margins:** Fixed at 20px (`1.25rem`) on compact mobile frames to preserve edge comfort while maximizing screen estate.
- **Reading View:** When in journal writing or reading modes, horizontal gutters expand inward to maintain a maximum text line length of roughly 60–65 characters.
- **Component Breathing Room:** Components prioritize spacious interior vertical padding (`space-lg` and `space-xl`) over tight grouping, establishing an open, relaxing atmosphere.

## Elevation & Depth

Visual planes do not depend on dramatic drop shadows. Instead, hierarchy is conveyed through tonal layering combined with featherweight ambient diffusion:

- **Level 0 (App Canvas):** `#FAF8F5`. The baseline textured ground.
- **Level 1 (Entry Cards & Grouped Modules):** `#FFFFFF` surface sitting directly on `#FAF8F5`, delineated with a 1px solid border in `#E6E0D6`. Shadow is extremely soft: `0 2px 12px -2px rgba(44, 42, 41, 0.04)`.
- **Level 2 (Active Modals & Bottom Sheets):** `#FFFFFF` surface elevated above the canvas using a delicate dual-tone ambient veil: `0 8px 24px -4px rgba(44, 42, 41, 0.06), 0 2px 6px 0 rgba(44, 42, 41, 0.02)`.
- **Hairlines:** Thin 0.5px to 1px strokes in `#E6E0D6` divide chronological timelines and metadata blocks, avoiding heavy block dividing bars.

## Shapes

Corner radiuses mimic the subtle curve of high-grade paper bound volumes:

- **Containers & Sheets:** Standard entry cards, modal sheets, and dialogue panels utilize `rounded-2xl` (16px / `1rem` to 24px / `1.5rem`) for a soft, unhurried posture.
- **Interactive Controls:** Buttons, input shells, and mood chips use `rounded-xl` (12px to 16px) or full continuous organic pills where focused action is needed.
- **Tag Elements & Mini Indicators:** Mood pills and search filters employ soft rounded geometries that never drop below 8px corner curves.

## Components

### Buttons
- **Primary Action (e.g., 'Kaydet', 'Giriş Yaz'):** Background `#607260`, text `#FFFFFF`, 14px padding vertical, 20px horizontal, `rounded-xl`. Active state shifts to `#4A5A4A`.
- **Secondary / Ghost (e.g., 'Taslak', 'Vazgeç'):** Background transparent, border 1px solid `#E6E0D6`, text `#4A4644`. Hover/Pressed state yields a background of `#F5F1EB`.

### Cards (Journal Entries)
- White surface (`#FFFFFF`) framed by a 1px `#E6E0D6` border, `rounded-2xl`, internal padding of 20px (`1.25rem`).
- Header includes entry date in `label-sm` (`#736E69`) and mood glyph/dot in `#7A8D7A`.
- Entry preview rendered in `headline-sm` title followed by two lines of `body-md` in `#4A4644` with a subtle fade-out.

### Input Fields & Writing Canvas
- **Full-Screen Editor:** No rigid input box borders. A continuous paper canvas (`#FAF8F5` or `#FFFFFF`) with a subtle floating toolbar.
- **Form Inputs:** Background `#F5F1EB`, border 1px solid transparent, focus border 1px solid `#607260`, text `#2C2A29`, placeholder `#736E69`, `rounded-xl`.

### Chips & Filters
- **Mood & Tag Selectors:** Background `#F5F1EB`, text `#4A4644`, `rounded-full`, 8px vertical by 14px horizontal. Selected state transitions to background `#607260`, text `#FFFFFF`.

### Checkboxes & Mood Selectors
- **Prompt Checkboxes:** Soft square `rounded-md` (6px), 1.5px border `#7A8D7A`. When checked, fills with `#607260` with a fine cream checkmark icon.
- **Calendar & Timeline Indicators:** Small 6px circular nodes in `#7A8D7A` or `#607260` connected by a 1px dashed or solid line in `#E6E0D6`.

### Floating Navigation Bar
- A floating capsule positioned 16px above the home indicator, styled in pure `#FFFFFF` with hairline `#E6E0D6` border, containing minimalistic icon tabs with active states highlighted in `#607260`.