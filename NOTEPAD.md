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
