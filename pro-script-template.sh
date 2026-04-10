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