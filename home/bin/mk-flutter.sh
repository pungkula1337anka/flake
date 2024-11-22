#!/bin/bash

# Define the project root directory
PROJECT_ROOT="my-flutter-app"

# Create the directory structure
mkdir -p $PROJECT_ROOT/{lib/{models,services,controllers,views,widgets},assets/{images,fonts},test}

# Create main files
touch $PROJECT_ROOT/{.gitignore,pubspec.yaml,README.md,start.sh,install.sh}
touch $PROJECT_ROOT/lib/main.dart

# Sample content for .gitignore file
cat <<EOL > $PROJECT_ROOT/.gitignore
*.iml
*.lock
*.log
.idea/
.dart_tool/
.packages
.pub/
build/
flutter_*.pid
EOL

# Detailed content for README.md file
cat <<EOL > $PROJECT_ROOT/README.md
# My Flutter App

This is a Flutter project.

## Directory Structure

\`\`\`
my-flutter-app/
├── assets/
│   ├── fonts/
│   └── images/
├── lib/
│   ├── controllers/
│   ├── models/
│   ├── services/
│   ├── views/
│   ├── widgets/
│   └── main.dart
├── test/
├── .gitignore
├── pubspec.yaml
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

- **assets/**: Static assets (fonts, images).
- **lib/**: Source code.
  - **controllers/**: Handles business logic and user input.
  - **models/**: Data structures and models.
  - **services/**: Business logic and API services.
  - **views/**: UI screens and pages.
  - **widgets/**: Reusable UI components.
  - **main.dart**: Main application file.
- **test/**: Test files.

## Basic Commands

- **Run the application**:
    ```sh
    ./start.sh
    ```
- **Run tests**:
    ```sh
    flutter test
    ```

## Creating a New View

1. **Create a new view file in \`lib/views\`**.
2. **Define the UI components and layout**.

## Adding a Controller

1. **Create a new controller file in \`lib/controllers\`**.
2. **Define functions to handle business logic and user input**.

For more detailed instructions, refer to the [Flutter documentation](https://flutter.dev/docs).
EOL

# Sample content for pubspec.yaml file
cat <<EOL > $PROJECT_ROOT/pubspec.yaml
name: my_flutter_app
description: A new Flutter project.

version: 1.0.0+1

environment:
  sdk: ">=2.12.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true

  assets:
    - assets/images/
    - assets/fonts/
EOL

# Sample content for lib/main.dart file
cat <<EOL > $PROJECT_ROOT/lib/main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to My Flutter App'),
      ),
      body: Center(
        child: Text('Hello, world!'),
      ),
    );
  }
}
EOL

# Create install.sh script
cat <<EOL > $PROJECT_ROOT/install.sh
#!/bin/bash
# Ensure flutter is installed
if ! command -v flutter &> /dev/null
then
    echo "Flutter could not be found, please install it first."
    exit
fi

# Install dependencies
flutter pub get

echo "Dependencies installed."
EOL

# Make install.sh executable
chmod +x $PROJECT_ROOT/install.sh

# Create start.sh script
cat <<EOL > $PROJECT_ROOT/start.sh
#!/bin/bash
# Ensure flutter is installed
if ! command -v flutter &> /dev/null
then
    echo "Flutter could not be found, please install it first."
    exit
fi

# Run the application
flutter run
EOL

# Make start.sh executable
chmod +x $PROJECT_ROOT/start.sh

# Notify the user
echo "Project directory structure created successfully!"

