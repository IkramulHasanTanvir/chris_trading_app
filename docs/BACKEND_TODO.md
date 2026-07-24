# Backend Work Required — Chris Trading App

**Date:** 24 Jul 2026  
**From:** Mobile team  
**For:** Backend / Admin Portal  
**Base URL:** `/api/v1`  
**Auth:** Bearer token (unless noted)

Mobile UI changes from `App_Screenshots.docx` are already done.  
Backend needs to ship the APIs below so Like / Save / Academy work with real data.

---

## Priority checklist

| Priority | Task | Status needed |
|----------|------|---------------|
| P0 | Academy categories + videos APIs | **NEW** |
| P0 | Admin portal: load YouTube videos by category | **NEW** |
| P0 | Like toggle API | **NEW** |
| P0 | Bookmark/Save toggle API | **NEW** |
| P0 | Add `isLiked`, `isBookmarked` on signal list/detail | **UPDATE** |
| P1 | Copied-trades nested signal: include `stopLoss`, `takeProfit1` | **UPDATE** |
| P1 | Log trade accept `stopLoss` + `targetPrice` (Target) | **UPDATE** |
| P1 | Copied-trade list return `stopLoss` / Target fields | **UPDATE** |
| P2 | Keep existing copy/track + comments working | Confirm |

---

## 1) Academy (Educational YouTube by category)

### Why
Bottom nav now has a real **Academy** tab.  
Admins load YouTube lessons by category. Mobile only lists + opens them.

### Mobile already calls

```http
GET /api/v1/academy/categories
GET /api/v1/academy/videos
GET /api/v1/academy/videos?categoryId={categoryId}
```

---

### 1.1 Categories

`GET /api/v1/academy/categories`

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

Rules:
- Return only active categories
- Sort by `sortOrder` ASC

---

### 1.2 Videos

`GET /api/v1/academy/videos?categoryId=`

| Query | Required | Notes |
|-------|----------|-------|
| `categoryId` | No | Filter by category |
| `page` | No | Optional |
| `limit` | No | Optional |

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
- `youtubeUrl` required (YouTube watch or youtu.be)
- `thumbnailUrl` optional (mobile can generate from YouTube ID)
- Return only active videos

---

### 1.3 Admin Portal (must)

Admin can:
1. Create / edit / deactivate categories
2. Create / edit / deactivate videos
3. Assign video → category
4. Paste YouTube URL + title + description

Suggested admin routes:

```http
POST   /api/v1/admin/academy/categories
PATCH  /api/v1/admin/academy/categories/:id
DELETE /api/v1/admin/academy/categories/:id

POST   /api/v1/admin/academy/videos
PATCH  /api/v1/admin/academy/videos/:id
DELETE /api/v1/admin/academy/videos/:id
```

---

## 2) Like + Save (Bookmark)

### Why
Signal details now has **Like**, **Save**, and **Reply** buttons.  
Reply already uses existing comments API. Like/Save need new endpoints.

### Mobile already calls

```http
POST /api/v1/signals/:signalId/like
POST /api/v1/signals/:signalId/bookmark
```

Both are **toggle** (call again = undo).

---

### 2.1 Like

`POST /api/v1/signals/:signalId/like`

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

---

### 2.2 Bookmark / Save

`POST /api/v1/signals/:signalId/bookmark`

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

---

### 2.3 Update signal list + detail responses

Update:

- `GET /api/v1/signals`
- `GET /api/v1/signals/:id`

Add for **current logged-in user**:

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

---

## 3) Tracking (copied trades) — UPDATE

Mobile renamed Copy Trade → **Tracking** (UI only).  
Same endpoints remain:

```http
POST /api/v1/copied-trades/signals/:signalId/copy
GET  /api/v1/copied-trades?page=&limit=&status=&sortBy=newest
POST /api/v1/copied-trades/log
```

### 3.1 Nested signal fields (required)

On `GET /api/v1/copied-trades`, each item’s `signalId` object must include:

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

### 3.2 Copied-trade item fields (required for Tracking cards)

Tracking cards always show **Entry | Stop | Target**. Return these on each trade:

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
  "signalId": { "...see above..." }
}
```

Rules:
- `stopLoss` can come from logged value OR nested signal
- `exitPrice` / `targetPrice` = Target value (mobile accepts both)
- Mobile UI label is **Target**, API may keep `exitPrice` and optionally add `targetPrice` alias

### 3.3 Log trade body — UPDATE

`POST /api/v1/copied-trades/log`

Mobile now sends:

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

**Backend must:**
1. Accept new field `stopLoss`
2. Accept `targetPrice` (alias of Target) — can store as `exitPrice` / `targetPrice`
3. Keep accepting existing `exitPrice` for backward compatibility
4. Persist `stopLoss` so Tracking list can show it

Also keep confirming:
- `isCopied: true` after user tracks a signal
- Already tracked → clear `409` / message

---

## 4) Comments / Reply — no new API required

Reply uses existing:

```http
GET  /api/v1/comments?signalId=&page=&limit=
POST /api/v1/comments
```

Body:

```json
{
  "signalId": "...",
  "message": "@jay nice setup"
}
```

Optional later: nested replies with `parentCommentId` (not needed this sprint).

---

## 5) Field mapping (do NOT rename API keys)

| Mobile label | API field |
|--------------|-----------|
| Entry | `entryPrice` |
| Stop | `stopLoss` |
| Target | `exitPrice` and/or `targetPrice` / `takeProfit1` |
| Tracking button | uses existing copy endpoint + `isCopied` |

---

## 6) Suggested DB

### academy_categories
- `_id`, `name`, `sortOrder`, `isActive`, timestamps

### academy_videos
- `_id`, `title`, `description`, `youtubeUrl`, `thumbnailUrl?`
- `categoryId`, `durationSeconds?`, `isActive`, timestamps

### signal_likes
- `signalId`, `userId`
- unique `(signalId, userId)`

### signal_bookmarks
- `signalId`, `userId`
- unique `(signalId, userId)`

---

## 7) Acceptance test

1. Academy tab shows real categories/videos from API (not mobile demo).
2. Admin adds a YouTube video → appears in app after refresh.
3. Video tap opens YouTube.
4. Signal details Like toggles and count updates; persists after refresh.
5. Save/Bookmark toggles and persists after refresh.
6. Tracking cards show Entry / Stop / Target (not Exit/Lot as primary).
7. Log Update form sends Entry / Stop / Target (+ lot/pnl); backend stores `stopLoss` + target/exit.
8. Tracking button still works with `isCopied`.

---

## 8) Mobile already done (no backend rename of route names needed)

- Nav: Home | Signals | Tracking | Academy | Profile
- Copy Trade → Tracking (UI text only)
- Signal cards: Entry | Stop | Target
- Trade name on top, image optional
- Tracking tabs: Tracking | Log Trades
- Tracking cards primary row: Entry | Stop | Target
- Log Update form: Entry | Stop | Target (+ Lot / PnL)
- Like / Save / Reply UI
- Academy UI + API client wired

---

## Contact questions

1. Confirm admin route prefix (`/api/v1/admin/academy/...` OK?)
2. Soft-delete or hard-delete for academy items?
3. Need a “Saved signals” list endpoint later?

---

**Blocked mobile features until backend ships:** real Academy content, persistent Like/Save.  
**Tracking rename:** already live on mobile; only nested `stopLoss` / `takeProfit1` needed from copied-trades.
