# Neuwaita icon guidelines

How to draw new icons that look like the ones already in the theme, for both Neuwaita (light) and Neuwaita-Dark. Everything here is derived from the existing icons: when in doubt, open a similar icon and copy its structure.

## The style in one sentence
A **flat shape with a light rim on top and an 8px darker "extrusion" below**, like a thick button seen slightly from above, with the app logo sitting on it as a flat graphic with a soft shadow.

Every app icon is built from three layers, from bottom to top:
1. **Depth**: the same silhouette moved 8px down, in a darker shade, with subtle highlight stripes.
2. **Rim**: the silhouette itself, filled with a vertical gradient that is lightest at the top.
3. **Face**: the silhouette inset by about 2px, in the main color.

Then the **logo** goes on the face, with its own small shadow.

## Files and canvas
- SVG only, **`viewBox="0 0 128 128"`** with `width="128" height="128"` for apps, file types and folders. Tray/status icons use **32×32**.
- Draw in Inkscape (all existing icons are Inkscape files) or write the SVG by hand.
- Everything must be vector: **no embedded PNG/JPEG** (`<image>`), and **no live text**. Convert text to paths (Inkscape: *Path → Object to Path*), otherwise the icon depends on the fonts installed on each system.
- Remove leftovers that point to someone's computer (`inkscape:export-filename`, absolute paths).
- Keep files reasonably small: the median app icon is about 22 KB. Avoid huge traced paths or heavy filters.

## Choosing the base shape
Pick the base that matches the original logo:

| Original logo | Base | Examples |
|---|---|---|
| Round logo or round badge | **Disc** | Discord, Spotify, Telegram, Kate, OBS |
| Square/rounded-square logo, or a glyph with no shape of its own | **Tile** | VS Code, Zed, JetBrains IDEs, Signal, Brave Origin, terminals |
| Strong silhouette that *is* the logo (shield, gear, flame, object) | **Free-form** | Brave, Firefox, Settings, LibreOffice, VLC, GNOME apps |

About 45% of the app icons are tiles, 20% discs and 35% free-form.

## Tile
Exact geometry (all standard tiles use it; the element ids come from the original template and are used by the dark-variant scripts):

```xml
<!-- depth -->
<rect id="rect440" x="11.5" y="15.5" width="105" height="105" rx="13" ry="13" fill="url(#depth)"/>
<!-- rim -->
<rect id="rect358" x="11.5" y="7.5"  width="105" height="105" rx="13" ry="13" fill="url(#rim)"/>
<!-- face -->
<rect id="rect338" x="13.622333" y="9.6223326" width="100.75533" height="100.75533" rx="12" ry="12" fill="..."/>
```

Gradients:
```xml
<!-- rim: stop 0 at the bottom, stop 1 (lightest) at the top -->
<linearGradient id="rim" x1="64" y1="112.5" x2="64" y2="7.5" gradientUnits="userSpaceOnUse">
  <stop offset="0" stop-color="RIM_BOTTOM"/>
  <stop offset="1" stop-color="RIM_TOP"/>
</linearGradient>
<!-- depth: horizontal, with a lighter stripe near each rounded side -->
<linearGradient id="depth" x1="11.5" y1="0" x2="116.5" y2="0" gradientUnits="userSpaceOnUse">
  <stop offset="0"    stop-color="DEPTH"/>
  <stop offset="0.05" stop-color="DEPTH_LIGHT"/>
  <stop offset="0.1"  stop-color="DEPTH"/>
  <stop offset="0.9"  stop-color="DEPTH"/>
  <stop offset="0.95" stop-color="DEPTH_LIGHT"/>
  <stop offset="1"    stop-color="DEPTH"/>
</linearGradient>
```

The logo is centered on the face (center ≈ 64, 60) and usually fills **55–70%** of the face.

## Disc
```xml
<!-- depth: a capsule, the circle extended 8px down -->
<path id="circle1035" fill="url(#discDepth)"
      d="M 64 5 A 55 55 0 0 0 9 60 L 9 68 A 55 55 0 0 0 64 123 A 55 55 0 0 0 119 68 L 119 60 A 55 55 0 0 0 64 5 z"/>
<!-- rim -->
<circle id="path953" cx="64" cy="60" r="55" fill="url(#discRim)"/>
<!-- face -->
<circle id="circle417" cx="64" cy="60" r="52.613155" fill="..."/>
```

- **Rim gradient** goes from top (y=5, lightest) to bottom (y=115).
- **Depth gradient** is horizontal (x 9 → 119) and lighter **in the middle**, like a cylinder: `DEPTH` at 0, 0.3, 0.7 and 1, `DEPTH_LIGHT` at 0.5.

## Free-form
- Use the logo's own silhouette as the face, with a lighter rim/bevel along the top edge and a darker copy of the silhouette moved **≈8px down** as depth (Brave: depth `#b92808`, bevel `#ff7f60`, face orange; Settings gear: face `#ffffff`, rim `#e6e6e6`, depth `#b3b3b3`/`#666666`).
- Keep the whole icon inside roughly x 9–119 and y 1–123, like the tiles and discs, so it doesn't look bigger or smaller than its neighbours.
- Objects (calculator, calendar, documents, boxes) follow the same idea: flat front, light top edge, darker thickness below.

## Color recipe
Start from the brand color of the original logo and derive the others from it:

| Part | How to get it | Signal | Discord (disc) | Spotify (disc) |
|---|---|---|---|---|
| Face | brand color | `#5186f2` | `#5865f2` | `#00df6d` |
| Rim bottom | face, a bit lighter | `#8aadf6` | `#7680f2` | `#00f376` |
| Rim top | face, almost white | `#dbe5fc` | `#c8ccfa` | `#e2feef` |
| Depth | face, darker and more saturated | `#1257dd` | `#2a38d1` | `#00923c` |
| Depth light | depth, a bit lighter | `#2a6ef0` | `#424ff0` | `#00ba5a` |

Neutral bases used by many icons:

| Base | Face | Rim (bottom → top) | Depth / depth light |
|---|---|---|---|
| Light tile (VS Code, Proton VPN) | `#e6e6e6` or `#f4f4f4` | `#f1f1f1` → `#ffffff` | `#999999` / `#b3b3b3` |
| Dark tile (Zed, Brave Origin, all Neuwaita-Dark tiles) | gradient `#0c0c0c` (top) → `#2b2b2b` (bottom) | `#888888` → `#e6e6e6` | `#636363` / `#727272` |
| White disc (ChatGPT, Slack, Filen) | `#e6e6e6` | `#ededed` → `#ffffff` | — |

Other rules:
- Faces are **flat colors or very soft two-stop gradients**. No glossy highlights, no textures.
- A white logo on a colored face is usually a **light tint of the brand color** rather than pure white (Discord: `#e0e3ff` with `#ffffff` highlights and `#bcc2ff` shadows).
- Keep the original brand colors of the logo itself; adapt only the base.

## The logo on top
- Simplify the logo: flat shapes, at most a few tones. It must still read at 32 and 48 px; check it.
- Give it a soft shadow with Inkscape's **Filters → Shadows and Glows → Drop Shadow**. Typical values in the theme: blur **1.5–2**, vertical offset **≈3px down**, black at **25–35%** opacity. On a colored face the shadow may be a dark shade of the face color (Discord uses `rgb(16,22,102)` at 30%).
- Alternative for line/outline logos: a hard copy of the logo moved **2px down** in a mid grey (`#77767b`), like Brave Origin.
- Glyph-only logos (e.g. the JetBrains black squares, terminal prompts) sit directly on the face, with the same shadow.

## File types (`scalable/mimetypes/`)
- **Page**: x 24 → 104 (80px wide), y ≈ 11.5 → 115.5, corner radius 6, with the **top-right corner folded** (the fold is about 23px: from x 81 to 104 and down to y 41.5).
  - Page body: rim gradient plus a face of `#ececec`; a 1px darker copy `#999999` underneath as depth.
  - Fold: `#dedede`, with a `#787878` shadow behind it.
  - Generic text lines: rounded rects `#cccccc`, height ≈2.5, radius ≈1.24, starting at x ≈33.7, 7.4px apart.
- **Branded documents** (Photoshop, Illustrator, PHP, Python…) use the same page shape filled with the brand color and the logo or short label in the middle, converted to paths.
- **Packages and archives** (rpm, deb, jar, apk…) are the **brown cardboard box**: light brown `#eedcc9`/`#dec0a4`, darker `#aa7d51`, with the tape strip on top and the format logo on the front.
- Symbols on a page are small (about 30–40px) and centered slightly below the middle.
- Most file types are **symlinks** to a few base icons. Add a new drawing only if the type needs its own look.

## Folders (`scalable/places/`)
Folders share the same layers (the plain `folder.svg` has only the back and the front):
1. **Back with the tab** (`path6`): the folder's dark color, x 12 → 116, y 12 → 118, radius 10.
2. **Depth strip** (`path7`): the same shape as the front moved 4px down, in a darker shade.
3. **Front** (`path8`): the folder's light color, starting at y = 32 with the curved tab cut.
4. **Emblem** (`path9`): a simple symbol (≈24–30px) centered around (64, 80), in the dark color.

Colors come in pairs: see [Palette.txt](Palette.txt) (`blue` = front `#c2d9ff`, `blue-dark` = back and emblem `#5187d8`). Folders for specific apps may use the app's brand colors (Obsidian purple, Telegram blue).

`scalable/places/folder.svg` is rewritten by `change-color.sh`: **its line 59 must hold the dark color and line 64 the light one**. Don't reformat that file.

## Tray and status icons (`scalable/status/`)
- **32×32** canvas. They are drawn in the panel at 16–24 px, so keep shapes bold.
- Colored, not monochrome: the logo with a **1.5px darker copy below** as depth, and a state **badge** in the top-right corner (circle r ≈ 7.9) with its own 1.5px depth and a white glyph (stroke width 2, round caps):
  - connected: `#2ec27e`, depth `#1b8553`, ✓
  - error: `#ed333b`, depth `#a51d2d`, ✕
  - disconnected/idle: the logo in greys, no badge.
- The GNOME top bar is dark in both variants, so tray icons have **no dark version**.
- A tray icon can be themed only if the app asks for it by name. Apps that load PNG files from their own folder (e.g. Electron apps like Filen) cannot be themed.

## Dark variant (`dark/`)
Neuwaita-Dark inherits everything from Neuwaita; `dark/` only holds the icons that change.

**Make a dark version when** the icon has a light base (light tile, white disc, white page) or a brand-colored base that would look too bright on a dark desktop. **Don't** make one for icons that are already dark (Brave Origin, Zed, terminals), for tray icons, or for icons that are just a colored shape (Brave, Kate) unless they really look wrong.

How to convert:
1. Copy the light icon and keep the logo identical.
2. Replace the base with the **dark tile colors**: face `#0c0c0c` → `#2b2b2b` (top to bottom), rim `#888888` (bottom) → `#e6e6e6` (top), depth `#636363` with `#727272` stripes. Discs use the same colors on the disc layers.
3. Make the logo shadow **black** (it was grey or a tint of the face).
4. If the logo was white or a pale tint on a colored base, paint it in the **brand color** instead (Discord: lavender Clyde → blurple `#5865f2` Clyde, highlights `#8891f7`, shadows `#4752c4`). This matches how iOS dark icons look: dark background, logo in its brand color.
5. Save it in `dark/scalable/<same folder>/` with **the same file name**, and recreate there **every symlink** the light icon has (`find scalable -lname '<name>.svg'`), otherwise those names keep showing the light icon.
6. Every icon in `dark/` must also exist in the main theme.

If the light icon uses the standard element ids (`stop400`/`stop402` rim, `stop8237`… depth, `rect338` face for tiles; `stop1035`/`stop1037`, `stop2238`…, `circle417` for discs), the conversion is a matter of recoloring those elements.

## Naming
- Name the file after the `Icon=` value the app uses, preferably the reverse domain name (`com.discordapp.Discord.svg`). Find it with `grep "^Icon=" <app>.desktop`.
- Every other name the app uses (older names, distro packages, Flatpak vs RPM) is a **relative symlink** to the main file, in the same folder: `ln -s com.brave.Origin.svg brave-origin.svg`.
- Alternative designs that are not the default go in `Extras/`.

## Checklist before committing
- [ ] `viewBox` is `0 0 128 128` (or `0 0 32 32` for status icons) and the icon lines up with similar icons (same tile/disc geometry).
- [ ] No `<image>`, no live `<text>`, no export paths; `xmllint --noout file.svg` passes.
- [ ] Looks right at 128, 48 and 32 px, on both light and dark backgrounds:
  `magick -background none -density 200 icon.svg -resize 48x48 preview.png`
- [ ] Symlinks are relative and none is broken: `find scalable dark -xtype l` prints nothing.
- [ ] Dark version (if any) has the same file name and the same symlinks as the light one.
- [ ] Installed with `./install.sh --dark`, checked after logging out and back in, in both Neuwaita and Neuwaita-Dark.
