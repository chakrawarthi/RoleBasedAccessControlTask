# Project Collaboration API - Role-Based Access Control (RBAC)

A Ruby on Rails API application demonstrating Role-Based Access Control (RBAC) and clean authorization architecture for project collaboration management.

## Setup Steps

### Prerequisites
- Ruby 3.2.2 (see `.ruby-version`)
- Rails 7.0
- SQLite3 (default database)
- Bundler gem

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd RoleBasedAccessControlTask
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Setup the database**
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   bin/rails db:seed
   ```

4. **Start the Rails server**
   ```bash
   bin/rails server
   ```

   The API will be available at `http://localhost:3000`

### Running Tests
```bash
bin/rails test
```

## Assumptions Made

1. **Authentication**: Authentication is mocked using the `x-user-id` header. The application assumes the user is authenticated if a valid user ID is provided in the request header. No actual authentication system (like Devise) is implemented.

2. **User Roles**: Users can have one of three roles:
   - `admin`: Full system access
   - `manager`: Can manage projects they own
   - `member`: Can be assigned to projects with viewer or editor permissions

3. **Project Ownership**: Each project has a single owner (manager). The owner is set during project creation via the `owner_id` parameter.

4. **Project Membership Roles**: When a user is added to a project as a member, they can have one of two roles:
   - `viewer`: Read-only access to the project
   - `editor`: Can update the project but cannot delete it

5. **Role Hierarchy**: 
   - Admin has the highest privileges (can do everything)
   - Manager/Project Owner has full control over their own projects
   - Editor members can update projects they're assigned to
   - Viewer members have read-only access

6. **API Format**: All requests and responses use JSON format. No HTML views are provided.

7. **Error Handling**: Validation errors and authorization failures return appropriate HTTP status codes:
   - `403 Forbidden`: Unauthorized access attempts
   - `404 Not Found`: Resource not found
   - `422 Unprocessable Entity`: Validation errors
   - `201 Created`: Successful resource creation
   - `200 OK`: Successful updates/deletes

8. **Database**: SQLite3 is used as the default database for simplicity. The application can be easily configured to use PostgreSQL or MySQL for production.

## Authorization Approach Used

### Authorization Service Pattern

The application uses a **Service Object pattern** for authorization logic, implemented through the `AuthorizationService` class located in `app/services/authorization_service.rb`.

#### Why This Approach?

1. **Separation of Concerns**: Authorization logic is completely separated from controllers, making the code more maintainable and testable.

2. **Reusability**: The `AuthorizationService` can be used across multiple controllers and actions without code duplication.

3. **Single Responsibility**: Controllers focus on handling HTTP requests/responses, while authorization logic is centralized in one place.

4. **Easy to Test**: Authorization rules can be tested independently of controllers.

#### How It Works

1. **Service Initialization**: 
   ```ruby
   AuthorizationService.new(current_user, project_details)
   ```
   - Takes the current user and optional project details
   - Stores them as instance variables for authorization checks

2. **Authorization Methods**: The service provides methods for each authorization check:
   - `can_create_project?`: Only admins can create projects
   - `can_update_project?`: Admins, project owners, or editor members can update
   - `can_delete_project?`: Only admins or project owners can delete
   - `can_manage_members?`: Only admins or project owners can manage members

3. **Usage in Controllers**:
   ```ruby
   # Example from ProjectsController
   auth = authorize_service(@project)
   return render json: {error: "Unauthorized"}, status: :forbidden unless auth.can_update_project?
   ```

4. **Helper Method**: The `ApplicationController` provides a helper method:
   ```ruby
   def authorize_service(project_details = nil)
     AuthorizationService.new(current_user, project_details)
   end
   ```

#### RBAC Rules Implementation

- **Admin**: Full access to all projects and operations
- **Manager/Project Owner**: Full control over projects they own (update, delete, manage members)
- **Editor Member**: Can update projects they're assigned to, but cannot delete
- **Viewer Member**: Read-only access to assigned projects

## API Endpoints

### Project Endpoints

- `GET /projects` - List projects (filtered by user role)
- `POST /projects` - Create a new project (admin only)
- `PUT /projects/:id` - Update a project (admin, owner, or editor member)
- `DELETE /projects/:id` - Delete a project (admin or owner only)

### Membership Endpoints

- `POST /projects/:id/members` - Add a member to a project (admin or owner only)
- `DELETE /projects/:id/members/:user_id` - Remove a member from a project (admin or owner only)

### Request Format

All requests require the `x-user-id` header to identify the current user:
```
x-user-id: 1
```

### Example Request

```bash
curl -X GET http://localhost:3000/projects \
  -H "x-user-id: 1" \
  -H "Content-Type: application/json"
```

## Seed Data

The application includes seed data with sample users:
- Admin user
- Multiple Manager users
- Multiple Member users

Run `bin/rails db:seed` to populate the database with test data.

## Project Structure

```
app/
├── controllers/
│   ├── application_controller.rb    # Base controller with auth helpers
│   ├── projects_controller.rb        # Project CRUD operations
│   └── project_memberships_controller.rb  # Membership management
├── models/
│   ├── user.rb                       # User model with role enum
│   ├── project.rb                    # Project model
│   └── project_membership.rb         # Membership model with role enum
└── services/
    └── authorization_service.rb      # Authorization logic
```

## License

This project is part of a coding assessment.