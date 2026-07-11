# Backend API Requirements — Chris Trading App (Mobile)

**Base URL:** `/api/v1`  
**Auth:** All authenticated endpoints require Bearer token.

These API changes / new endpoints are required for the mobile app based on client feedback.

---

## 1) Notifications

### Client needs
- Tapping a notification should open that trade/signal for review
- Clicking one unread notification should mark **only that one** as read (not all)
- User should be able to read the full notification message

---

### 1.1 Existing — UPDATE

`GET /api/v1/notifications?page=&limit=`

**Change required:**
- This endpoint must **NOT** mark any notifications as read
- It should only return the list (`isRead` as stored in DB)

**Ensure each response item includes:**

```json
{
  "_id": "...",
  "type": "signal_published | trade_update | badge | ...",
  "title": "...",
  "message": "...",
  "isRead": false,
  "link": "/signals/{signalId}",
  "data": {
    "signalId": "69f1da6d...",
    "symbol": "BTCUSDT",
    "signalType": "long",
    "badgeKey": null,
    "badgeName": null
  },
  "createdAt": "2026-07-11T10:00:00.000Z"
}
```

**Rules:**
- For trade/signal related notifications, `data.signalId` is **required**
- For non-trade types, `signalId` may be `null`

---

### 1.2 New endpoint

`PATCH /api/v1/notifications/:id/read`

**Purpose:** Mark a single notification as read

**Response:**

```json
{
  "success": true,
  "message": "Notification marked as read",
  "data": {
    "_id": "...",
    "isRead": true
  }
}
```

---

### 1.3 New endpoint (optional but useful)

`PATCH /api/v1/notifications/read-all`

**Purpose:** Mark all unread notifications as read (if UI later needs “Mark all”)

---

### 1.4 Existing — keep

`GET /api/v1/notifications/unread-count`

- Unread count must update after a single mark-read

---

## 2) Signals — Copied state (grey out after copy)

### Client need
After copying a signal, that signal should appear greyed out / disabled.

---

### 2.1 Existing — UPDATE

`GET /api/v1/signals?page=&limit=`  
`GET /api/v1/signals/:id`

**Add field (for the current logged-in user):**

```json
{
  "isCopied": true
}
```

**Rules:**
- `isCopied: true` if the user already copied this signal
- `false` otherwise
- After a successful copy, subsequent GET responses must return `true`

---

### 2.2 Existing — keep / improve

`POST /api/v1/copied-trades/signals/:signalId/copy`

**Suggested:**
- If already copied, return `409` or a clear message:

```json
{
  "success": false,
  "message": "Signal already copied"
}
```

---

## 3) Signals — Search / Filter by symbol type

### Client need
User should be able to select symbol type and search/filter signals.

---

### 3.1 Existing — UPDATE

`GET /api/v1/signals`

**Add query params:**

| Param | Type | Example | Required |
|-------|------|---------|----------|
| `page` | number | `1` | yes |
| `limit` | number | `10` | yes |
| `assetType` | string | `crypto` / `forex` / `stocks` | no |
| `symbol` | string | `BTCUSDT` | no |
| `search` | string | free text (title/symbol) | no |
| `sortBy` | string | `newest` (default) | no |

**Example:**

```http
GET /api/v1/signals?page=1&limit=10&assetType=crypto&symbol=BTCUSDT&sortBy=newest
```

**Please confirm allowed `assetType` values** (needed for app dropdown).

---

## 4) Sort — Most recent trades

### Client need
Most recent trades should appear first.

---

### 4.1 Existing — UPDATE

`GET /api/v1/signals?page=&limit=`

- Default sort: **newest first** (`createdAt` / `publishedAt` DESC)
- Optional: `sortBy=newest`

---

### 4.2 Existing — UPDATE

`GET /api/v1/copied-trades?page=&limit=&status=`

- Default sort: **newest first** (`copiedAt` / `createdAt` DESC)
- Optional: `sortBy=newest`

---

## 5) Platforms list (Log Trade dropdown)

### Client need
Platforms used when logging a trade should be updatable (not hardcoded in the app).

---

### 5.1 New endpoint

`GET /api/v1/config/platforms`  
*(or include a `platforms` key inside existing `/api/v1/config`)*

**Response:**

```json
{
  "success": true,
  "data": [
    { "value": "binance", "label": "Binance" },
    { "value": "mt4", "label": "MT4" },
    { "value": "mt5", "label": "MT5" },
    { "value": "bybit", "label": "Bybit" }
  ]
}
```

**Rules:**
- List should be admin-manageable
- Log API should only accept `value`s from this list

---

## 6) Log Trade submit + PnL unit ($ or %)

### Client needs
- Submit log must work correctly
- Clarify and support whether win/loss PnL is in dollars or percent (user-selectable if both)

---

### 6.1 Existing — CONFIRM / UPDATE

`POST /api/v1/copied-trades/log`

**Current body the app sends:**

```json
{
  "signalId": "string",
  "entryPrice": 1.085,
  "exitPrice": 1.092,
  "lotSize": 0.5,
  "resultPnl": 350,
  "outcome": "win",
  "notes": "Followed master's TP2 target",
  "screenshotUrl": "https://...",
  "externalPlatform": "binance"
}
```

**Please confirm:**
1. Is `screenshotUrl` required?
2. Is `notes` required?
3. Allowed `outcome` values: `win` / `loss`?
4. Allowed `externalPlatform` values?
5. Exact success/error response format?

**Add field (if both $ and % are supported):**

```json
{
  "resultPnl": 350,
  "pnlUnit": "usd"
}
```

`pnlUnit`: `"usd"` | `"percent"`

---

### 6.2 Existing — UPDATE (history / details response)

`GET /api/v1/copied-trades?...`  
`GET /api/v1/signals/:id` (if result is shown)

**Add in trade/log response:**

```json
{
  "resultPnl": 350,
  "pnlUnit": "usd"
}
```

So the app can display `$` or `%` correctly.

---

### 6.3 Existing — CONFIRM

`POST /api/v1/upload/file`

App currently expects:

```json
{
  "url": "https://..."
}
```

If the URL is nested, please confirm the exact shape:

```json
{
  "success": true,
  "data": { "url": "https://..." }
}
```

or

```json
{
  "success": true,
  "url": "https://..."
}
```

---

## Summary table (quick view)

| # | Type | Endpoint | Action |
|---|------|----------|--------|
| 1 | UPDATE | `GET /notifications` | **Do not** mark all as read on list fetch |
| 2 | NEW | `PATCH /notifications/:id/read` | Mark single notification as read |
| 3 | NEW (optional) | `PATCH /notifications/read-all` | Mark all as read |
| 4 | UPDATE | `GET /signals` + `GET /signals/:id` | Add `isCopied` |
| 5 | UPDATE | `GET /signals` | Add filters: `assetType`, `symbol`, `search`, `sortBy` |
| 6 | UPDATE | `GET /signals` + `GET /copied-trades` | Default sort = newest first |
| 7 | NEW | `GET /config/platforms` | Dynamic platform list |
| 8 | UPDATE | `POST /copied-trades/log` | Confirm contract + add `pnlUnit` (if dual unit) |
| 9 | UPDATE | copied-trades / signal responses | Return `pnlUnit` |
| 10 | CONFIRM | `POST /upload/file` | Exact URL response shape |

---

## Priority for Backend

1. **P0:** Notifications — mark-one-read + stop bulk-read on GET list  
2. **P0:** Confirm log trade + upload response contract  
3. **P1:** `isCopied` on signals  
4. **P1:** Newest-first sort on signals & copied-trades  
5. **P2:** Signal search/filter (`assetType`, `symbol`)  
6. **P2:** Platforms config endpoint  
7. **P2:** `pnlUnit` (`usd` / `percent`)

---

## Questions for Backend (reply needed)

1. Does `GET /notifications` currently mark all unread items as read?
2. Do trade notifications always include `data.signalId`?
3. Can you add `isCopied` on signal list/detail?
4. What are the allowed `assetType` values?
5. Will platforms be admin-managed, or a fixed list?
6. Log PnL: dollars only, percent only, or both (`pnlUnit`)?
7. In upload file response, which key contains the URL?

---

## Mapping to client feedback

| Client feedback | Backend work |
|-----------------|--------------|
| Click notification to review trade | Ensure `data.signalId` on notifications |
| One unread click marks all as read | Stop bulk-read on GET; add mark-one-read |
| Grey out after copy | Add `isCopied` on signals |
| Update platforms | Add platforms config endpoint |
| Submit log not working | Confirm log + upload contracts |
| Sort most recent trades | Default newest-first sort |
| Select symbol type to search | Add `assetType` / `symbol` / `search` filters |
| PnL dollars or percent | Confirm unit + optional `pnlUnit` |
