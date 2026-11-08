# UI/UX Repair Notes: Viewport Responsiveness & Layout Hardening

## Overview
During multi-device testing and desktop resizing, several layout overflow issues were identified on narrow viewports (<1000px width) and dialog surfaces. This document outlines the root causes identified during the audit and the defensive architectural solutions applied.

## Identified Culprits & Fixes

### 1. Dashboard Metrics Overflow
- **Culprit**: The 4 summary cards (`Total Sales`, `Cash In Hand`, `Low Stock Items`, `Cloud Sync Status`) were rendered inside an unbounded horizontal `Row` with `Expanded`. On viewports narrower than 1100px, text and badges overflowed the container boundaries.
- **Fix**: Replaced the rigid `Row` layout with a responsive multi-breakpoint column layout:
  - Screens ≥ 1100px: 4 columns
  - Screens 700px – 1099px: 2 columns
  - Screens < 700px: 1 column
- **Component**: Replaced direct `Card` widgets with the new `ResponsiveCard` (`lib/shared/widgets/responsive_card.dart`), enforcing minimum content height and intrinsic proportion matching.

### 2. POS Billing Modal Dialogs
- **Culprit**: Dialogs such as the Item Search/Add modal and customer checkout used hardcoded container widths (`width: 520`) or unconstrained `Column` widgets inside unbounded dialog contexts, causing `RenderFlex overflowed by X pixels`.
- **Fix**: Wrapped all dialog contents in `ConstrainedBox(constraints: BoxConstraints(maxWidth: 480))` with `SingleChildScrollView` and `mainAxisSize: MainAxisSize.min`.

### 3. Navigation Header & Action Buttons Wrap
- **Culprit**: Dashboard header buttons (`Seed Sample Products`, `Sync Now`, `Backup Now`) were in a single horizontal `Row`, causing `RenderFlex overflowed by 387 pixels on the right` on laptop and tablet resolutions.
- **Fix**: Switched the header action cluster to a responsive `Wrap(spacing: 8, runSpacing: 8)` layout, allowing buttons to gracefully cascade into secondary rows without viewport overflow.

### 4. POS Item Grid Ratio
- **Culprit**: `GridView` with fixed `childAspectRatio` caused multi-line Nepali item names and prices to collide with unit badges.
- **Fix**: Increased grid card aspect ratio and used `TextOverflow.ellipsis` with `maxLines: 2` on Devanagari labels.

## Verification
Multi-viewport automated widget tests verify rendering without assertion errors at:
- 1280 x 720 (Desktop Standard)
- 900 x 600 (Compact Desktop / Laptop)
- 600 x 800 (Tablet Portrait)
- 400 x 800 (Mobile / Split Screen)

