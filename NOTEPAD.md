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
