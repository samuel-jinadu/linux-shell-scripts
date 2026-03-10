# Linux Shell Scripts

A collection of shell scripting exercises and projects completed as part of [The Shell Scripting Tutorial](https://www.shellscript.sh/).

## Overview

This repository contains various shell scripts demonstrating fundamental and intermediate shell scripting concepts, including variables, functions, loops, conditionals, and practical applications.

## Scripts

### Core Concepts

- **`first.sh`** - A basic introductory script demonstrating shell script basics
- **`var2.sh`** - Variable declaration and usage examples
- **`var3.sh`** - Advanced variable handling and default values
- **`default-value.sh`** - Demonstrating default parameter values

### Control Flow

- **`test.sh`** - Conditional testing and branching logic
- **`test1.5.sh`** - Additional test conditional examples
- **`test2.sh`** - Further conditional demonstrations
- **`while.sh`** - Basic while loop implementation
- **`while3.sh`** - Advanced while loop examples

### Functions & Procedures

- **`function.sh`** - Function definition and calling mechanisms
- **`shift.sh`** - Handling positional parameters with shift

### Advanced Topics

- **`internal-field-seperator.sh`** - Working with the IFS (Internal Field Separator) variable
- **`external-commands.sh`** - Executing external commands from shell scripts
- **`find-syntax.sh`** - Using the find command within scripts

### Practical Applications

- **`talk.sh`** - Interactive dialogue script
- **`address-book.sh`** - A practical address book application with persistent storage (`address-book.txt`)
- **`factorial.sh`** - Mathematical computation using recursion

### Libraries & Utilities

- **`common.lib`** - Reusable shell library with common functions
- **`lib-test.sh`** - Testing script for the common library

### Supporting Files

- **`address-book.txt`** - Data file for the address book application
- **`myfile.txt`** - Test data file
- **`dump-bash.txt`** - Bash reference documentation

## Getting Started

To run any of these scripts:

```bash
bash script-name.sh
# or if executable:
./script-name.sh
```

Some scripts may require make the file executable first:

```bash
chmod +x script-name.sh
```

## Purpose

These scripts were created for educational purposes to master shell scripting concepts and techniques. Each script focuses on specific programming constructs and patterns commonly used in bash/sh scripting.

## Resources

- [The Shell Scripting Tutorial](https://www.shellscript.sh/) - The primary learning resource used for this repository

## Notes

- Scripts are primarily for educational purposes and may need modification for production use
- The address book application demonstrates practical data persistence and menu-driven interfaces

---

**Author**: samuel-jinadu  
**Last Updated**: 2026-03-08
