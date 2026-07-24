# Chris Trading App — Full Handoff (Mobile + Backend)

**Date:** 24 Jul 2026  
**From:** Mobile (Flutter)  
**Sources merged:**
1. `App_Screenshots.docx` (UI / product changes)
2. `Bug_Tracker.xlsx` (BUG-001 … BUG-005)
3. Previous backend docs (`BACKEND_TODO`, `backend-handoff`, `BUG_TRACKER_FIXES`)

**Base URL:** `/api/v1`  
**Auth:** Bearer token (unless noted)

This is the **single** handoff doc. Use this only.

---

## A) Executive summary

| Source | Mobile status | Backend status |
|--------|---------------|----------------|
| App Screenshots UI changes | **Done** | Academy + Like/Save + Tracking fields **needed** |
| Bug Tracker frontend bugs | **Done** (001, 002, 005) | BUG-003 push delay **needed**; BUG-004 already resolved |

### Backend must-do checklist

| Priority | Task | Type |
|----------|------|------|
| P0 | Academy categories + videos APIs | NEW |
| P0 | Admin: load YouTube videos by category | NEW |
| P0 | Like toggle API | NEW |
| P0 | Bookmark/Save toggle API | NEW |
| P0 | Add `isLiked`, `isBookmarked` on signal list/detail | UPDATE |
| P0 | BUG-003: Push notifications delay (5+ min) | FIX |
| P1 | Copied-trades nested signal: `stopLoss`, `takeProfit1` | UPDATE |
| P1 | Log trade accept `stopLoss` + `targetPrice` | UPDATE |
| P1 | Copied-trade list return `stopLoss` / Target fields | UPDATE |
| P2 | Confirm copy/track + comments still OK | Confirm |
| — | BUG-004 CSV duplicates | Already Resolved (admin) |

---

## B) App Screenshots — Mobile already done

From client screenshots feedback:

| # | Requirement | Mobile |
|---|-------------|--------|
| 1 | Nav: Home \| Signals \| Tracking \| Academy \| Profile | Done |
| 2 | Copy Trade → **Tracking** | Done |
| 3 | Trade name on top; image optional | Done |
| 4 | Labels: **Entry \| Stop \| Target** | Done |
| 5 | Like + Saved buttons | Done |
| 6 | Reply | Done |
| 7 | Tabs: **Tracking \| Log Trades** | Done |
| 8 | Academy = YouTube by category (admin loads) | UI done; needs backend APIs |
| 9 | `isCopied == true` → button **Tracked** + disabled | Done |

### Field mapping (do NOT rename API keys)

| Mobile label | API field |
|--------------|-----------|
| Entry | `entryPrice` |
| Stop | `stopLoss` |
| Target | `exitPrice` and/or `targetPrice` / `takeProfit1` |
| Tracking button | existing copy endpoint + `isCopied` |

---

## C) Backend APIs required (from screenshots)

### C1) Academy (NEW — high priority)

Mobile already calls:

```http
GET /api/v1/academy/categories
GET /api/v1/academy/videos
GET /api/v1/academy/videos?categoryId={categoryId}
```

#### Categories response

```json
{
  "success": true,
  "data": [
    {
      "_id": "cat_001",
      "name": "Forex",
      "sortOrder": 1,
      "isActive": true
    }
  ]
}
```

#### Videos response

```json
{
  "success": true,
  "data": [
    {
      "_id": "vid_001",
      "title": "Forex Basics for Beginners",
      "description": "Learn the fundamentals of forex trading.",
      "youtubeUrl": "https://www.youtube.com/watch?v=XXXXXXXXXXX",
      "thumbnailUrl": null,
      "categoryId": "cat_001",
      "categoryName": "Forex",
      "durationSeconds": 720,
      "isActive": true,
      "createdAt": "2026-07-20T10:00:00.000Z"
    }
  ]
}
```

Rules:
- Active only
- `youtubeUrl` required
- `thumbnailUrl` optional

#### Admin portal CRUD (must)

```http
POST   /api/v1/admin/academy/categories
PATCH  /api/v1/admin/academy/categories/:id
DELETE /api/v1/admin/academy/categories/:id

POST   /api/v1/admin/academy/videos
PATCH  /api/v1/admin/academy/videos/:id
DELETE /api/v1/admin/academy/videos/:id
```

Admin can: create/edit/deactivate categories + videos, assign category, paste YouTube URL.

---

### C2) Like + Save / Bookmark (NEW)

Mobile already calls (toggle):

```http
POST /api/v1/signals/:signalId/like
POST /api/v1/signals/:signalId/bookmark
```

#### Like response

```json
{
  "success": true,
  "message": "Liked",
  "data": {
    "isLiked": true,
    "likeCount": 12
  }
}
```

#### Bookmark response

```json
{
  "success": true,
  "message": "Saved",
  "data": {
    "isBookmarked": true,
    "bookmarkCount": 4
  }
}
```

#### Update signal list + detail

On `GET /api/v1/signals` and `GET /api/v1/signals/:id` add for current user:

```json
{
  "likeCount": 12,
  "bookmarkCount": 4,
  "commentCount": 3,
  "isLiked": false,
  "isBookmarked": false,
  "isCopied": false
}
```

Rules:
- `isCopied: true` after track/copy → mobile shows **Tracked** (disabled)
- Already copied → `409` / clear message

---

### C3) Tracking / copied trades (UPDATE)

Same endpoints (UI renamed Copy → Tracking):

```http
POST /api/v1/copied-trades/signals/:signalId/copy
GET  /api/v1/copied-trades?page=&limit=&status=&sortBy=newest
POST /api/v1/copied-trades/log
```

#### Nested signal fields (required)

```json
{
  "signalId": {
    "_id": "...",
    "symbol": "BTCUSDT",
    "assetType": "crypto",
    "signalType": "long",
    "entryPrice": 108500,
    "stopLoss": 107200,
    "takeProfit1": 109500,
    "status": "open"
  }
}
```

#### Trade item fields

```json
{
  "_id": "...",
  "entryPrice": 108500,
  "stopLoss": 107200,
  "exitPrice": 109500,
  "targetPrice": 109500,
  "lotSize": 0.1,
  "status": "pending | completed",
  "outcome": "pending | win | loss",
  "signalId": { }
}
```

#### Log body (mobile now sends)

```json
{
  "signalId": "...",
  "entryPrice": 108500,
  "stopLoss": 107200,
  "exitPrice": 109500,
  "targetPrice": 109500,
  "lotSize": 0.1,
  "resultPnl": 120,
  "pnlUnit": "usd",
  "outcome": "win",
  "notes": "...",
  "screenshotUrl": "https://...",
  "externalPlatform": "bybit"
}
```

Backend must:
1. Accept `stopLoss`
2. Accept `targetPrice` (alias of Target; may store as `exitPrice`)
3. Keep `exitPrice` for backward compatibility
4. Persist `stopLoss` for Tracking list

---

### C4) Comments / Reply — no new API

```http
GET  /api/v1/comments?signalId=&page=&limit=
POST /api/v1/comments
```

```json
{ "signalId": "...", "message": "@jay nice setup" }
```

---

### C5) Suggested DB

**academy_categories:** `_id`, `name`, `sortOrder`, `isActive`, timestamps  

**academy_videos:** `_id`, `title`, `description`, `youtubeUrl`, `thumbnailUrl?`, `categoryId`, `durationSeconds?`, `isActive`, timestamps  

**signal_likes:** `signalId`, `userId` — unique `(signalId, userId)`  

**signal_bookmarks:** `signalId`, `userId` — unique `(signalId, userId)`

---

## D) Bug Tracker — status

| Bug ID | Title | Area | Status |
|--------|-------|------|--------|
| BUG-001 | App crashes on launch when offline | Frontend | **Fixed in app** |
| BUG-002 | Login button misaligned on small screens | Frontend | **Fixed in app** |
| BUG-003 | Push notifications delayed 5+ min | Backend | **Backend must finish** |
| BUG-004 | Export to CSV duplicate rows | Backend/Admin | Already Resolved |
| BUG-005 | Dark mode toggle resets on update | Frontend | **Fixed in app** |

### BUG-001 (Fixed — mobile)
- Safe cache init / containsKey / get
- main.dart try/catch around MediaKit, Cache, DI
- Splash safe fallback
- Defensive connectivity + JWT error parsing

### BUG-002 (Fixed — mobile)
- Adaptive login layout for small screens
- Full-width login button, keyboard-safe scroll

### BUG-003 (Backend open + partial mobile)
Mobile: refreshes unread count on app resume.

Backend still must:
1. Fix queue / worker so push is not delayed 5+ minutes
2. Confirm staging fix is in **production**
3. Ensure payload includes `data.signalId` for trade deep links
4. Check FCM/APNs delivery logs + retry backoff

### BUG-004 (Backend — Resolved)
Admin CSV export — missing `DISTINCT` was root cause. Not a mobile feature.

### BUG-005 (Fixed — mobile)
- Settings → Dark Mode switch
- Preference saved in SharedPreferences (`is_dark_mode`)
- Survives restart / update

---

## E) Acceptance tests

### Screenshots / APIs
1. Academy shows real categories/videos (not demo).
2. Admin adds YouTube video → appears after refresh.
3. Video opens on YouTube.
4. Like / Save toggle + persist after refresh.
5. Tracking cards show Entry / Stop / Target.
6. Log form sends Entry / Stop / Target; backend stores them.
7. `isCopied: true` → Tracked + disabled button.

### Bugs
1. Airplane mode cold start → no crash.
2. Small-screen login button aligned.
3. Push arrives within ~30s (backend).
4. Dark mode preference survives restart.

---

## F) Questions for backend

1. Admin Academy route prefix OK as `/api/v1/admin/academy/...`?
2. Soft-delete or hard-delete for academy items?
3. Need a “Saved signals” list endpoint later?
4. BUG-003 staging fix — production ETA?

---

## G) Blocked on backend

Until backend ships:
- Real Academy content (mobile uses demo fallback)
- Persistent Like / Save across devices/sessions
- Full Tracking Entry/Stop/Target when nested fields missing
- Reliable push delivery (BUG-003)

---

**End of handoff.**  
Replace older docs (`BACKEND_TODO.md`, `backend-handoff-academy-tracking.md`, `BUG_TRACKER_FIXES.md`) with this file.
