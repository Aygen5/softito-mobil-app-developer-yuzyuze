---
name: Verdant Habit Tracking
colors:
  surface: '#0f150f'
  surface-dim: '#0f150f'
  surface-bright: '#343b34'
  surface-container-lowest: '#0a100a'
  surface-container-low: '#171d17'
  surface-container: '#1b211b'
  surface-container-high: '#252c25'
  surface-container-highest: '#30362f'
  on-surface: '#dee4da'
  on-surface-variant: '#c6c8bb'
  inverse-surface: '#dee4da'
  inverse-on-surface: '#2c322b'
  outline: '#909286'
  outline-variant: '#45483e'
  surface-tint: '#bdcd9c'
  primary: '#bdcd9c'
  on-primary: '#283412'
  primary-container: '#87966a'
  on-primary-container: '#222e0c'
  inverse-primary: '#55633c'
  secondary: '#bccca6'
  on-secondary: '#273419'
  secondary-container: '#404d30'
  on-secondary-container: '#aebe98'
  tertiary: '#9ad594'
  on-tertiary: '#00390b'
  tertiary-container: '#659e62'
  on-tertiary-container: '#003209'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#d9e9b7'
  primary-fixed-dim: '#bdcd9c'
  on-primary-fixed: '#141f02'
  on-primary-fixed-variant: '#3e4b26'
  secondary-fixed: '#d8e8c0'
  secondary-fixed-dim: '#bccca6'
  on-secondary-fixed: '#131f06'
  on-secondary-fixed-variant: '#3d4b2e'
  tertiary-fixed: '#b5f2ae'
  tertiary-fixed-dim: '#9ad594'
  on-tertiary-fixed: '#002204'
  on-tertiary-fixed-variant: '#1a511f'
  background: '#0f150f'
  on-background: '#dee4da'
  surface-variant: '#30362f'
typography:
  display-lg:
    fontFamily: Manrope
    fontSize: 38px
    fontWeight: '700'
    lineHeight: 46px
    letterSpacing: -0.03em
  display-lg-mobile:
    fontFamily: Manrope
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.025em
  headline-lg:
    fontFamily: Manrope
    fontSize: 26px
    fontWeight: '600'
    lineHeight: 34px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Manrope
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.015em
  headline-sm:
    fontFamily: Manrope
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: -0.01em
  body-lg:
    fontFamily: Manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: -0.005em
  body-md:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0em
  body-sm:
    fontFamily: Manrope
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
    letterSpacing: 0em
  label-numeric:
    fontFamily: Space Grotesk
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 22px
    letterSpacing: -0.02em
  label-caps:
    fontFamily: Space Grotesk
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.08em
  caption:
    fontFamily: Manrope
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.01em
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
  space-xl: 2rem
---

## Brand & Style

This design system embodies mindful intentionality, biological vitality, and grounded luxury. Built for a premium mobile-first wellness and habit tracking experience, it bridges natural botanical warmth with sharp, cognitive clarity. The aesthetic moves away from clinical productivity tools, adopting instead an organic, sanctuary-like environment that encourages slow, sustainable personal growth.

### Target Audience & Emotional Intent
- **Audience:** Discerning individuals seeking mindful habit formation, self-mastery, mental space, and restorative daily rituals without toxic gamification.
- **Atmosphere:** Deep forest evening, meditative stillness, intellectual clarity, gentle vitality.
- **Core Aesthetic Style:** Modern organic minimalism layered with tactile depth, subtle botanical cues, soft illumination (glows rather than direct reflections), and editorial balance.

### Design Principles
1. **Biological Growth Over Machine Metrics:** Visual momentum is shown through budding rings, soft-lit organic rings, and quiet green milestones rather than aggressive streaks.
2. **Restful Contrast:** Surfaces nest organically from deep peat (#111711) to mossy canopy layers (#273329), minimizing eye strain while prioritizing scannability.
3. **Restrained Editorial Luxury:** Clean modern typographic structure paired with warm off-white tones and botanical micro-ornaments, offering a publication-grade finish.
4. **Turkish Linguistic Polish:** Typographic line-heights and spacing are tuned explicitly for Turkish diacritics (ç, ğ, ı, İ, ö, ş, ü), ensuring that accents never clip or alter line balance.

## Colors

The palette draws directly from dense temperate undergrowth and filtered canopy light. Surfaces use deep peat green rather than pure carbon or cold slate, yielding a grounding and restorative backdrop for high-frequency daily habit tracking.

### Color Tokens & Semantic Roles

- **Canvas & Surfaces:**
  - `background-base`: `#111711` (Primary background, deep damp soil)
  - `background-subtle`: `#171F18` (Secondary background, navigation rails, input insets)
  - `surface-card`: `#202A21` (Standard resting card container)
  - `surface-elevated`: `#273329` (Active dialogs, floating modales, active cards)
  - `border-subtle`: `rgba(182, 198, 160, 0.15)` (Structural perimeter for cards and dividers)

- **Brand & Tonal Accents:**
  - `primary-khaki`: `#87966A` (Primary interactive targets, standard active states)
  - `accent-sage`: `#B6C6A0` (Secondary highlight, subtle glow envelopes, active icons)
  - `growth-green`: `#8FCA8A` (Habit completion, success checkpoints, positive trend vectors)
  - `lavender-accent`: `#C1A7D9` (Mindfulness, reflection rituals, secondary track category)
  - `amber-progress`: `#D7B66D` (In-progress indicators, halfway states, morning rituals)
  - `terracotta-warning`: `#DFA477` (Breaks in streaks, attention required, evening rituals)

- **Typography & Content:**
  - `text-primary`: `#F2F0E6` (Warm off-white, high readability)
  - `text-secondary`: `#A8B2A3` (Muted sage-tinted neutral for secondary details, timestamps)
  - `text-muted`: `#6F7B6E` (Faint labels, empty-state text, inactive day markers)

### Usage Rules
- Avoid stark `#FFFFFF`; use `#F2F0E6` to maintain soft, organic contrast against `#111711`.
- Gradient overlays must be restrained: `radial-gradient(circle, rgba(143, 202, 138, 0.12) 0%, transparent 70%)` for habit completion highlights.
- Status colors (amber, terracotta, growth green) should never overpower the earthy foundation; apply them to metrics, progress rings, and subtle badges.

## Typography

The typography unites **Manrope** for primary text and headings with **Space Grotesk** for structured data, tracking numbers, and compact status tags. This creates an editorial balance: natural readability alongside technical precision.

### Typographic Hierarchy & Character
- **Headlines & Display (Manrope):** Geometric yet humanist with soft junctions. Provides a calm, confident voice for greetings, habit names, and milestone reflections.
- **Body & Captions (Manrope):** High legibility at small sizes, optimal for habit descriptions, reflective notes, and frequency labels.
- **Data & Numbers (Space Grotesk):** Sharp tabular numerals make completion rates (e.g., `%84`), day streaks (`21 Gün`), and timestamps crisp and immediately legible.

### Turkish Character Set Calibration
- Ensure strict support for Turkish diacritics: `ğ, Ğ, ı, İ, ş, Ş, ç, Ç, ö, Ö, ü, Ü`.
- Avoid CSS uppercase transforms (`text-transform: uppercase`) without locale parameters to preserve `i` -> `İ` and `ı` -> `I` mappings.
- Line heights maintain a minimum of 1.35x font size to prevent tall diacritics (`Â`, `Î`, `İ`) from colliding with upper ascenders.

## Layout & Spacing

Designed primarily for mobile portrait viewports (standard benchmark ~393x852pt for modern iOS/Android Flutter runtimes). The layout is organized around a rhythmically padded single-column fluid card stack with explicit edge buffers.

### Mobile Grid & Spatial Architecture
- **Outer Canvas Margins:** `1.25rem` (20px) horizontal safe gutter keeps cards off the display bezels while maximizing touch surfaces.
- **Card Padding:**
  - Standard Habit Row: `space-md` (16px) vertical, `space-md` (16px) horizontal.
  - Hero Dashboard Insight Card: `space-lg` (24px) all sides.
- **Inter-Item Vertical Gap:** `space-sm` (8px) for tightly grouped recurring lists; `space-md` (16px) between thematic sections.
- **Vertical Safe Areas:** Account for dynamic islands/notches at the top (minimum 48px top padding) and system gesture navigation bars at the bottom (minimum 88px bottom clearance for persistent floating navigation bar).

### Spatial Rhythm Scale
- `space-xs` (4px): Icon-to-text micro gaps, progress dot spacing.
- `space-sm` (8px): Habit item child offsets, metadata row separators.
- `space-md` (16px): Structural inner container padding and row stacking.
- `space-lg` (24px): Section title to content separation, hero card breathing space.
- `space-xl` (32px): Major layout module separation (e.g., calendar strip to daily list).

## Elevation & Depth

This design system avoids harsh drop shadows and plastic skeuomorphism. Depth is achieved via **tonal layering**, **micro-borders**, and **restrained ambient green luminescence**.

### Surface Hierarchy
1. **Level 0 (Canvas Base - `#111711`):** The foundational substrate representing quiet depth.
2. **Level 1 (Subtle Containers - `#171F18`):** Calendar strips, day-selector chips, and text entry fields. Sits flush or recessed.
3. **Level 2 (Standard Surface - `#202A21`):** Habit cards, routine group cards. Outlined by `border-subtle` (`rgba(182, 198, 160, 0.15)`).
4. **Level 3 (Elevated Surface - `#273329`):** Contextual action sheets, completion celebrations, and popovers. Employs an ultra-soft ambient shadow:
   - `box-shadow: 0 12px 32px -4px rgba(0, 0, 0, 0.45), 0 4px 12px -2px rgba(17, 23, 17, 0.35);`

### Luminous Accentuation (The Verdant Glow)
- When a habit is marked complete or a milestone is unlocked, the element radiates a diffused, low-opacity growth aura:
  - `box-shadow: 0 0 24px 0 rgba(143, 202, 138, 0.18);`
- Floating elements (Floating Action Button and Bottom Nav) use a double-ring boundary: 1px inner stroke of `rgba(182, 198, 160, 0.2)` coupled with a deep backdrop blur (`backdrop-filter: blur(16px)`).

## Shapes

Shapes emulate rounded river stones and organic seed pods. Rigid right angles are avoided to preserve the restorative, ergonomic feel of the interface.

### Curvature Taxonomy
- **Base Geometry (`roundedness: 2`):** Standard 16px (`1rem`) border radius on medium input components, standard cards, and list elements.
- **Large Fluid Surfaces (`rounded-2xl` ~ 20px / `rounded-3xl` ~ 24px - 28px):** Primary hero insight cards, calendar view panels, and bottom navigation pill frame.
- **Pill / Circular (`rounded-full`):** Floating Action Button (FAB), progress tracker check triggers, category chips, and day-of-week selection nodes.
- **Icon Enclosures:** Rounded squircle with 12px radius inset within habit cards.

## Components

### 1. Habit Card (`Alışkanlık Kartı`)
- **Structure:** Level 2 card (`#202A21`), 1px border (`rgba(182, 198, 160, 0.15)`), `rounded-2xl` (20px).
- **Layout:** Left squircle icon container with tinted category wash (e.g., Lavender `#C1A7D9` at 15% opacity for mindfulness); middle title in `headline-sm` with subtext in `body-sm` (`#A8B2A3`); right-side circular completion trigger.
- **Completed State:** The card background shifts softly to `#273329`, border transitions to `rgba(143, 202, 138, 0.35)`, and the completion trigger reveals a checkmark with a `growth-green` aura.

### 2. Circular Progress Ring (`Döngüsel İlerleme`)
- **Visuals:** SVG/Canvas ring. Background track in `#171F18` with 4px stroke. Progress arc in `#8FCA8A` with smooth rounded caps.
- **Content:** Center features percentage or count (e.g., "5/7") in `label-numeric` Space Grotesk.

### 3. Floating Action Button (`Yeni Alışkanlık FAB`)
- **Visuals:** Circular 58x58px button resting at bottom-center-right or docked in the navigation bar.
- **Fill:** Subtle diagonal gradient from `#87966A` to `#8FCA8A`.
- **Icon:** Bold off-white plus icon (`#111711` or `#F2F0E6`).
- **Depth:** Luminous drop shadow `0 8px 20px rgba(143, 202, 138, 0.3)`.

### 4. Bottom Navigation Bar (`Alt Gezinti Çubuğu`)
- **Layout:** Floating dock anchored 20px above the screen bottom, margins 20px, height 68px, `rounded-3xl` (28px).
- **Surface:** `#171F18` at 85% opacity with 20px Gaussian blur and subtle top border (`rgba(182, 198, 160, 0.12)`).
- **Items (4 Destinations):**
  1. **Ana Sayfa** (Home / Daily Overview)
  2. **Takvim** (Calendar / Heatmap)
  3. **İstatistikler** (Analytics / Growth)
  4. **Alışkanlıklar** (Habits Library / Routines)
- **Active State:** Icon renders in `#B6C6A0` with a soft glowing dot (3px) beneath. Label in `label-caps` (`#F2F0E6`). Inactive items in `#6F7B6E`.

### 5. Calendar Day Strip (`Haftalık Gün Seçici`)
- **Layout:** 7-column horizontal strip showing abbreviated days (`Pzt`, `Sal`, `Çar`, `Per`, `Cum`, `Cmt`, `Paz`).
- **Node Style:** 44x64px vertical rounded pill (`rounded-xl`).
- **Current / Selected Day:** `#273329` surface, 1px border in `#B6C6A0`, day number in bold off-white, bottom status dot indicating total daily habit completion (`#8FCA8A`).

### 6. Interactive Chips & Filters (`Filtreleme Çipleri`)
- **Visuals:** Height 34px, `rounded-full`, padding 0 14px.
- **Resting:** Background `#171F18`, border `rgba(182, 198, 160, 0.15)`, text `#A8B2A3` (`caption`).
- **Active:** Background `#87966A`, text `#111711` (high contrast) or `#F2F0E6`.
- **Examples:** `Tümü`, `Sabah Rutini`, `Zihin`, `Beden`, `Akşam`.

### 7. Form Fields & Inputs (`Girdi Alanları`)
- **Visuals:** Background `#171F18`, `rounded-xl` (14px), 1px border in `rgba(182, 198, 160, 0.15)`.
- **Text:** Input text in `#F2F0E6`, placeholder in `#6F7B6E`.
- **Focus:** Border transitions smoothly to `#B6C6A0` with a 2px inner glow.