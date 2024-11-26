#!/bin/bash

# Define the project root directory
PROJECT_ROOT="my-node-app"

# Create the directory structure
mkdir -p $PROJECT_ROOT/{public/{css,js,images},src/{controllers,models,routes,views,middlewares,services,utils},tests}

# Create main files
touch $PROJECT_ROOT/{.env,.gitignore,package.json,package-lock.json,README.md}
touch $PROJECT_ROOT/src/app.js

# Sample content for .env file
cat <<EOL > $PROJECT_ROOT/.env
PORT=3000
MONGO_URI=mongodb://localhost:27017/my-node-app
EOL

# Sample content for .gitignore file
cat <<EOL > $PROJECT_ROOT/.gitignore
node_modules/
.env
EOL

# Detailed content for README.md file
cat <<EOL > $PROJECT_ROOT/README.md
# My Node.js App

This is a Node.js project.

## Directory Structure

\`\`\`
my-node-app/
├── public/
│   ├── css/
│   ├── js/
│   ├── images/
├── src/
│   ├── controllers/
│   ├── models/
│   ├── routes/
│   ├── views/
│   ├── middlewares/
│   ├── services/
│   ├── utils/
│   └── app.js
├── tests/
├── .env
├── .gitignore
├── package.json
├── package-lock.json
└── README.md
\`\`\`

## Setup

1. **Install Node.js**: Download and install Node.js from [nodejs.org](https://nodejs.org/).
2. **Install Dependencies**:
    ```sh
    npm install
    ```
3. **Start the Server**:
    ```sh
    npm start
    ```

## Project Structure

- **public/**: Static assets (CSS, JS, images).
- **src/**: Source code.
  - **controllers/**: Handles requests and responses.
  - **models/**: Data structures and database interaction.
  - **routes/**: Defines URL endpoints.
  - **views/**: HTML templates (if using a templating engine).
  - **middlewares/**: Middleware functions.
  - **services/**: Business logic.
  - **utils/**: Utility functions.
  - **app.js**: Main application file.
- **tests/**: Test files.

## Environment Variables

- **PORT**: Server port number (default: 3000)
- **MONGO_URI**: MongoDB connection string

## Basic Commands

- **Start the server**:
    ```sh
    npm start
    ```
- **Run tests** (if set up):
    ```sh
    npm test
    ```

## Creating a New Route

1. **Create a new route file in \`src/routes\`**.
2. **Define the route and link it to a controller**.
3. **Update \`src/app.js\` to use the new route**.

## Adding a Controller

1. **Create a new controller file in \`src/controllers\`**.
2. **Define functions to handle requests**.
3. **Link the controller to a route**.

For more detailed instructions, refer to the [Express documentation](https://expressjs.com/).
EOL

# Sample content for src/app.js file
cat <<EOL > $PROJECT_ROOT/src/app.js
const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
dotenv.config();

const app = express();

// Middleware
app.use(bodyParser.json());
app.use(express.static('public'));

// Routes
const indexRoutes = require('./routes/index');
app.use('/', indexRoutes);

// Database Connection
mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('Database connected'))
  .catch(err => console.error(err));

// Start the Server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(\`Server is running on port \${PORT}\`);
});
EOL

# Sample content for src/routes/index.js file
mkdir -p $PROJECT_ROOT/src/routes
cat <<EOL > $PROJECT_ROOT/src/routes/index.js
const express = require('express');
const router = express.Router();
const indexController = require('../controllers/indexController');

router.get('/', indexController.home);

module.exports = router;
EOL

# Sample content for src/controllers/indexController.js file
mkdir -p $PROJECT_ROOT/src/controllers
cat <<EOL > $PROJECT_ROOT/src/controllers/indexController.js
exports.home = (req, res) => {
  res.send('Welcome to my Node.js website!');
};
EOL

# Notify the user
echo "Project directory structure created successfully!"

