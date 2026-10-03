# swb_advance/app

A new Flutter project.

## Authentication API

Login responses must include `access_token` and a `user` object containing
`id` and `email`. The app also stores optional `refresh_token`, `token_type`,
and `expires_in` values. Tokens are saved in secure storage and the access
token is sent as a Bearer token on subsequent API requests.

Supabase remains the default. To use a conventional REST backend, configure
these values in `.env`:

```env
API_BASE_URL=https://api.example.com
LOGIN_PATH=/auth/login
USE_SUPABASE_GRANT_TYPE=false
API_KEY=
```

`API_KEY` is optional and is sent in the `apikey` header. It is not used as a
Bearer token for conventional REST login requests.

The login response shape is:

```json
{
  "access_token": "...",
  "refresh_token": "...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "user": {
    "id": "...",
    "email": "..."
  }
}
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
