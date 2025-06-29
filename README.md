# Backend API Documentation

[![Build and Push Image](https://github.com/makabaka1880/epitaph-backend/actions/workflows/build.yml/badge.svg)](https://github.com/makabaka1880/epitaph-backend/actions/workflows/build.yml)

## Overview

Epitaph Backend API for managing memorial messages. Built with Vapor and PostgreSQL.

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

Create a new message.

**Request Body (JSON):**

```json
{
  "name": "Sender Name",
  "note": "Message content...",
  "recipient": "Recipient name"
}
```

* `createdAt` and `updatedAt` are set automatically.

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

| Code | Description              |
| ---- | ------------------------ |
| 201  | Created successfully     |
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



## Notes

* All timestamps are in ISO 8601 format and UTC timezone.
* Pagination is key for performance and user experience; cursor-based is recommended for infinite scroll.
* UUIDs are used as primary keys for messages.