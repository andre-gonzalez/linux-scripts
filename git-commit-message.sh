#!/bin/sh
#
# git-commit-message.sh: build a descriptive commit message from a diff.
#
# Usage:
#   git-commit-message.sh                 # message for the STAGED changes
#   git-commit-message.sh --commit <sha>  # message a past commit would have got
#
# Prints the message on stdout. Exits 1 (printing nothing) when the diff is
# empty, so callers can fall back to a message of their own.
#
# Subject grammar:
#   <bucket>: <file>: <verb> "<text>"            one logical change
#   <bucket>: <src> -> <dst> "<text>"            line moved between files
#   <bucket>: <file>: <verb> "<text>" (+N more)  several changes, one file
#   <bucket>: <f1>, <f2>, <f3> (+X/-Y)           several files, details in body
#   <b1>, <b2>: N notes (+X/-Y)                  commit spanning buckets
#
# Verbs: add, drop, done ([ ] -> [x]), reopen, edit, new, deleted,
#        renamed from, reordered, changed.
#
# Bucket = top-level directory; files at the repo root use "notas".

LC_ALL=${LC_ALL:-C.UTF-8}
export LC_ALL

mode=staged
sha=

case ${1:-} in
--commit)
	if [ -z "${2:-}" ]; then
		printf 'git-commit-message: --commit needs a revision\n' >&2
		exit 2
	fi
	mode=commit
	sha=$2
	;;
'') ;;
*)
	printf 'git-commit-message: unknown argument: %s\n' "$1" >&2
	exit 2
	;;
esac

if [ "$mode" = commit ]; then
	parent=$(git rev-parse --verify -q "$sha^") ||
		parent=$(git hash-object -t tree /dev/null)
	set -- -M "$parent" "$sha"
else
	set -- -M --cached
fi

# shellcheck disable=SC2016 # the awk program must not be expanded by the shell
awk_prog='
function base(p,   b) { b = p; sub(/^.*\//, "", b); return b }

function label(p,   b) { b = base(p); sub(/\.[^.\/]+$/, "", b); return b }

function bucketof(p,   i) {
	i = index(p, "/")
	if (i == 0) return "notas"
	return substr(p, 1, i - 1)
}

# Text used for equality tests: trailing " - 2026-08-04_14:59" stamps that the
# todo script appends are ignored, [x] folds to [ ] so a tick is not a change,
# and runs of whitespace collapse (the bookmarks table is column-padded).
function norm(s,   n) {
	n = s
	sub(/ - 2[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]_[0-9][0-9]:[0-9][0-9](:[0-9][0-9])?[ \t]*$/, "", n)
	gsub(BOX, "[ ]", n)
	gsub(EMPTYBOX, "[ ]", n)
	gsub(/[ \t]+/, " ", n)
	gsub(/^ | $/, "", n)
	return n
}

# Text shown to a human: markdown list/heading/quote markers, the bookmarks
# |P| tag and ** emphasis come off, URLs collapse to their host.
function clean(s,   t, changed, u, h) {
	t = s
	gsub(/^[ \t]+|[ \t]+$/, "", t)
	sub(/ - 2[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]_[0-9][0-9]:[0-9][0-9](:[0-9][0-9])?[ \t]*$/, "", t)
	do {
		changed = 0
		if (sub("^[-*+]+[ \t]*" BOX "[ \t]*", "", t)) changed = 1
		else if (sub("^[-*+]+[ \t]*" EMPTYBOX "[ \t]*", "", t)) changed = 1
		else if (sub(/^[-*+]+[ \t]+/, "", t)) changed = 1
		else if (sub(/^#+[ \t]*/, "", t)) changed = 1
		else if (sub(/^>[ \t]*/, "", t)) changed = 1
		else if (sub(/^\|[PAW]\|[ \t]*/, "", t)) changed = 1
	} while (changed)
	gsub(/\*\*/, "", t)
	while (match(t, /https?:\/\/[^ \t)]+/)) {
		u = substr(t, RSTART, RLENGTH)
		h = u
		sub(/^https?:\/\//, "", h)
		sub(/[\/?#].*$/, "", h)
		sub(/^www\./, "", h)
		t = substr(t, 1, RSTART - 1) "(" h ")" substr(t, RSTART + RLENGTH)
	}
	gsub(/[ \t]+/, " ", t)
	gsub(/^ | $/, "", t)
	return t
}

function boxof(s) {
	if (match(s, BOX)) return substr(s, RSTART + 1, 1)
	if (match(s, EMPTYBOX)) return " "
	return ""
}

function empty(s,   t) {
	t = clean(s)
	gsub(/[-=_ ]/, "", t)
	return (t == "")
}

function clip(s, n,   r) {
	if (n < 1) n = 1
	if (length(s) <= n) return s
	r = substr(s, 1, n - 1)
	sub(/[-_ ,;:.\t]+$/, "", r)
	return r "\342\200\246"
}

function addunit(f, verb, text, suffix,   k) {
	k = ++UN[f]
	UV[f, k] = verb
	UT[f, k] = text
	US[f, k] = suffix
	units++
}

function unitstr(f, k,   s) {
	s = UV[f, k]
	if (UT[f, k] != "") s = s " \"" clip(UT[f, k], BODYMAX) "\""
	if (US[f, k] != "") s = s " " US[f, k]
	return s
}

# subject = <buckets>: <lead>: <core>, shrinking the file label (floor 20) then
# the quoted text before hard-clipping, so content survives the 100-char cap.
function fit(prefix, lead, verb, text, suffix, textfirst,   s, over, room) {
	s = compose(prefix, lead, verb, text, suffix)
	# a move subject is two filenames wide: sacrifice the text, not the names
	if (textfirst && length(s) > MAX && text != "") {
		over = length(s) - MAX
		room = length(text) - over
		if (room < 10) room = 10
		text = clip(text, room)
		s = compose(prefix, lead, verb, text, suffix)
	}
	if (length(s) > MAX) {
		over = length(s) - MAX
		room = length(lead) - over
		if (room < 20) room = 20
		lead = clip(lead, room)
		s = compose(prefix, lead, verb, text, suffix)
	}
	if (length(s) > MAX && text != "") {
		over = length(s) - MAX
		room = length(text) - over
		if (room < 10) room = 10
		text = clip(text, room)
		s = compose(prefix, lead, verb, text, suffix)
	}
	return clip(s, MAX)
}

function compose(prefix, lead, verb, text, suffix,   s) {
	s = prefix lead
	if (verb != "") s = s ": " verb
	if (text != "") s = s " \"" text "\""
	if (suffix != "") s = s " " suffix
	return s
}

BEGIN {
	sec = "H"
	MAX = 100
	BODYMAX = 120
	BODYLINES = 10
	ARROW = " \342\206\222 "
	# an Obsidian task checkbox in any of its states: [ ] [x] [?] [/] [-] ...
	BOX = "\\[[ xX?/<>!*~-]\\]"
	EMPTYBOX = "\\[\\]"
}

{
	if (sec != "D") {
		if ($0 == "S") { sec = "S"; next }
		if ($0 == "N") { sec = "N"; next }
		if ($0 == "D") { sec = "D"; next }
	}
}

sec == "S" {
	n = split($0, fld, "\t")
	if (n < 2) next
	st = substr(fld[1], 1, 1)
	if (st == "R" || st == "C") { p = fld[3]; op = fld[2] } else { p = fld[2]; op = "" }
	if (!(p in seen)) { seen[p] = 1; FL[++nfiles] = p }
	ST[p] = st
	OP[p] = op
	next
}

sec == "N" {
	n = split($0, fld, "\t")
	if (n < 3) next
	p = fld[3]
	sub(/^.* => /, "", p)
	if (fld[1] ~ /^[0-9]+$/) NA[p] = fld[1] + 0
	if (fld[2] ~ /^[0-9]+$/) ND[p] = fld[2] + 0
	next
}

sec == "D" {
	if (index($0, "diff --git ") == 1) { cur = ""; inhunk = 0; next }
	if (substr($0, 1, 6) == "--- a/") { minus = substr($0, 7); next }
	if (substr($0, 1, 6) == "+++ b/") { cur = substr($0, 7); next }
	if ($0 == "+++ /dev/null") { cur = minus; next }
	if (substr($0, 1, 2) == "@@") { inhunk = 1; next }
	if (!inhunk || cur == "") next
	c = substr($0, 1, 1)
	if (c == "+") { na[cur]++; A[cur, na[cur]] = substr($0, 2) }
	else if (c == "-") { nr[cur]++; R[cur, nr[cur]] = substr($0, 2) }
	next
}

END {
	if (nfiles == 0) exit 1

	for (x = 1; x <= nfiles; x++) {
		f = FL[x]
		TA += NA[f]
		TD += ND[f]
		b = bucketof(f)
		if (!(b in bseen)) { bseen[b] = 1; BL[++nbuckets] = b }

		st = ST[f]
		if (st == "A") { addunit(f, "new", "", "(" NA[f] (NA[f] == 1 ? " line)" : " lines)")); continue }
		if (st == "D") { addunit(f, "deleted", "", ""); continue }
		if (st == "R" || st == "C") {
			addunit(f, (st == "R" ? "renamed from" : "copied from") " " label(OP[f]), "", "")
			continue
		}

		# pass 1: the same line with a different checkbox state is a state
		# change, not an edit. [x] means done, [ ] after [x] means reopened,
		# anything else (Obsidian allows [?] [/] [-] ...) is shown as-is.
		for (j = 1; j <= nr[f]; j++) {
			if (usedr[f, j]) continue
			rt = R[f, j]
			for (i = 1; i <= na[f]; i++) {
				if (useda[f, i]) continue
				at = A[f, i]
				if (norm(rt) != norm(at)) continue
				oldbox = boxof(rt)
				newbox = boxof(at)
				if (oldbox == "" || newbox == "" || oldbox == newbox) continue
				if (newbox == "x" || newbox == "X") verb = "done"
				else if (newbox == " ") verb = "reopen"
				else verb = "mark [" newbox "]"
				addunit(f, verb, clean(at), "")
				NORM[f, UN[f]] = norm(at)
				usedr[f, j] = 1; useda[f, i] = 1
				break
			}
		}

		# pass 2: identical text on both sides moved, it is not a change
		for (j = 1; j <= nr[f]; j++) {
			if (usedr[f, j]) continue
			for (i = 1; i <= na[f]; i++) {
				if (useda[f, i]) continue
				if (norm(R[f, j]) == norm(A[f, i])) {
					usedr[f, j] = 1; useda[f, i] = 1
					moved[f]++
					break
				}
			}
		}

		# pass 3: what is left is real. Pair adds with drops into edits.
		ni = 0; nj = 0
		for (i = 1; i <= na[f]; i++)
			if (!useda[f, i] && !empty(A[f, i])) ra[++ni] = A[f, i]
		for (j = 1; j <= nr[f]; j++)
			if (!usedr[f, j] && !empty(R[f, j])) rr[++nj] = R[f, j]

		k = 0
		while (k < ni && k < nj) {
			k++
			addunit(f, "edit", clean(ra[k]), "")
			NORM[f, UN[f]] = norm(ra[k])
		}
		for (i = k + 1; i <= ni; i++) {
			addunit(f, "add", clean(ra[i]), "")
			NORM[f, UN[f]] = norm(ra[i])
		}
		for (j = k + 1; j <= nj; j++) {
			addunit(f, "drop", clean(rr[j]), "")
			NORM[f, UN[f]] = norm(rr[j])
		}
		for (i = 1; i <= ni; i++) delete ra[i]
		for (j = 1; j <= nj; j++) delete rr[j]

		if (UN[f] == 0) {
			if (moved[f] > 0)
				addunit(f, "reordered", "", "(" na[f] + nr[f] " lines)")
			else
				addunit(f, "changed", "", "")
		}
	}

	# a line dropped from one file and added to another is one move, not two
	movesrc = ""
	if (units == 2 && nfiles == 2) {
		f1 = FL[1]; f2 = FL[2]
		if (UN[f1] == 1 && UN[f2] == 1) {
			if (UV[f1, 1] == "drop" && UV[f2, 1] == "add" && NORM[f1, 1] == NORM[f2, 1]) {
				movesrc = f1; movedst = f2; movetext = UT[f2, 1]
			} else if (UV[f2, 1] == "drop" && UV[f1, 1] == "add" && NORM[f1, 1] == NORM[f2, 1]) {
				movesrc = f2; movedst = f1; movetext = UT[f1, 1]
			}
		}
	}

	counts = "(+" TA "/-" TD ")"

	if (nbuckets > 1) {
		blist = BL[1]
		for (x = 2; x <= nbuckets; x++) blist = blist ", " BL[x]
		print clip(blist ": " nfiles " notes " counts, MAX)
	} else if (movesrc != "") {
		print fit(BL[1] ": ", label(movesrc) ARROW label(movedst), "", movetext, "", 1)
	} else if (nfiles == 1) {
		f = FL[1]
		suffix = US[f, 1]
		if (UN[f] > 1) suffix = "(+" UN[f] - 1 " more)"
		print fit(BL[1] ": ", label(f), UV[f, 1], UT[f, 1], suffix, 0)
	} else {
		# fill in filenames while they fit, always keeping room for the
		# "and N more (+X/-Y)" tail
		prefix = BL[1] ": "
		avail = MAX - length(prefix) - length(counts) - 1
		flist = ""
		shown = 0
		for (x = 1; x <= nfiles && shown < 3; x++) {
			cand = flist (shown ? ", " : "") label(FL[x])
			left = nfiles - (shown + 1)
			extra = left > 0 ? length(" and " left " more") : 0
			if (shown > 0 && length(cand) + extra > avail) break
			flist = cand
			shown++
		}
		if (nfiles > shown) flist = flist " and " nfiles - shown " more"
		print clip(prefix flist " " counts, MAX)
	}

	# body: only when there is more to say than the subject already says
	if (movesrc != "") exit 0
	if (nfiles == 1 && UN[FL[1]] <= 1) exit 0

	body = ""
	shownunits = 0
	for (x = 1; x <= nfiles && shownunits < BODYLINES; x++) {
		f = FL[x]
		for (k = 1; k <= UN[f] && shownunits < BODYLINES; k++) {
			if (nfiles == 1) body = body "  " unitstr(f, k) "\n"
			else body = body "  " label(f) ": " unitstr(f, k) "\n"
			shownunits++
		}
	}
	if (units > shownunits)
		body = body "  \342\200\246 and " units - shownunits " more changes\n"
	if (body != "") printf "\n%s", body
}
'

{
	printf 'S\n'
	git -c core.quotepath=false diff --name-status "$@"
	printf 'N\n'
	git -c core.quotepath=false diff --numstat "$@"
	printf 'D\n'
	git -c core.quotepath=false diff -U0 "$@"
} | awk "$awk_prog"
