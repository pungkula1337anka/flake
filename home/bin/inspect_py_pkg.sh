#!/bin/bash

# Prompt the user for the package name
read -p "Enter the Python package name to inspect: " PACKAGE_NAME

# Convert the package name for importing by replacing hyphens with underscores
IMPORT_NAME=$(echo "$PACKAGE_NAME" | sed 's/-/_/g')

# Define the virtual environment directory
VENV_DIR="venv_inspect_package"

# Create a Python virtual environment
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating a virtual environment..."
    python3 -m venv $VENV_DIR
else
    echo "Virtual environment already exists."
fi

# Activate the virtual environment
. $VENV_DIR/bin/activate

# Check if the package is installed
if ! python3 -c "import $IMPORT_NAME" &> /dev/null; then
    echo "$PACKAGE_NAME is not installed. Installing now..."
    pip install $PACKAGE_NAME
else
    echo "$PACKAGE_NAME is already installed."
fi

# Create a directory for the output if it doesn't exist
OUTPUT_DIR="package_inspection/$PACKAGE_NAME"
mkdir -p $OUTPUT_DIR

# Define the output files
CLASSES_FILE="$OUTPUT_DIR/classes.txt"
FUNCTIONS_FILE="$OUTPUT_DIR/functions.txt"
MODULES_FILE="$OUTPUT_DIR/modules.txt"
EXAMPLES_FILE="$OUTPUT_DIR/examples.txt"  # Placeholder for examples you might want to add manually

# Clear previous output files if they exist
> $CLASSES_FILE
> $FUNCTIONS_FILE
> $MODULES_FILE
> $EXAMPLES_FILE

# Generate a list of all classes, functions, and modules
echo "Collecting information about $PACKAGE_NAME..."

python3 -c "
import pkgutil
import importlib
import sys

sys.setrecursionlimit(500)  # Limit the maximum recursion depth

def list_module_contents(module, indent=0, visited=None):
    if visited is None:
        visited = set()
    if id(module) in visited:
        return  # Avoid circular references
    visited.add(id(module))
    for name, obj in vars(module).items():
        if not name.startswith('_'):
            if isinstance(obj, type):
                print(' ' * indent + f'Class: {name}', file=open('$CLASSES_FILE', 'a'))
            elif callable(obj):
                print(' ' * indent + f'Function: {name}', file=open('$FUNCTIONS_FILE', 'a'))
            elif isinstance(obj, type(module)):
                print(' ' * indent + f'Module: {name}', file=open('$MODULES_FILE', 'a'))
                if indent < 100:  # Limit the recursion depth
                    list_module_contents(obj, indent + 4, visited)

try:
    package = importlib.import_module('$IMPORT_NAME')
    print(f'Module: $IMPORT_NAME', file=open('$MODULES_FILE', 'a'))
    list_module_contents(package)
except ModuleNotFoundError:
    print(f'Error: The module $IMPORT_NAME could not be found.', file=open('$MODULES_FILE', 'a'))
except RecursionError:
    print(f'Error: Maximum recursion depth exceeded in $IMPORT_NAME.', file=open('$MODULES_FILE', 'a'))
" 

echo "Inspection complete. Results saved to $OUTPUT_DIR."

# Deactivate the virtual environment
deactivate

