#!/bin/bash

# Define the project root directory
PROJECT_ROOT="my-clutter-app"

# Create the directory structure
mkdir -p $PROJECT_ROOT/{src,assets,tests}

# Create main files
touch $PROJECT_ROOT/{.gitignore,README.md,install.sh,start.sh,Makefile}
touch $PROJECT_ROOT/src/main.c

# Sample content for .gitignore file
cat <<EOL > $PROJECT_ROOT/.gitignore
*.o
*.a
*.so
*.dylib
*.exe
*.log
build/
EOL

# Detailed content for README.md file
cat <<EOL > $PROJECT_ROOT/README.md
# My Clutter App

This is a Clutter project.

## Directory Structure

\`\`\`
my-clutter-app/
├── src/
│   └── main.c
├── assets/
├── tests/
├── .gitignore
├── Makefile
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

- **src/**: Source code.
  - **main.c**: Main application file.
- **assets/**: Static assets (images, fonts).
- **tests/**: Test files.

## Basic Commands

- **Build the application**:
    ```sh
    make
    ```
- **Run the application**:
    ```sh
    ./start.sh
    ```
- **Run tests**:
    ```sh
    # Implement your tests here
    ```

## Creating a New Module

1. **Create a new source file in \`src\`**.
2. **Define module functions and logic**.
3. **Include and use the module in \`main.c\`**.

For more detailed instructions, refer to the [Clutter documentation](https://developer.gnome.org/clutter/).
EOL

# Sample content for Makefile
cat <<EOL > $PROJECT_ROOT/Makefile
CC=gcc
CFLAGS=-Wall -g
LDFLAGS=`pkg-config --cflags --libs clutter-1.0`
SOURCES=src/main.c
EXECUTABLE=my_clutter_app

all: \$(EXECUTABLE)

\$(EXECUTABLE): \$(SOURCES)
	\$(CC) \$(CFLAGS) -o \$@ \$^ \$(LDFLAGS)

clean:
	rm -f \$(EXECUTABLE) *.o
EOL

# Sample content for src/main.c file
cat <<EOL > $PROJECT_ROOT/src/main.c
#include <clutter/clutter.h>

static void on_stage_click(ClutterActor *actor, ClutterEvent *event, gpointer data) {
    g_print("Stage clicked!\n");
}

int main(int argc, char *argv[]) {
    ClutterActor *stage;

    if (clutter_init(&argc, &argv) != CLUTTER_INIT_SUCCESS)
        return 1;

    stage = clutter_stage_new();
    clutter_stage_set_title(CLUTTER_STAGE(stage), "My Clutter App");
    clutter_actor_set_size(stage, 800, 600);
    g_signal_connect(stage, "button-press-event", G_CALLBACK(on_stage_click), NULL);
    clutter_actor_show(stage);

    clutter_main();

    return 0;
}
EOL

# Create install.sh script
cat <<EOL > $PROJECT_ROOT/install.sh
#!/bin/bash
# Ensure required packages are installed
if ! dpkg -s libclutter-1.0-dev &> /dev/null; then
    echo "libclutter-1.0-dev not found, installing..."
    sudo apt-get update
    sudo apt-get install -y libclutter-1.0-dev
fi

echo "All dependencies are installed."
EOL

# Make install.sh executable
chmod +x $PROJECT_ROOT/install.sh

# Create start.sh script
cat <<EOL > $PROJECT_ROOT/start.sh
#!/bin/bash
# Build the project
make

# Run the application
./my_clutter_app
EOL

# Make start.sh executable
chmod +x $PROJECT_ROOT/start.sh

# Notify the user
echo "Project directory structure created successfully!"

