#!/bin/bash

# Define the project root directory
PROJECT_ROOT="my-php-app"

# Create the directory structure
mkdir -p $PROJECT_ROOT/{public/{css,js,images},src/{controllers,models,routes,views,middlewares,services,utils},tests}

# Create main files
touch $PROJECT_ROOT/{.env,.gitignore,composer.json,README.md,start.sh,install.sh}
touch $PROJECT_ROOT/public/index.php

# Sample content for .env file
cat <<EOL > $PROJECT_ROOT/.env
APP_ENV=development
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=my_php_app
DB_USERNAME=root
DB_PASSWORD=
EOL

# Sample content for .gitignore file
cat <<EOL > $PROJECT_ROOT/.gitignore
/vendor/
.env
EOL

# Detailed content for README.md file
cat <<EOL > $PROJECT_ROOT/README.md
# My PHP App

This is a PHP project using Composer.

## Directory Structure

\`\`\`
my-php-app/
├── public/
│   ├── css/
│   ├── js/
│   ├── images/
│   └── index.php
├── src/
│   ├── controllers/
│   ├── models/
│   ├── routes/
│   ├── views/
│   ├── middlewares/
│   ├── services/
│   ├── utils/
├── tests/
├── .env
├── .gitignore
├── composer.json
├── start.sh
├── install.sh
└── README.md
\`\`\`

## Setup

1. **Run the install script**:
    ```sh
    ./install.sh
    ```

2. **Run the start script**:
    ```sh
    ./start.sh
    ```

## Project Structure

- **public/**: Publicly accessible files (CSS, JS, images, main entry point).
- **src/**: Source code.
  - **controllers/**: Handles requests and responses.
  - **models/**: Data structures and database interaction.
  - **routes/**: Defines URL endpoints.
  - **views/**: HTML templates (if using a templating engine).
  - **middlewares/**: Middleware functions.
  - **services/**: Business logic.
  - **utils/**: Utility functions.
- **tests/**: Test files.

## Environment Variables

- **APP_ENV**: Application environment (development, production).
- **DB_CONNECTION**: Database connection type (e.g., mysql).
- **DB_HOST**: Database host.
- **DB_PORT**: Database port.
- **DB_DATABASE**: Database name.
- **DB_USERNAME**: Database username.
- **DB_PASSWORD**: Database password.

## Basic Commands

- **Start the server**:
    ```sh
    ./start.sh
    ```
- **Run tests** (if set up):
    ```sh
    ./vendor/bin/phpunit
    ```

## Creating a New Route

1. **Create a new route file in \`src/routes\`**.
2. **Define the route and link it to a controller**.
3. **Update \`public/index.php\` to use the new route**.

## Adding a Controller

1. **Create a new controller file in \`src/controllers\`**.
2. **Define functions to handle requests**.
3. **Link the controller to a route**.

For more detailed instructions, refer to the [PHP documentation](https://www.php.net/docs.php).
EOL

# Sample content for composer.json file
cat <<EOL > $PROJECT_ROOT/composer.json
{
    "name": "my-php-app",
    "description": "A PHP project",
    "require": {
        "vlucas/phpdotenv": "^5.4"
    },
    "autoload": {
        "psr-4": {
            "App\\": "src/"
        }
    }
}
EOL

# Sample content for public/index.php file
cat <<EOL > $PROJECT_ROOT/public/index.php
<?php
require __DIR__ . '/../vendor/autoload.php';

use Dotenv\Dotenv;
use App\Routes\MainRoutes;

// Load environment variables
$dotenv = Dotenv::createImmutable(__DIR__ . '/../');
$dotenv->load();

// Set up routes
$mainRoutes = new MainRoutes();
$mainRoutes->setup();
?>
EOL

# Sample content for src/routes/MainRoutes.php file
mkdir -p $PROJECT_ROOT/src/routes
cat <<EOL > $PROJECT_ROOT/src/routes/MainRoutes.php
<?php

namespace App\Routes;

use App\Controllers\MainController;

class MainRoutes {
    public function setup() {
        \$controller = new MainController();
        echo \$controller->home();
    }
}
?>
EOL

# Sample content for src/controllers/MainController.php file
mkdir -p $PROJECT_ROOT/src/controllers
cat <<EOL > $PROJECT_ROOT/src/controllers/MainController.php
<?php

namespace App\Controllers;

class MainController {
    public function home() {
        return "Welcome to my PHP website!";
    }
}
?>
EOL

# Create install.sh script
cat <<EOL > $PROJECT_ROOT/install.sh
#!/bin/bash
# Install Composer dependencies
composer install

echo "Dependencies installed."
EOL

# Make install.sh executable
chmod +x $PROJECT_ROOT/install.sh

# Create start.sh script
cat <<EOL > $PROJECT_ROOT/start.sh
#!/bin/bash
# Start the PHP built-in server
php -S localhost:8000 -t public
EOL

# Make start.sh executable
chmod +x $PROJECT_ROOT/start.sh

# Notify the user
echo "Project directory structure created successfully!"

