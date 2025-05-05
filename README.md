# Professor Dashboard

A web application for professors to manage their courses, assignments, and schedules.

## Keycloak Authentication Setup

This application uses Keycloak for authentication. Follow these steps to set up Keycloak integration:

### 1. Install and Configure Keycloak Server

If you don't have a Keycloak server, you can run it using Docker:

```bash
docker run -p 8080:8080 -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin quay.io/keycloak/keycloak:latest start-dev
```

### 2. Configure Keycloak

1. Log in to your Keycloak admin console (e.g., http://localhost:8080/admin).
2. Create a new realm (or use an existing one).
3. Create a new client:
   - Set Client ID (e.g., `professor-dashboard`)
   - Enable `Client authentication`
   - Set Valid Redirect URIs to include your application callback URL (e.g., `http://localhost:3000/auth/callback`).
4. After creating the client, go to the "Credentials" tab and copy the client secret.
5. Create a user for testing or configure your identity provider.

### 3. Configure Environment Variables

Copy the `.env.sample` file to `.env` and update the variables:

```
KEYCLOAK_URL=localhost:8080
REALM_ID=your-realm-name
CLIENT_ID=professor-dashboard
CLIENT_SECRET=your-client-secret
REDIRECT_URI=http://localhost:3000/auth/callback
```

## Development

### Prerequisites

- Ruby version: [ruby version]
- Rails version: [rails version]
- [Other dependencies...]

### Setup

1. Clone the repository
2. Install dependencies:
   ```bash
   bundle install
   ```
3. Set up the database:
   ```bash
   rails db:create db:migrate
   ```
4. Start the Rails server:
   ```bash
   rails server
   ```

## Testing

In test environment, the application bypasses Keycloak authentication. To run tests:

```bash
rails test
```
