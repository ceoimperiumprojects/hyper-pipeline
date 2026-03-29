# API Documentation

## Base URL

`http://localhost:PORT/api`

## Authentication

[Describe auth method: Bearer token, API key, session cookie, none]

## Endpoints

### [Resource] — [description]

#### `GET /api/[resource]`

List all [resources] with pagination.

**Query Parameters:**
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| page | number | 1 | Page number |
| limit | number | 20 | Items per page |
| sort | string | "createdAt" | Sort field |
| order | string | "desc" | Sort direction |

**Response (200):**
```json
{
  "data": [...],
  "total": 100,
  "page": 1,
  "pages": 5
}
```

#### `GET /api/[resource]/:id`

Get single [resource] by ID.

**Response (200):**
```json
{
  "id": "...",
  ...
}
```

**Response (404):**
```json
{
  "error": "Resource not found",
  "code": "NOT_FOUND"
}
```

#### `POST /api/[resource]`

Create new [resource].

**Request Body (Zod schema):**
```typescript
z.object({
  name: z.string().min(1).max(255),
  // ...
})
```

**Response (201):**
```json
{
  "id": "...",
  ...
}
```

**Response (400):**
```json
{
  "error": "Validation failed",
  "code": "VALIDATION_ERROR",
  "details": [...]
}
```

#### `PATCH /api/[resource]/:id`

Update [resource].

**Request Body:** Partial of create schema.

**Response (200):** Updated resource.

#### `DELETE /api/[resource]/:id`

Delete [resource].

**Response (204):** No content.

---

## Error Format

All errors follow this format:

```json
{
  "error": "Human-readable message",
  "code": "MACHINE_READABLE_CODE",
  "details": {}
}
```

| Code | HTTP | Meaning |
|------|------|---------|
| VALIDATION_ERROR | 400 | Invalid request body |
| UNAUTHORIZED | 401 | Missing or invalid auth |
| FORBIDDEN | 403 | Insufficient permissions |
| NOT_FOUND | 404 | Resource doesn't exist |
| RATE_LIMITED | 429 | Too many requests |
| INTERNAL_ERROR | 500 | Server error |
