#!/bin/bash

# Define the project root directory
PROJECT_ROOT="my-rust-app"

# Create the directory structure
mkdir -p $PROJECT_ROOT/{src,tests}

# Create main files
touch $PROJECT_ROOT/{.gitignore,Cargo.toml,README.md,start.sh,install.sh}
touch $PROJECT_ROOT/src/main.rs

# Sample content for .gitignore file
cat <<EOL > $PROJECT_ROOT/.gitignore
/target
**/*.rs.bk
Cargo.lock
EOL

# Detailed content for README.md file
cat <<EOL > $PROJECT_ROOT/README.md
# My Rust App

This is a Rust project.

## Directory Structure

\`\`\`
my-rust-app/
├── src/
│   └── main.rs
├── tests/
├── .gitignore
├── Cargo.toml
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

- **src/**: Source code.
  - **main.rs**: Main application file.
- **tests/**: Test files.

## Basic Commands

- **Build the application**:
    ```sh
    cargo build
    ```
- **Run the application**:
    ```sh
    ./start.sh
    ```
- **Run tests**:
    ```sh
    cargo test
    ```

## Creating a New Module

1. **Create a new module file in \`src\`**.
2. **Define module functions and logic**.
3. **Import and use the module in \`main.rs\`**.

For more detailed instructions, refer to the [Rust documentation](https://doc.rust-lang.org/).
EOL

# Sample content for Cargo.toml file
cat <<EOL > $PROJECT_ROOT/Cargo.toml
[package]
name = "my-rust-app"
version = "0.1.0"
edition = "2018"

[dependencies]
EOL

# Sample content for src/main.rs file
cat <<EOL > $PROJECT_ROOT/src/main.rs
fn main() {
    println!("Hello, world!");
}
EOL

# Create install.sh script
cat <<EOL > $PROJECT_ROOT/install.sh
#!/bin/bash
# Ensure cargo is installed
if ! command -v cargo &> /dev/null
then
    echo "Cargo could not be found, please install Rust and Cargo first."
    exit
fi

# Build the project
cargo build

echo "Project built successfully."
EOL

# Make install.sh executable
chmod +x $PROJECT_ROOT/install.sh

# Create start.sh script
cat <<EOL > $PROJECT_ROOT/start.sh
#!/bin/bash
# Ensure cargo is installed
if ! command -v cargo &> /dev/null
then
    echo "Cargo could not be found, please install Rust and Cargo first."
    exit
fi

# Run the application
cargo run
EOL

# Make start.sh executable
chmod +x $PROJECT_ROOT/start.sh

# Notify the user
echo "Project directory structure created successfully!"

