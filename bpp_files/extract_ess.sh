#!/usr/bin/env bash
#
# extract_ess.sh - Extract the ESS* column from the BPP MCMC parameter
#                   summary table (the one whose header contains
#                   "param  mean  median  S.D  min  max  2.5%  97.5%
#                    2.5%HPD  97.5%HPD  ESS*  Eff*  rho1").
#
# The number of parameter rows in that table varies from run to run
# (it depends on how many thetas/taus were estimated, and whether an
# lnL row is present), so this script does NOT assume a fixed number
# of lines. Instead it:
#   1. Locates the header line by its distinctive set of column names.
#   2. Works out which column ESS* actually is (in case column order
#      or spacing ever changes).
#   3. Reads rows after the header/dashed-separator line until a row
#      no longer looks like a data row (blank line followed by
#      non-table text, a new header, or a line with too few fields),
#      at which point it stops collecting for that table.
#   4. Restarts if another matching table appears later in the file.
#
# The BPP log can also contain "\r"-terminated progress lines (used to
# redraw a line in a live terminal). Those are normalized to real
# newlines first so every logical line is handled correctly.
#
# Usage:
#   ./extract_ess.sh <bpp_output_file> [more files...]
#
# Output (tab-separated) to stdout:
#   param   ESS*
#   theta:6 2804.802290
#   theta:7 3368.658043
#   ...
#
# In addition, if any ESS* value in a file is below 200 (a commonly
# used rule-of-thumb threshold for adequate MCMC mixing), the name of
# that file is printed as a warning (to stderr) after its table is
# shown, e.g.:
#   WARNING: ESS* < 200 found in outBpp

set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <bpp_output_file> [more files...]" >&2
    exit 1
fi

for infile in "$@"; do
    if [[ ! -f "$infile" ]]; then
        echo "Error: file not found: $infile" >&2
        exit 1
    fi

    # Normalize lone \r (used for in-place progress updates) to \n so
    # every visual line is a real awk record, then extract the ESS*
    # column from the target table.
    tr '\r' '\n' < "$infile" | awk -v fname="$infile" -v threshold=200 '
        BEGIN {
            in_table = 0
            just_saw_header = 0
            ess_col = 0
            low_found = 0
        }

        # 1) Detect the header line of the table we want, by requiring
        #    all of its distinctive column names to be present.
        /param/ && /mean/ && /median/ && /S\.D/ && /ESS\*/ && /Eff\*/ && /rho1/ {
            ess_col = 0
            for (i = 1; i <= NF; i++) {
                if ($i == "ESS*") { ess_col = i; break }
            }
            in_table = (ess_col > 0)
            just_saw_header = 1
            next
        }

        # 2) Skip the dashed separator line that immediately follows
        #    the header (e.g. "----...----").
        in_table && just_saw_header {
            just_saw_header = 0
            if ($0 ~ /^-+[[:space:]]*$/) next
            # fall through in case there was no dashed line, in case
            # formatting ever changes
        }

        # 3) While inside the table, collect data rows.
        in_table {
            # Blank lines can appear inside the table (e.g. before the
            # trailing lnL row) - skip over them but stay "in_table".
            if ($0 ~ /^[[:space:]]*$/) next

            # A different header line (e.g. the later, unrelated
            # "Effu Effy c" summary table) means this table has ended.
            if ($0 ~ /param/ && $0 ~ /mean/) {
                in_table = 0
                # Re-check this line in case it is actually another
                # copy of our target header (multi-run logs).
                if ($0 ~ /ESS\*/ && $0 ~ /Eff\*/ && $0 ~ /rho1/) {
                    ess_col = 0
                    for (i = 1; i <= NF; i++) {
                        if ($i == "ESS*") { ess_col = i; break }
                    }
                    in_table = (ess_col > 0)
                    just_saw_header = 1
                }
                next
            }

            # A proper data row must have at least as many fields as
            # the ESS* column index; otherwise assume the table ended
            # (e.g. we hit trailing prose like "FigTree tree is in...").
            if (NF >= ess_col) {
                print $1 "\t" $ess_col
                if ($ess_col + 0 < threshold) low_found = 1
            } else {
                in_table = 0
            }
            next
        }

        END {
            if (low_found) {
                print "WARNING: ESS* < " threshold " found in " fname > "/dev/stderr"
            }
        }
    '
done
