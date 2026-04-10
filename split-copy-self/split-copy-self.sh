#!/bin/bash

# I split myself

set -euo pipefail   # Exit on error, undefined variable, or pipe failure
IFS=$'\n\t'         # Safe Internal Field Separator (handles filenames with spaces)

# ---- Metadata & Constants ---------------------------------------------------
readonly VERSION="1.0.0"
readonly CHUNKSIZE=1
readonly OUTPREFIX=xx

# ---- Configuration (Environment variables with defaults) --------------------
LOG_LEVEL="${LOG_LEVEL:-INFO}"
readonly CONFIG_FILE="${CONFIG_FILE:-$HOME/.config/myscript.conf}"

# ---- Help / Usage Function --------------------------------------------------
usage() {
    cat <<EOF
Usage: $SCRIPT_NAME 

It splits itself and puts itself back together for my amusement.

Options:
    -h, --help      Show this help message and exit

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



    # ---- Create Temporary Workspace -----------------------------------------
    TEMP_DIR="$(mktemp -d)"
    log_debug "Created temporary directory: $TEMP_DIR"

    # ---- Core Business Logic ------------------------------------------------
    log_info "Processing 'self'..."
    
    csplit "$0" "$CHUNKSIZE"

    cat "$OUTPREFIX"* > "$0.copy"
    rm "$OUTPREFIX"*

   

    log_info "Script completed successfully."
}

# ---- Entry Point ------------------------------------------------------------
main "$@"