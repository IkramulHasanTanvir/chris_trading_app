# Backend Handoff — Mobile App Changes (Jul 2026)

**From:** Mobile (Flutter)  
**To:** Backend / Admin Portal  
**App:** Chris Trading App  
**Base URL:** `/api/v1`  
**Auth:** Bearer token on all authenticated endpoints  

This doc lists **what mobile already shipped** and **exactly what backend needs to build/update**.

---

## Summary — Mobile already done

| # | Mobile change | Backend needed? |
|---|---------------|-----------------|
| 1 | Bottom nav: Home / Signals / Tracking / Academy / Profile | Yes — Academy APIs |
| 2 | “Copy Trade” renamed to **Tracking** (UI only) | No (same copy endpoint) |
| 3 | Signal card labels: **Entry \| Stop \| Target** | No |
| 4 | Trade name always on top; image optional | No |
| 5 | Tracking tabs: **Tracking \| Log Trades** | No (same copied-trades APIs) |
| 6 | Like / Save / Reply actions on signal details | **Yes — new APIs + fields** |
| 7 | Academy screen (YouTube videos by category) | **Yes — new APIs + admin CRUD** |

---

## 1) Academy (NEW — high priority)

### Product intent
Academy is the **educational** section.  
Admins upload/manage **YouTube videos by category** in the admin portal.  
Mobile only lists and opens them.

### Mobile already calls

```http
GET /api/v1/academy/categories
GET /api/v1/academy/videos
GET /api/v1/academy/videos?categoryId={id}
```

If these fail, mobile shows temporary demo content. Replace that by shipping real APIs.

---

### 1.1 `GET /api/v1/academy/categories`

**Auth:** required  

**Response:**

```json
{
  "success": true,
  "data": [
    {
      "_id": "66f1...",
      "name": "Forex",
      "sortOrder": 1,
      "isActive": true
    }
  ]
}
```

**Rules:**
- Return only active categories
- Sort by `sortOrder` ASC (or name ASC)

---

### 1.2 `GET /api/v1/academy/videos?categoryId=`

**Auth:** required  

| Param | Required | Notes |
|-------|----------|-------|
| `categoryId` | no | If omitted, return all active videos |
| `page` | no | optional pagination |
| `limit` | no | optional pagination |

**Response:**

```json
{
  "success": true,
  "data": [
    {
      "_id": "66f2...",
      "title": "Forex Basics for Beginners",
      "description": "Learn the fundamentals of forex trading.",
      "youtubeUrl": "https://www.youtube.com/watch?v=XXXXXXXXXXX",
      "thumbnailUrl": null,
      "categoryId": "66f1...",
      "categoryName": "Forex",
      "durationSeconds": 720,
      "isActive": true,
      "createdAt": "2026-07-20T10:00:00.000Z"
    }
  ]
}
```

**Rules:**
- `youtubeUrl` is required and must be a valid YouTube watch / youtu.be URL
- `thumbnailUrl` optional — if null, mobile builds from YouTube ID
- Only return active videos
- Filter by `categoryId` when provided

---

### 1.3 Admin Portal — CRUD (required)

Admin must be able to:

1. Create / edit / deactivate **categories**
2. Create / edit / deactivate **videos**
3. Assign a video to a category
4. Paste a YouTube URL + title + description

Suggested admin endpoints (internal):

```http
POST   /api/v1/admin/academy/categories
PATCH  /api/v1/admin/academy/categories/:id
DELETE /api/v1/admin/academy/categories/:id

POST   /api/v1/admin/academy/videos
PATCH  /api/v1/admin/academy/videos/:id
DELETE /api/v1/admin/academy/videos/:id
```

---

## 2) Signal Like & Bookmark (NEW)

### Product intent
On signal details, users can:
- **Like** a signal
- **Save / Bookmark** a signal
- **Reply** (mobile uses existing comments API — no new reply endpoint needed unless you want nested replies later)

### Mobile already calls

```http
POST /api/v1/signals/:signalId/like
POST /api/v1/signals/:signalId/bookmark
```

Both are **toggle** endpoints (like again = unlike, bookmark again = unbookmark).

---

### 2.1 `POST /api/v1/signals/:signalId/like`

**Auth:** required  

**Response:**

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

### 2.2 `POST /api/v1/signals/:signalId/bookmark`

**Auth:** required  

**Response:**

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

### 2.3 Update existing signal responses

Add these fields on:

- `GET /api/v1/signals`
- `GET /api/v1/signals/:id`

```json
{
  "likeCount": 12,
  "bookmarkCount": 4,
  "commentCount": 3,
  "isLiked": false,
  "isBookmarked": false
}
```

**Rules:**
- `isLiked` / `isBookmarked` are **per current logged-in user**
- Counts are global totals
- Mobile already maps `likeCount`, `bookmarkCount`, `isLiked`, `isBookmarked`

---

## 3) Tracking rename (NO new copy API)

### Mobile UI rename only
- Button: **Copy Trade** → **Tracking**
- State: **Copied** → **Tracked**
- Screen tabs: **Copy Trade / Log Trade** → **Tracking / Log Trades**

### Backend keep using existing endpoints

```http
POST /api/v1/copied-trades/signals/:signalId/copy
GET  /api/v1/copied-trades?page=&limit=&status=&sortBy=newest
POST /api/v1/copied-trades/log
```

No rename required on backend unless you want response messages like `"Signal tracked successfully"`.

Still ensure:

- After copy/track, list + detail return `"isCopied": true`
- Already-copied returns clear `409` / message

---

## 4) Comments / Reply (mostly existing)

Mobile reply uses the **existing comment create** flow:

```http
GET  /api/v1/comments?signalId=&page=&limit=
POST /api/v1/comments
```

Body mobile sends (current):

```json
{
  "signalId": "...",
  "message": "@jay hello"
}
```

**Optional later (not blocking):**
- Nested replies with `parentCommentId`
- For now, plain comments + `@mention` text is enough

---

## 5) Signal card field mapping (FYI — no backend rename needed)

Mobile display labels changed, but JSON keys stay the same:

| Mobile label | JSON field |
|--------------|------------|
| Entry | `entryPrice` |
| Stop | `stopLoss` |
| Target | `takeProfit1` |

Do **not** rename API fields.

---

## 6) Checklist for Backend Dev

### Must ship

- [ ] `GET /api/v1/academy/categories`
- [ ] `GET /api/v1/academy/videos?categoryId=`
- [ ] Admin CRUD for Academy categories + videos (YouTube URL)
- [ ] `POST /api/v1/signals/:id/like` (toggle)
- [ ] `POST /api/v1/signals/:id/bookmark` (toggle)
- [ ] Add `isLiked`, `isBookmarked` on signal list + detail
- [ ] Keep/confirm `likeCount`, `bookmarkCount`, `commentCount`

### Confirm still working

- [ ] `isCopied` on signal list + detail
- [ ] Copy/track endpoint + 409 if already copied
- [ ] Comments list + create
- [ ] Copied trades list (`pending` / completed statuses)
- [ ] Log trade + screenshot upload

---

## 7) Suggested DB models

### `academy_categories`
- `_id`
- `name`
- `sortOrder`
- `isActive`
- `createdAt` / `updatedAt`

### `academy_videos`
- `_id`
- `title`
- `description`
- `youtubeUrl`
- `thumbnailUrl` (optional)
- `categoryId` (ref)
- `durationSeconds` (optional)
- `isActive`
- `createdAt` / `updatedAt`

### `signal_likes`
- `signalId`
- `userId`
- unique index on `(signalId, userId)`

### `signal_bookmarks`
- `signalId`
- `userId`
- unique index on `(signalId, userId)`

---

## 8) Acceptance criteria

1. Opening Academy tab shows real categories + videos from API (no mobile demo fallback needed).
2. Tapping a video opens the YouTube URL.
3. Admin can add a YouTube video under a category and it appears in app after refresh.
4. On signal details, Like toggles `isLiked` + updates `likeCount`.
5. Save toggles `isBookmarked` + updates `bookmarkCount`.
6. After refresh, like/save state persists for that user.
7. Tracking button still uses existing copy-trade flow; `isCopied` still works.

---

## 9) Contact / questions for Backend

1. Preferred Academy admin routes prefix (`/admin/academy/...`)?
2. Soft-delete vs hard-delete for videos/categories?
3. Should bookmarks also have a “Saved signals” list endpoint later?
4. Nested comment replies needed in this sprint, or later?

---

**Mobile status:** UI + API client wired.  
**Blocked on:** Academy APIs + Like/Bookmark APIs + Admin video management.
