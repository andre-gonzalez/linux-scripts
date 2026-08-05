#!/bin/sh
#
# push-new-notes.sh: commit the notes vault with a descriptive message per
# top-level bucket (pessoal / trabalho / estudo, root files as "notas"), then
# sync with origin.
#
# Run from cron every 10 minutes. Commits happen BEFORE the pull, so an offline
# tick still records a small, topical commit instead of batching a whole
# afternoon into one; the sync catches up on the next tick that has network.
#
# Messages come from git-commit-message.sh; a timestamp is used if that fails,
# so a sync is never lost to a message bug.

REPO="$HOME/projects/notas"
GEN="$HOME/.scripts/git-commit-message.sh"
HC_PING="https://hc-ping.com/fde92570-863b-4c76-a1c1-567c6f321a00"

# cron gives us no session environment, so notify-send needs these (same
# approach as profile-selector)
export DISPLAY=:0
XDG_RUNTIME_DIR="/run/user/$(id -u)"
export XDG_RUNTIME_DIR
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
export LC_ALL=C.UTF-8

warn() {
	printf 'push-new-notes: %s\n' "$1" >&2
}

alert() {
	warn "$1"
	notify-send -u critical "notes sync" "$1" 2>/dev/null
}

cd "$REPO" || {
	warn "cannot cd to $REPO"
	exit 1
}

GIT_DIR=$(git rev-parse --git-dir) || exit 1

# Never touch a repo that is mid-operation: staging into a conflicted rebase
# would commit conflict markers straight into the notes.
for state in rebase-merge rebase-apply MERGE_HEAD CHERRY_PICK_HEAD; do
	if [ -e "$GIT_DIR/$state" ]; then
		alert "repo is mid-$state, fix by hand"
		exit 1
	fi
done

# One path per line, both sides of a rename listed separately.
changed_paths() {
	git -c core.quotepath=false status --porcelain |
		while IFS= read -r line; do
			path=${line#???}
			case $path in
			*' -> '*)
				printf '%s\n' "${path%% -> *}"
				printf '%s\n' "${path#* -> }"
				;;
			*) printf '%s\n' "$path" ;;
			esac
		done
}

# Which buckets have changes? Directories are staged wholesale; files sitting at
# the repo root are staged individually under the "notas" label.
buckets=$(changed_paths |
	while IFS= read -r path; do
		case $path in
		*/*) printf '%s\n' "${path%%/*}" ;;
		*) printf 'notas\n' ;;
		esac
	done | sort -u)

oldifs=$IFS
IFS='
'
# shellcheck disable=SC2086 # deliberate newline-only split of the bucket list
set -- $buckets
IFS=$oldifs

for bucket in "$@"; do
	if [ "$bucket" = notas ]; then
		changed_paths | while IFS= read -r path; do
			case $path in
			*/*) continue ;;
			esac
			git add -A -- "./$path"
		done
	else
		git add -A -- "./$bucket" || warn "could not stage $bucket"
	fi

	git diff --cached --quiet && continue

	msg=$(sh "$GEN") || msg=""
	[ -n "$msg" ] || msg="$bucket: sync $(date +%Y-%m-%d_%T)"

	git commit -q -m "$msg" || alert "commit failed for $bucket"
done

if ! git pull --rebase -q; then
	if [ -e "$GIT_DIR/rebase-merge" ] || [ -e "$GIT_DIR/rebase-apply" ]; then
		git rebase --abort 2>/dev/null
		alert "rebase conflict, aborted. Resolve by hand."
	else
		warn "pull failed (offline?), retrying next tick"
	fi
	exit 1
fi

if ! git push -q -u origin main; then
	warn "push failed (offline?), retrying next tick"
	exit 1
fi

curl -s "$HC_PING" >/dev/null
