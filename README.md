# A Quick and Dirty CMS

I've found that StorageRoom is not doing what I want (and it's agonizingly slow
to use it for real-time pulls). This is a prototype to see what I can do.

## API

The API provides just a few endpoints - one to get content, one to create new
content, one to get a specific piece of content by an ID, and to login so that
you update content and we can track you doing it.

### GET /content/:type

Type is pluralized content type (e.g. actions, challenges, tips, etc.).

### GET /content/:type/:id

Retrieve a piece of content with ID = :id

### POST /content/:type

Create a piece of content of type = :type

### POST /sessions

Takes a username and password and creates a session if the user successfully
authenticates.
