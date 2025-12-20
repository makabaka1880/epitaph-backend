# Backend API Documentation

[![Build and Push Image](https://github.com/makabaka1880/epitaph-backend/actions/workflows/build.yml/badge.svg)](https://github.com/makabaka1880/epitaph-backend/actions/workflows/build.yml)

## Overview

Epitaph Backend API for managing memorial messages. Built with Vapor and PostgreSQL.

---

## System API

### GET `/`

Get system status and statistics.

**Response (JSON):**

```json
{
  "message": "Epitaph is ready. Leave your words of remembrance.",
  "totalMessages": 123,
  "reviewQueue": 5
}
```

* `message`: Welcome message
* `totalMessages`: Total number of published messages
* `reviewQueue`: Number of pending messages in review

**HTTP Status Codes:**

| Code | Description              |
| ---- | ------------------------ |
| 200  | Success                  |
| 500  | Server or database error |

---

### GET `/hello`

Health check endpoint.

**Response (Plain Text):**

```
Hello, world!
```

**HTTP Status Codes:**

| Code | Description |
| ---- | ----------- |
| 200  | Success     |

---

## Messages API

### GET `/api/messages`

Fetch a paginated list of messages.

**Query Parameters:**

| Parameter       | Type    | Required | Description                                              |
| --------------- | ------- | -------- | -------------------------------------------------------- |
| `limit`         | Integer | No       | Number of messages to return per page (default: 20)      |
| `page`          | Integer | No       | Page number for offset-based pagination (default: 1)     |
| `lastCreatedAt` | String  | No       | Cursor timestamp (ISO 8601 format) for cursor pagination |

**Pagination Behavior:**

* If `lastCreatedAt` is provided, cursor-based pagination is used:
  Returns messages created *before* the given timestamp, ordered descending by creation time.
* Otherwise, offset-based pagination is used with `page` and `limit`.

**Response (JSON):**

```json
{
	"count": 10,
	"totalCount": 123,
	"totalPages": 13,
	"currentPage": 2,
	"results": [
		{
		"id": "uuid-string",
		"createdAt": "2024-12-24T21:01:55Z",
		"name": "雯雯妈妈",
		"note": "说来惭愧，只能以暖暖一家来称呼...",
		"recipient": "致家庭",
		"updatedAt": "2024-12-24T21:01:55Z"
		},
		// more message objects...
	]
}
```

**HTTP Status Codes:**

| Code | Description              |
| ---- | ------------------------ |
| 200  | Success                  |
| 400  | Invalid query parameters |
| 500  | Server or database error |
    
---

### POST `/api/messages`

Create a new message (goes to review queue).

**Request Body (JSON):**

```json
{
  "name": "Sender Name",
  "note": "Message content...",
  "recipient": "Recipient name"
}
```

* `createdAt` and `updatedAt` are set automatically.
* Messages are created in the review queue with `status: "pending"`

**Response (JSON):**

```json
{
  "id": "uuid-string",
  "createdAt": "2025-06-28T14:00:00Z",
  "name": "Sender Name",
  "note": "Message content...",
  "recipient": "Recipient name",
  "updatedAt": "2025-06-28T14:00:00Z",
  "status": "pending"
}
```

**HTTP Status Codes:**

| Code | Description              |
| ---- | ------------------------ |
| 200  | Created successfully     |
| 400  | Validation error         |
| 500  | Server or database error |

---

### DELETE `/api/messages/:messageID`

Delete a message by its UUID (moves it to the review stack).

**Path Parameters:**

| Parameter   | Type | Description           |
| ----------- | ---- | --------------------- |
| `messageID` | UUID | The ID of the message |

**Response:**

* No content on success.

**HTTP Status Codes:**

| Code | Description              |
| ---- | ------------------------ |
| 204  | Deleted successfully     |
| 403  | Forbidden (if not authorized) |
| 404  | Message not found        |
| 500  | Server or database error |

---



---

## Message Review API

### GET `/api/review/all`

Fetch all messages in the review queue.

**Authentication:**

* Requires `Authorization` header with admin review key

**Response (JSON):**

```json
[
	{
		"id": "uuid-string",
		"createdAt": "2025-06-28T14:00:00Z",
		"name": "Sender Name",
		"note": "Message content...",
		"recipient": "Recipient name",
		"updatedAt": "2025-06-28T14:00:00Z",
		"status": "pending"
	}
	// more review message objects...
]
```

**Status Field Values:**
- `pending`: Awaiting review
- `removed`: Removed from public messages
- `rejected`: Rejected by moderator

**HTTP Status Codes:**

| Code | Description              |
| ---- | ------------------------ |
| 200  | Success                  |
| 403  | Forbidden (invalid auth) |
| 500  | Server or database error |

---

### POST `/api/review/promote`

Promote a review message to published status.

**Authentication:**

* Requires `Authorization` header with admin review key

**Request Body (JSON):**

```json
{
  "id": "uuid-string"
}
```

**Response (JSON):**

```json
{
  "id": "uuid-string",
  "createdAt": "2025-06-28T14:00:00Z",
  "name": "Sender Name",
  "note": "Message content...",
  "recipient": "Recipient name",
  "updatedAt": "2025-06-28T14:00:00Z"
}
```

**HTTP Status Codes:**

| Code | Description                   |
| ---- | ----------------------------- |
| 200  | Promoted successfully         |
| 403  | Forbidden (invalid auth)      |
| 404  | Review message not found      |
| 500  | Server or database error      |

---

### POST `/api/review/reject`

Reject a review message.

**Authentication:**

* Requires `Authorization` header with admin review key

**Request Body (JSON):**

```json
{
  "id": "uuid-string"
}
```

**Response (JSON):**

```json
{
  "id": "uuid-string",
  "createdAt": "2025-06-28T14:00:00Z",
  "name": "Sender Name",
  "note": "Message content...",
  "recipient": "Recipient name",
  "updatedAt": "2025-06-28T14:00:00Z",
  "status": "rejected"
}
```

**HTTP Status Codes:**

| Code | Description                   |
| ---- | ----------------------------- |
| 200  | Rejected successfully         |
| 403  | Forbidden (invalid auth)      |
| 404  | Review message not found      |
| 500  | Server or database error      |

---

## Grayscale API

### GET `/api/grayscale/today`

Check if today is a grayscale day.

**Response (JSON):**

```json
{
  "gray": true,
  "reason": "National Day of Mourning"
}
```

* `gray`: Boolean indicating if today is a grayscale day
* `reason`: Optional string explaining why (null if not a grayscale day)

**HTTP Status Codes:**

| Code | Description              |
| ---- | ------------------------ |
| 200  | Success                  |
| 500  | Server or database error |

---

### GET `/api/grayscale/range`

Get grayscale dates within a date range.

**Query Parameters:**

| Parameter | Type   | Required | Description                             |
| --------- | ------ | -------- | --------------------------------------- |
| `from`    | String | Yes      | Start date in ISO 8601 format           |
| `to`      | String | Yes      | End date in ISO 8601 format             |

**Response (JSON):**

```json
[
	{
		"id": "uuid-string",
		"reason": "National Day of Mourning",
		"date": "2025-04-04T00:00:00Z"
	},
	{
		"id": "uuid-string",
		"reason": "Memorial Day",
		"date": "2025-05-30T00:00:00Z"
	}
]
```

**HTTP Status Codes:**

| Code | Description                        |
| ---- | ---------------------------------- |
| 200  | Success                            |
| 400  | Missing or invalid query parameters|
| 500  | Server or database error           |

---

## PlainText API

### GET `/api/plaintext`

Retrieve plain text content by key.

**Query Parameters:**

| Parameter | Type   | Required | Description                          |
| --------- | ------ | -------- | ------------------------------------ |
| `key`     | String | Yes      | The key identifying the text content |

**Response (JSON):**

```json
{
  "id": "uuid-string",
  "key": "about-text",
  "content": "This is the about text content..."
}
```

**HTTP Status Codes:**

| Code | Description                      |
| ---- | -------------------------------- |
| 200  | Success                          |
| 400  | Missing 'key' query parameter    |
| 404  | No content found for key         |
| 500  | Server or database error         |

---

## Resources API

### GET `/api/resources/badges/:repo/**`

Proxy to GitHub Actions workflow badge.

**Path Parameters:**

| Parameter | Type   | Description                          |
| --------- | ------ | ------------------------------------ |
| `repo`    | String | Repository name under makabaka1880   |
| `**`      | String | Path to workflow badge (e.g., `build.yml`)|

**Example:**

```
GET /api/resources/badges/epitaph-backend/build.yml
```

**Response:**

* Returns the badge SVG image from GitHub

**HTTP Status Codes:**

| Code | Description                      |
| ---- | -------------------------------- |
| 200  | Success                          |
| 400  | Invalid parameters               |
| *    | Mirrors GitHub API response      |

---

### GET `/api/resources/bucket/single`

Retrieve a single memory from the bucket.

**Query Parameters:**

| Parameter | Type   | Required | Description              |
| --------- | ------ | -------- | ------------------------ |
| `id`      | String | Yes      | UUID of the memory       |

**Response (JSON):**

```json
{
  "count": 42,
  "result": {
    "id": "uuid-string",
    "label": "Family Vacation",
    "date": "2024-07-15",
    "description": "Summer trip to the mountains",
    "image": "https://bucket-url/memories/uuid-string.webp"
  }
}
```

* `count`: Total number of memories in database
* `result`: The requested memory object
* `image`: Auto-generated URL based on memory ID

**HTTP Status Codes:**

| Code | Description                   |
| ---- | ----------------------------- |
| 200  | Success                       |
| 400  | Missing or invalid 'id' query |
| 404  | Memory not found              |
| 500  | Server or database error      |

---

## Notes

* All timestamps are in ISO 8601 format and UTC timezone.
* Pagination is key for performance and user experience; cursor-based is recommended for infinite scroll.
* UUIDs are used as primary keys for messages.
* All authenticated endpoints use the `Authorization` header.