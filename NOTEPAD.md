# A Collection of Notes for Advanced Bash Scripting Guide
## 27th of March, 2026
- `/dev/null` ia apparently a special device file where reading from it returns nothing and writing into it discards whatever was written
    ```bash
    # Here it is used to erase the /var/log/messages file contents

    # Cleanup
    # Run as root, of course.
    cd /var/log
    cat /dev/null > messages
    cat /dev/null > wtmp
    echo "Log files cleaned up."
    ```

## 30th of March, 2026

- `tee` alows you to both print to standard output and into a file at the same time
    ```bash
    # Append to the given files, do not overwrite:
    echo "example" | tee --append path/to/file
    ```
- `${var:?message}` triggers an error if the variable is unset or empty while `${var?message}` triggers an error if the variable is unset

## 31st of March, 2026

- command `&>filename` redirects both the stdout and the stderr of command to filename.
    ```bash
    command &>/dev/null
    ```
- `&` can be use to run commands or script blocks as jobs in the backgroud, really nifty, since powershell isnt as straighforward not to talk of python
    ```bash
    { sleep 10; echo yo; } &
    ```
- `-` allows you to type in arguments after the fact, sometimes, like...
    ```bash
    file -
    # ./execution-behaviour.sh
    # /dev/stdin: ASCII text

    ```

## 1st of April, 2026
- `ls | xargs -n1 basename` - list all files in a directory in a convoluted manner, i just wanted to test how basename worked to be honest
- `select file in *; do echo $file; done` - creates an interactive menu of all files in the current directory.
The statement “Certain exit status codes have reserved meanings and should not be user-specified in a script” refers to the fact that the shell and the operating system assign special interpretations to some numeric exit values. Using them for your own purposes can lead to confusion or incorrect handling when other scripts or tools evaluate your script’s exit code.

### The reserved exit codes

| Exit Code | Meaning / Reserved For |
|-----------|------------------------|
| 0         | Success (always) |
| 1         | General error (common but not strictly reserved; safe to use) |
| 2         | **Misuse of shell builtins** (e.g., `read` with wrong arguments) – Bash uses this internally |
| 126       | Command found but not executable (e.g., permission denied) |
| 127       | Command not found (e.g., typo or missing program) |
| 128       | Invalid argument to `exit` (e.g., `exit 3.14`) |
| 128+n     | **Terminated by signal n** – For example, 130 = 128+2 (SIGINT), 137 = 128+9 (SIGKILL), etc. |
| 255       | Exit status out of range (e.g., `exit -1` wraps to 255) |

## 2nd of April 2026
- `$CDPATH` A colon‑separated list of directories that cd searches when you give a relative path (e.g., cd python).
    ``` bash
    subl ~/.bashrc # To open the .bashrc file in Sublime Text for editing

    CDPATH=".:/c/Users/Samuel/Desktop/Remote Job/practice" # added this line into the file

    source ~/.bashrc # in the terminal to reload ~/.bashrc after editing

    cd python # to test it
    ```
- `$IGNOREEOF` sets how many consecutive Ctrl+D presses the shell will ignore before actually logging you out
    ```bash
    # add this line to .bashrc
    export IGNOREEOF=3  # ignores 3 consecutive Ctrl+D before logout
    ```
- `$PROMPT_COMMAND` is an environmental variable that holds a command (or multiple commands) to run just before each prompt (`$PS1`) is displayed.
    ```bash
    show_exit() {
        local ec=$?
        if [ $ec -ne 0 ]; then
            echo -e "\033[31m[Exit: $ec]\033[0m"
        fi
    }
    PROMPT_COMMAND=show_exit
    ```

## 3rd of April, 2026
- `od -An -N1 -tu1 /dev/urandom` and `$RANDOM` produce random numbers
- `awk` is a command that uses a programming language for text processng in bash
    ```bash
    # awk 'pattern { action }' filename

    # Print the fifth column (a.k.a. field) in a space-separated file
    awk '{print $5}' path/to/file

    # Print every line that contains a word
    awk '/word/' path/to/file

    # Print the last column of each line in a file, using a comma (instead of space) as a field separator
    awk -F ',' '{print $NF}' path/to/file

    # Print every third line starting from the first line
    awk 'NR%3==1' path/to/file

    # Print different values based on conditions
    awk '{if ($1 == "foo") print "Exact match foo"; else if ($1 ~ "bar") print "Partial match bar"; else print "Baz"}' path/to/file

    # Print table of users with UID >=1000 with header and formatted output, using colon as separator
    # %-20s = 20 left-align string, %6s = 6 right-align string, %25s = 25 right-align string
    awk 'BEGIN {FS=":";printf "%-20s %6s %25s\n", "Name", "UID", "Shell"} $4 >= 1000 {printf "%-20s %6d %25s\n", $1, $4, $7}' /etc/passwd
    ```
- `${#var}` returns length of variable
- `${var%pattern}` removes from `$var` the **shortest** part of `pattern` that matches the **back end** of `$var`, while `${var#pattern}` removes the **shortest** part from the **front**.{var#Pattern}`
    ```bash
    "${file%.*}" # this was used to strip the file extension off of a filename in a script i wrote

    file="document.txt"
    ext=".${file##*.}"   # ".txt"
    ```

## 4th of April, 2026
- `For-loops`
    ```bash
    for arg in "$var1" "$var2" "$var3" ... "$varN"  
    # In pass 1 of the loop, arg = $var1        
    # In pass 2 of the loop, arg = $var2        
    # In pass 3 of the loop, arg = $var3        
    # ...
    # In pass N of the loop, arg = $varN
    # Arguments in [list] quoted to prevent possible word splitting.

    # You can also do
    for a
        do
          echo -n "$a "
        done

    # 'for a' expands into ---for a in "$@"--- 
    ```

## 5th of April, 2026
- Always use `read varname` – *no dollar sign*. The dollar sign is for expanding a variable’s value; `read` needs the name to assign to

## 7th of April, 2026
- `while read` vs `mapfile`
    ```bash
    # best for dealing with large files, piping and singular processing of each line
    while IFS= read -r line; do
        if [[ "$line" == "STOP" ]]; then break; fi
        echo "$line"
    done < file.txt

    # best for deaing with small files, random access, etc.
    mapfile -t lines < data.txt
    for line in ${lines[@]}; do
        # do something
    done
    ```
- `IFS=$' \t\n'` Internal Field Seperator is actually space, tab, and a new line
- `printf` is a **built‑in command** that interprets a format string and then prints arguments according to that format.

    ```bash
    printf FORMAT [ARGUMENTS...]
    ```
    - `FORMAT` is a string containing **plain text** and **format specifiers** (like `%s`, `%d`, `%f`, `%x`, etc.).
    - `printf` reads the format string left to right.
    - When it hits a format specifier, it consumes one argument from the list, formats it according to the specifier, and prints it.
    - Plain text is printed as‑is.
    - After processing all format specifiers, if there are more arguments than specifiers, the format is **reused** (cycled) until all arguments are consumed.

    | Specifier | Meaning                         | Example               |
    |-----------|---------------------------------|-----------------------|
    | `%s`      | String                          | `printf "%s\n" "hi"`  |
    | `%d`      | Signed decimal integer          | `printf "%d\n" 42`    |
    | `%c`      | First character of argument     | `printf "%c\n" "abc"` → `a` |
    | `%%`      | Literal percent sign            | `printf "%%\n"` → `%` |

    You can add modifiers:
    - `%10s` → right‑align in 10 columns
    - `%-10s` → left‑align
    - `%.2f` → 2 decimal places
    - `%5.2f` → width 5, precision 2

    Example:
    ```bash
    printf "|%10s|%-10s|\n" "hello" "world"
    # |     hello|world     |
    ```

## 8th of April, 2026
- `readonly` is used for making constants
    ```bash
    # Option 1: Set value and lock in one step
    readonly VAR_NAME="value"

    # Option 2: Lock an existing variable
    existing_var="hello"
    readonly existing_var

    # Multiple at once
    readonly VAR1="foo" VAR2="bar"
    ```
- `getopts`
    ```bash
    while getopts ":ab:c" opt; do
        case $opt in
            a) echo "Option -a" ;;
            b) echo "Option -b with arg: $OPTARG" ;;
            c) echo "Option -c" ;;
            \?) echo "Invalid option: -$OPTARG" ;;
            :)  echo "Option -$OPTARG requires an argument." ;;
        esac
    done
    shift $((OPTIND - 1))   # Remove parsed options, leaving positional args
    ```
- `exec` can both be used to redirect streams and replace the current process with another using a command
```bash
exec sleep 2 # run sleep or whatever command or script placed there and exits when that script is done as if the command or script had replaced the current process

exec &> "/tmp/mylog.log" # redirected standard output and tandard error to log file but continues with script rather than exiting

```

- Working with Jobs

    | Notation | Meaning | Example |
    |----------|---------|---------|
    | `%N` | Job number `N` (the number shown in `jobs` output) | `fg %1` brings job 1 to the foreground |
    | `%S` | Job whose command line **starts with** string `S` | `kill %vim` kills the most recent job starting with `vim` |
    | `%?S` | Job whose command line **contains** string `S` | `fg %?python` brings forward a job that has "python" anywhere in its command |
    | `%%` or `%+` | The **current** job (last one stopped or started in background) | `fg %%` brings the most recent job to foreground |
    | `%-` | The **previous** job (the one before the current job) | `fg %-` brings the second‑most recent job |
    | `$!` | Process ID (PID) of the **last background process** (not a job specifier, but a variable) | `kill $!` kills the last process sent to background |

## 9th of April, 2026
- `cat` concatenates files or lists a file to standard output. `-n` option inserts consecutive numbers, `tac` does the same but from the end to beginning rather than beginning to end
    ```bash
    cat file1 file2 file3 > file123
    ```
- Using the `-exec` flag with `find` allows you to run a command on each file matched
    ```bash
    find . -name "*.txt" -exec rm {} \; # {} substitutes the full path of the selected flle
    find . -name "*.txt" -exec rm {} + # This version runs the command in batches but only works for commands that run on multiple fies at once
    ```
- A code snippet for running commands in parallel or something like that
    ```bash
    printf '%s\0' *.pdf | xargs -0 -n 1 -P "$NUM_CORES" bash -c 'command "$1"' _
    ```
- A code snippet fo detemining the amount of core a systme has from script
    ```bash
    # Automatically detect cores (works on Linux, macOS, Git Bash/Windows)
    export NUM_CORES=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)
    ```
-  `cp -u` command, short for `--update`, copies files based on a timestamp comparison
- `uniq` does not detect all duplicates; it only detects adjacent duplicates. `sort -u file` basically does the same thing anyways although `uniq` has some useful options
    ```bash
    # Showing Only Unique Lines (-u): This is the opposite of -d. It prints only the lines that appear exactly once in the adjacent sequence.
    sort file.txt | uniq -u

    # Showing Only Duplicate Lines (-d): This flag tells uniq to only output lines that appear more than once in a sequence. It's a quick way to find redundant entries.
    sort file.txt | uniq -d

    # Counting Occurrences (-c): This is uniq's most powerful feature. It counts how many times each line appears consecutively and prefixes the line with that count.
    sort file.txt | uniq -c

    ```
- `cut` is a command used for extracting fields from files or piped text
    ```bash
    cut -d ":" -f file # -d is for delimiter and -f is the field e.g. -f1,2,20

    text-command | cut -c # -c is for character e.g. -c10-80
    ```
- `paste` is a tool for merging together different files into a single, multi-column file. In combination with `cut`,
useful for creating system log files
- `head` and `tail` lists the beginning and end of files with the amount of char changeabe with the `-c` option and number of lines changeable with the `-n` option e.g. `head -n10 .gitignore` for first 10 lines 
    ```bash
    # the -f follow flag allows you to monitor the file for changes and yes, it will interrupt  unless run in the background
    tail -f /var/log/syslog 

    ```
- `grep` - Global Regular Expression Print
    ```bash
    # grep [OPTIONS] PATTERN [FILE...]

    # ----- BASIC SYNTAX -----
    grep "error" logfile.txt               # Search for "error"
    grep "error" *.log                     # Search in multiple files
    command | grep "error"                 # Filter command output

    # ----- PRACTICAL PIPELINE EXAMPLES -----
    ps aux | grep "python" | grep -v "grep"                # Find Python processes, exclude grep itself
    grep -r --include="*.js" "console.log" ./src/          # Recursive search only in .js files
    grep -l "TODO" * | xargs grep -n "FIXME"               # Files with TODO, then search for FIXME in them
    history | grep "git commit" | wc -l                    # Count how many git commits you've made
    grep -oE "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}" emails.txt   # Extract email addresses
    ```
- `wc` gives a "word count" on a file or I/O stream:
    ```bash
    wc -w # gives only the word count.
    wc -l # gives only the line count.
    wc -c # gives only the byte count.
    wc -m # gives only the character count.
    wc -L # gives only the length of the longest line
    ```
- `tr` is **find and replace** for characters. It also has `-d` option for deleting characters and a `-s` option for replacing consecutive repeated characters with a single occurence
    ```bash
    echo "hello" | tr 'a-z' 'A-Z' # with piping

    tr 'a-z' 'A-Z' < input.txt > output.txt # with standard input

    tr 'a-z' 'A-Z' myfile.txt   # WRONG! tr ignores 'myfile.txt' and just sits waiting for keyboard input.
    ```
- `fold` will brutally split a word in half. Once the character limit is reached, it inserts a newline immediately, even if it's in the middle of a word. `fmt` will not split words. It uses a "greedy" algorithm to pack as many words as possible onto a line. If the next word would exceed the limit, `fmt` moves the entire word to the next line, preserving the word's integrity.
- `--` tells the command: "Stop parsing any more arguments as options or flags. Everything after this is a plain argument (like filenames or directory paths), even if it starts with a hyphen (-)."
    ```bash
    mv -- -file.txt destination/
    ```

## 10th of April, 2026
- `file` determines the type of a file by examining its content (magic numbers) rather than its name or extension
    ```bash
    file path/to/file

    # Get just the type, no filename, and as a MIME string
    file -b -i dump-bash.txt
    ```
- What a professional script looks like
    ```bash
    #!/usr/bin/env bash
    # ------------------------------------------------------------------------------
    # Professional Bash Script Template
    # ------------------------------------------------------------------------------
    # Best practices for robust, maintainable, and portable scripts.
    # ------------------------------------------------------------------------------

    # ---- Strict Mode (Catch errors early) ---------------------------------------
    set -euo pipefail   # Exit on error, undefined variable, or pipe failure
    IFS=$'\n\t'         # Safe Internal Field Separator (handles filenames with spaces)

    # ---- Metadata & Constants ---------------------------------------------------
    readonly SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
    readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    readonly VERSION="1.0.0"

    # ---- Configuration (Environment variables with defaults) --------------------
    LOG_LEVEL="${LOG_LEVEL:-INFO}"
    readonly CONFIG_FILE="${CONFIG_FILE:-$HOME/.config/myscript.conf}"

    # ---- Help / Usage Function --------------------------------------------------
    usage() {
        cat <<EOF
    Usage: $SCRIPT_NAME [OPTIONS] <required_arg>

    Description of what this script does.

    Options:
        -h, --help      Show this help message and exit
        -v, --verbose   Enable verbose output
        -o FILE         Output file path (default: stdout)

    Examples:
        $SCRIPT_NAME input.txt
        $SCRIPT_NAME -o output.txt input.txt
    EOF
        exit 0
    }

    # ---- Logging Functions (Standardised output) --------------------------------
    log_debug() { if [[ "$LOG_LEVEL" == "DEBUG" ]]; then echo "[DEBUG] $*"; fi; }
    log_info()  { if [[ "$LOG_LEVEL" =~ ^(INFO|DEBUG)$ ]]; then echo "[INFO]  $*"; fi; }
    log_warn()  { if [[ "$LOG_LEVEL" =~ ^(WARN|INFO|DEBUG)$ ]]; then echo "[WARN]  $*" >&2; fi; }
    log_error() { echo "[ERROR] $*" >&2; }

    # ---- Cleanup Function (Runs on exit, even if script fails) ------------------
    cleanup() {
        local exit_code=$?
        # Remove temporary files, kill background processes, etc.
        if [[ -n "${TEMP_DIR:-}" && -d "$TEMP_DIR" ]]; then
            rm -rf "$TEMP_DIR"
            log_debug "Removed temporary directory: $TEMP_DIR"
        fi
        exit $exit_code
    }
    trap cleanup EXIT INT TERM

    # ---- Main Logic Function ----------------------------------------------------
    main() {
        local output_file=""
        local input_arg=""

        # ---- Argument Parsing ---------------------------------------------------
        while [[ $# -gt 0 ]]; do
            case "$1" in
                -h|--help)
                    usage
                    ;;
                -v|--verbose)
                    LOG_LEVEL="DEBUG"
                    shift
                    ;;
                -o)
                    output_file="$2"
                    shift 2
                    ;;
                --)
                    shift
                    break
                    ;;
                -*)
                    log_error "Unknown option: $1"
                    usage
                    ;;
                *)
                    break
                    ;;
            esac
        done

        # ---- Validate Required Arguments ----------------------------------------
        if [[ $# -lt 1 ]]; then
            log_error "Missing required argument."
            usage
        fi
        input_arg="$1"

        # ---- Dependency Checks --------------------------------------------------
        local deps=("jq" "curl")   # List required external commands
        for cmd in "${deps[@]}"; do
            if ! command -v "$cmd" &> /dev/null; then
                log_error "Required command '$cmd' not found. Please install it."
                exit 1
            fi
        done

        # ---- Create Temporary Workspace -----------------------------------------
        TEMP_DIR="$(mktemp -d)"
        log_debug "Created temporary directory: $TEMP_DIR"

        # ---- Core Business Logic ------------------------------------------------
        log_info "Processing '$input_arg'..."

        # Example: check if input file exists
        if [[ ! -f "$input_arg" ]]; then
            log_error "Input file not found: $input_arg"
            exit 1
        fi

        # ... your actual script logic goes here ...

        # Example: write output
        if [[ -n "$output_file" ]]; then
            echo "Results for $input_arg" > "$output_file"
            log_info "Output written to: $output_file"
        else
            echo "Results for $input_arg"
        fi

        log_info "Script completed successfully."
    }

    # ---- Entry Point ------------------------------------------------------------
    main "$@"
    ```
- What professoinal filenames look like
    ```bash
    #!/usr/bin/env bash
    # ------------------------------------------------------------------------------
    # Professional Script Filename Conventions
    # ------------------------------------------------------------------------------
    # A filename is the first impression. Follow these rules for clarity, 
    # portability, and maintainability.

    # ---- 1. CASE: Lowercase Only ------------------------------------------------
    # ✅ Good: deploy-app.sh, backup-database.sh, clean-temp-files.sh
    # ❌ Bad:  DeployApp.sh, Backup-Database.SH, CleanTempFiles.sh
    #
    # Reason: Unix filesystems are case-sensitive. Lowercase prevents confusion
    # and typing errors across different OS environments (Linux vs macOS).

    # ---- 2. WORD SEPARATOR: Hyphens, Not Underscores -----------------------------
    # ✅ Good: process-logs.sh, user-create.sh, mysql-backup.sh
    # ❌ Bad:  process_logs.sh, user_create.sh, mysqlBackup.sh
    #
    # Reason: Hyphens are easier to type (no Shift key). Underscores can be
    # visually mistaken for spaces in underlined terminal links. Underscores
    # are reserved for variable names ($user_name).

    # ---- 3. EXTENSION: Use .sh (Be Explicit) ------------------------------------
    # ✅ Good: install.sh, monitor-services.sh, parse-json.sh
    # ❌ Bad:  install, monitor-services, parse-json.bash
    #
    # Reason: Editors rely on extensions for syntax highlighting. While Linux
    # doesn't require an extension, humans do. Using .sh tells the world this is a
    # Bourne-family shell script.

    # ---- 4. LENGTH: Descriptive but Brief ---------------------------------------
    # ✅ Good: sync-s3-bucket.sh
    # ❌ Bad:  do_the_thing_that_syncs_files_to_amazon_s3_bucket_v2_final.sh
    # ❌ Bad:  s.sh
    #
    # Reason: The filename should hint at the script's purpose at a glance in
    # `ls -l` output. Aim for 3-5 words max.

    # ---- 5. VERSIONING: Avoid Filenames, Use Git Tags ---------------------------
    # ❌ Bad:  deploy-v1.sh, deploy-old.sh, deploy-2024-01-01.sh
    # ✅ Good: deploy.sh (and use `git tag v1.0.0` to track versions)
    #
    # Reason: Versioned filenames clutter directories and make it hard to find
    # the "current" version. Let version control manage history.

    # ---- 6. TEMPORARY/BACKUP FILES: Use Extensions, Not Prefixes -----------------
    # ✅ Good: script.sh.bak, config.conf.2024-01-01
    # ❌ Bad:  old_script.sh, #script.sh#, .script.sh.swp
    #
    # Reason: Keeping the base name first groups related files together in `ls`
    # output. The extension describes the file's *status*, not its *type*.

    # ------------------------------------------------------------------------------
    # TEMPLATE: The Ideal Filename Structure
    # ------------------------------------------------------------------------------
    # [action]-[target]-[optional-descriptor].sh
    #
    # Examples:
    #   - start-web-server.sh        (Action: start, Target: web-server)
    #   - backup-mysql-daily.sh      (Action: backup, Target: mysql, Descriptor: daily)
    #   - validate-yaml-syntax.sh    (Action: validate, Target: yaml, Descriptor: syntax)

    # ------------------------------------------------------------------------------
    # REAL-WORLD EXAMPLES (Good vs. Bad)
    # ------------------------------------------------------------------------------
    # ✅  deploy.sh
    # ✅  archive-logs.sh
    # ✅  check-disk-usage.sh
    # ✅  rotate-ssl-certs.sh
    #
    # ❌  Deploy_Script_1.0.sh
    # ❌  s.sh
    # ❌  do-backup
    # ❌  myscript.bash

    # ------------------------------------------------------------------------------
    # SPECIAL CASES
    # ------------------------------------------------------------------------------
    # 1. LIBRARY FILES (Sourced, not executed):
    #    Use .sh suffix but place in `lib/` or use `.lib` suffix.
    #    Example: `logging.lib`, `db-utils.sh`
    #
    # 2. CONFIG FILES:
    #    Use .conf or .cfg. Match the script name for clarity.
    #    Example: `backup-mysql.conf` paired with `backup-mysql.sh`
    #
    # 3. SCRIPTS IN $PATH (System-wide commands):
    #    Drop the .sh extension entirely if the script is meant to be a general
    #    command like `git` or `docker`.
    #    Example: `/usr/local/bin/deploy-cluster`
    ```

## 11th of April, 2026
- A **collision** in the *checksum* world is when two completely different files produce the exact same checksum number.

## 13th of April, 2026
- Improved `bc` function
    ```bash
    # Add this to ~/.bashrc, then run "source ~/.bashrc"
    calc() {
        echo "scale=4; $*" | bc -l | sed 's/\.0*$//'
    }
    ```

## 14th of April, 2026
- Here document syntax
    ```bash
    # Used to feed a multi-line block of text as input to a command.

    # Basic syntax:
    # command << DELIMITER
    #   line 1
    #   line 2
    # DELIMITER

    # Example 1: Simple cat
    cat << EOF
    Hello, this is a here document.
    It can contain multiple lines.
    EOF

    # Example 2: Indented with tabs (<<-) – leading tabs are stripped
    cat <<- EOF
        This line starts with a tab (will be stripped).
        Another tabbed line.
    EOF

    # Example 4: Allow expansions (default)
    name="Alice"
    cat << EOF
    Hello $name, today is $(date +%A).
    EOF

    # Example 5: Redirect output to a file
    cat << EOF > output.txt
    This goes into output.txt
    Second line.
    EOF

    # Example 6: Append to a file
    cat << EOF >> log.txt
    Appending this line.
    EOF

    # Notes:
    # - The delimiter (EOF, END, etc.) must appear alone on a line (no leading/trailing spaces unless using <<- and tabs).
    # - Standard delimiter is EOF, but any word works.
    # - <<- strips only leading TAB characters (not spaces) – useful for indented scripts.
    ```
- Here string syntax
    ```bash
    # Here String Syntax in Bash
    # Syntax: command <<< "string"

    # Example 1: Pass a string as input to a command
    grep "foo" <<< "foo bar baz"   # Output: foo bar baz

    # Example 2: Assign to a variable
    read first second <<< "hello world"
    echo $first   # hello
    echo $second  # world

    # Example 3: Use with tr
    tr 'a-z' 'A-Z' <<< "hello"   # HELLO

    # Example 4: Variable expansion
    name="Alice"
    cat <<< "Hello, $name!"       # Hello, Alice!
    ```
- The **file descriptors** for `stdin` (the keyboard), `stdout` (screen), and `stderr` (error messages outputed to the screen) are `0`, `1`, and `2`, respectively
- Redirection syntax
    ```bash
    #########################################
    #          BASH REDIRECTION             #
    #########################################

    # ---- File Descriptors ----
    # 0 = stdin   (standard input)
    # 1 = stdout  (standard output)
    # 2 = stderr  (standard error)

    # ---- Basic Redirection ----
    command > file        # redirect stdout to file (overwrite)
    command >> file       # redirect stdout to file (append)
    command < file        # redirect stdin from file
    command < file > out  # stdin from file, stdout to out

    # ---- Redirecting Specific FDs ----
    command 2> err.log    # redirect stderr to err.log
    command 1> out 2> err # stdout to out, stderr to err
    command &> all.log    # both stdout & stderr to all.log (bash)
    command > all.log 2>&1 # same as above (POSIX)
    command 2>&1 > out    # WRONG: stderr goes to old stdout
    # Correct order:      command > out 2>&1

    # ---- Append with Specific FDs ----
    command >> out 2>> err

    # ---- Discard Output ----
    command > /dev/null 2>&1   # silence all output
    command 2> /dev/null       # discard stderr only

    # ---- Closing File Descriptors ----
    command 2>&-           # close stderr, apparently this will prevent errors from been outputed or recorded anywhere for that process

    ```

## 15th of April, 2026
- How to **redirect keyboard presses** into a file using `/dev/tty` which is a device fle that stores keyboard input
    ```bash
    cat /dev/tty > keystrokes.log # but you won't be able to see what you're typing on the terminal anymore

    cat /dev/tty | tee keystrokes.log # redirects keystrokes to both the terminal and the log file so yo can still see what you're typng
    ```
- How `/dev/tty` works
    ```
    [Keyboard]
        ↓ (Scan codes)
    [Terminal Driver / TTY]  <--- This is the "Terminal Device" (/dev/tty)
        |
        |---(Echo)-----------------------> [Screen]  (Shows 'l', 's' as you type)
        |
        |---(Input Buffer)---stdin(0)---> [Bash Shell]
                                          |
                                          |---stdout(1)--> [Terminal Driver] → [Screen]
                                          |---stderr(2)--> [Terminal Driver] → [Screen]
    ```
- A **file descriptor** (FD) is an integer that the *operating system* uses as a handle to an open file or I/O stream.
- Using `exec` for redirection
    ```bash
    # ---- Redirect all subsequent output ----
    exec > out.log 2>&1        # whole script output goes to out.log

    # ---- Save and restore original FDs ----
    exec 3>&1                  # save current stdout to FD 3
    exec > file                # redirect stdout to file
    # ... do work ...
    exec 1>&3                  # restore stdout from FD 3
    exec 3>&-                  # close FD 3

    # ---- Open custom FD for reading/writing ----
    exec 3< input.txt          # open FD 3 for reading
    read -u 3 line             # read first line from FD 3
    exec 3<&-                  # close read FD

    exec 4> output.txt         # open FD 4 for writing
    echo "log" >&4             # write to FD 4
    exec 4>&-                  # close write FD
    ```
- Redirectng code blocks
    ```bash
    # ---- Group Commands with { } ----
    { echo "line1"; echo "line2"; } > out.txt       # redirect all stdout

    # Note: space after { and ; before } required:
    { command; } 2> err.log                         # correct
    { command } 2> err.log                          # WRONG (missing ;)

    # ---- Subshell with ( ) ----
    ( cd /tmp; ls; ) > listing.txt                  # runs in subshell, cwd unchanged

    # ---- Combine stdout and stderr for block ----
    { cmd1; cmd2; } &> combined.log                 # bash shortcut
    { cmd1; cmd2; } > all.log 2>&1                  # POSIX

    # ---- Append from block ----
    { date; uptime; } >> status.log

    # ---- Pipe block output ----
    { echo "Header"; cat data; } | grep "pattern"

    # ---- Use with while/for loops ----
    while read line; do echo "$line"; done < input.txt > output.txt

    # ---- Redirect file descriptor inside block ----
    {
        echo "stdout"
        echo "stderr" >&2
    } 2> err.log                                     # stderr to err.log

    # ---- Common use: logging function output ----
    log_block() {
        {
            echo "=== $1 ==="
            "$@"
        } >> /var/log/script.log 2>&1
    }
    ```
- A `subshell` is a **child process** launched by a *shell* (or shell script)
    ```bash
    # ---- Create a subshell with ( ) ----
    ( cd /tmp; touch file )      # cwd change does not affect parent
    pwd                          # still original directory

    # ---- Variable changes are local to subshell ----
    var=10
    ( var=20; echo "inside: $var" )   # prints 20
    echo "outside: $var"              # prints 10

    # ---- Capture output of subshell ----
    result=$( (echo "Hello"; date) )
    echo "$result"

    # ---- Redirect entire subshell output ----
    ( cmd1; cmd2; ) > out.log 2>&1

    # ---- Run commands in background ----
    ( sleep 5; echo "done" ) &     # background subshell

    # ---- Pipe from/to subshell ----
    ( echo "Header"; cat file ) | grep "pattern"
    echo "input" | ( read val; echo "$val" )

    # ---- Use subshell to isolate environment ----
    ( export PATH="/custom:$PATH"; ./script.sh )

    # ---- Explicit subshell with 'bash -c' ----
    bash -c 'cd /tmp && ls'        # starts new bash process
    ```
- In general, an `external command` in a script forks off a **subprocess**, whereas a Bash *builtin* does not. For this reason, *builtins* execute more quickly and use fewer system resources than their `external command` equivalents
- The **scope of a variable** is the context in which it has a value that can be referenced
- Directory changes made in a `subshell` do not carry over to the *parent shell*.
- **Lockfiles** are simple files used to prevent multiple instances of a script or process from running simultaneously. They act as a flag: the script creates a lockfile when it starts and removes it when it finishes. If another instance sees the lockfile already exists, it exits or waits.
    ```bash
    # Basic lockfile pattern
    LOCKFILE="/tmp/myscript.lock"

    # Try to create lockfile atomically
    if [ -e "$LOCKFILE" ]; then
        echo "Already running. Exiting."
        exit 1
    fi

    trap 'rm -f "$LOCKFILE"' EXIT   # Always remove on exit
    touch "$LOCKFILE"               # Create lock

    # ... main script work ...
    ```
- The `set -C` (or `set -o noclobber`) prevents `>` from overwriting an existing file. 
    ```bash
    if (set -C; : > lock_file) 2> /dev/null; then
        # lock created successfully (file didn't exist)
        echo "Running script..."
        rm -f lock_file  # clean up
    else
        echo "Already running."
        exit 65
    fi
    ```
## 16th of April, 2026
- **Process substituition**: replaces `<(command)` or `>(command)` with a temporary file descriptor path (e.g., /dev/fd/63) that represents the stdin/stdout of the enclosed command.
    ```
        <(command)   →   Creates a readable file containing the output of `command`.
        >(command)   →   Creates a writable file that feeds data into `command`'s stdin.
    ```
- The point is to bypass the need for temporary disk files by allowing commands that expect
    filename arguments to interact directly with pipeline data streams.
- Critical Distinctions:
    - `command1 <(command2)` : Works. `command1` reads the fake file as input.
    - `command1 > >(command2)` : Works. Shell redirects `command1`'s stdout into the fake file, which pipes to `command2`'s stdin.
    - `command1 >(command2)` : Usually nonsense. `command1` receives the string "/dev/fd/63" as an argument and typically does nothing with it unless it specifically expects a filename argument (e.g., `tar -f` in which case `command1` will use the tmp file for whatever and `command2` will be able to use it as stdin).
- Essence: It turns a process into a file, so tools that only speak "file" can participate in pipelines without ever touching a physical disk.