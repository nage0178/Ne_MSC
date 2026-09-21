#!/usr/bin/env bash
#
# extract_ess.sh - Extract the mean, 2.5%HPD, and 97.5%HPD columns from
#                   the BPP MCMC parameter summary table (the one whose
#                   header contains "param  mean  median  S.D  min  max
#                   2.5%  97.5%  2.5%HPD  97.5%HPD  ESS*  Eff*  rho1").
#
# The number of parameter rows in that table varies from run to run
# (it depends on how many thetas/taus were estimated, and whether an
# lnL row is present), so this script does NOT assume a fixed number
# of lines. Instead it:
#   1. Locates the header line by its distinctive set of column names.
#   2. Works out which columns "mean", "2.5%HPD", and "97.5%HPD"
#      actually are (in case column order or spacing ever changes).
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
#   param     mean       2.5%HPD    97.5%HPD
#   theta:6   0.009174   0.005079   0.013399
#   theta:7   ...
#   ...

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
    # every visual line is a real awk record, then extract the mean,
    # 2.5%HPD, and 97.5%HPD columns from the target table.
    tr '\r' '\n' < "$infile" | awk -v fname="$infile" '
        BEGIN {
            in_table = 0
            just_saw_header = 0
            mean_col = 0
            lo_col = 0
            hi_col = 0
        }

        # Given a header line, work out which field numbers correspond
        # to "mean", "2.5%HPD", and "97.5%HPD".
        function find_columns() {
            mean_col = 0; lo_col = 0; hi_col = 0
            for (i = 1; i <= NF; i++) {
                if ($i == "mean")     mean_col = i
                else if ($i == "2.5%HPD")  lo_col = i
                else if ($i == "97.5%HPD") hi_col = i
            }
        }

        # 1) Detect the header line of the table we want, by requiring
        #    all of its distinctive column names to be present.
        /param/ && /mean/ && /median/ && /S\.D/ && /ESS\*/ && /Eff\*/ && /rho1/ {
            find_columns()
            in_table = (mean_col > 0 && lo_col > 0 && hi_col > 0)
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
                    find_columns()
                    in_table = (mean_col > 0 && lo_col > 0 && hi_col > 0)
                    just_saw_header = 1
                }
                next
            }

            # A proper data row must have at least as many fields as
            # the highest column index we need; otherwise assume the
            # table ended (e.g. we hit trailing prose like "FigTree
            # tree is in...").
            max_col = mean_col
            if (lo_col > max_col) max_col = lo_col
            if (hi_col > max_col) max_col = hi_col

            if (NF >= max_col) {
                print $1 "\t" $mean_col "\t" $lo_col "\t" $hi_col
            } else {
                in_table = 0
            }
            next
        }
    '
done
