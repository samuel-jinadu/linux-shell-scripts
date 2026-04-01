
USAGE="gcd 'dividend' 'divisor'"



gcd ()
  {
    local dividend=$1 divisor=$2 remainder=1
    until [[ "$remainder" -eq 0 ]]
    do
      remainder=$(( $dividend % $divisor ))
      dividend=$divisor     # The old divisor becomes the new dividend
      divisor=$remainder    # The remainder becomes the new divisor
    done
    echo "$dividend"
  }


[[ $# -eq 2 ]] || { echo "Error: Too many arguments" >&2; exit 1; }

# Check if both arguments are integers
if ! [[ $1 =~ ^-?[0-9]+$ ]] || ! [[ $2 =~ ^-?[0-9]+$ ]]; then
    echo "Error: Both arguments must be integers." >&2
    exit 1
fi

gcd $1 $2