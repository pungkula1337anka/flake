#!/bin/bash

# Define the project root directory
PROJECT_ROOT="my-dart-app"

# Create the directory structure
mkdir -p $PROJECT_ROOT/{lib,bin,tests}

# Create main files
touch $PROJECT_ROOT/{.gitignore,README.md,install.sh,start.sh}
touch $PROJECT_ROOT/pubspec.yaml
touch $PROJECT_ROOT/bin/main.dart

# Sample content for .gitignore file
cat <<EOL > $PROJECT_ROOT/.gitignore
.dart_tool/
.packages
build/
EOL

# Detailed content for README.md file
cat <<EOL > $PROJECT_ROOT/README.md
# My Dart App

This is a Dart project.

## Directory Structure

\`\`\`
my-dart-app/
├── bin/
│   └── main.dart
├── lib/
├── tests/
├── .gitignore
├── pubspec.yaml
├── install.sh
├── start.sh
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

- **bin/**: Entry point for the application.
  - **main.dart**: Main application file.
- **lib/**: Source code libraries.
- **tests/**: Test files.

## Basic Commands

- **Run the application**:
    ```sh
    ./start.sh
    ```
- **Run tests**:
    ```sh
    dart test
    ```

## Creating a New Library

1. **Create a new Dart file in \`lib\`**.
2. **Define library functions and logic**.
3. **Import and use the library in \`main.dart\`**.

For more detailed instructions, refer to the [Dart documentation](https://dart.dev/guides).
EOL

# Sample content for pubspec.yaml file
cat <<EOL > $PROJECT_ROOT/pubspec.yaml
name: my_dart_app
description: A new Dart project.

environment:
  sdk: ">=2.12.0 <3.0.0"

dependencies:
  path: ^1.8.0

dev_dependencies:
  test: ^1.16.0
EOL

# Sample content for bin/main.dart file
cat <<EOL > $PROJECT_ROOT/bin/main.dart
import 'dart:io';

void main() {
  print('Hello, Dart!');
}
EOL

# Create install.sh script
cat <<EOL > $PROJECT_ROOT/install.sh
#!/bin/bash
# Ensure dart is installed
if ! command -v dart &> /dev/null
then
    echo "Dart could not be found, please install Dart SDK first."
    exit
fi

# Get dependencies
dart pub get

echo "Dependencies installed."
EOL

# Make install.sh executable
chmod +x $PROJECT_ROOT/install.sh

# Create start.sh script
cat <<EOL > $PROJECT_ROOT/start.sh
#!/bin/bash
# Ensure dart is installed
if ! command -v dart &> /dev/null
then
    echo "Dart could not be found, please install Dart SDK first."
    exit
fi

# Run the application
dart run bin/main.dart
EOL

# Make start.sh executable
chmod +x $PROJECT_ROOT/start.sh

# Notify the user
echo "Project directory structure created successfully!"

