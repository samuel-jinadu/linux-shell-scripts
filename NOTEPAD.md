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
