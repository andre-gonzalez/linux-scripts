#!/bin/sh
# services-guard.sh — shared service bookkeeping for save-battery and save-data.
#
# Sourced (with `.`) by both scripts. Each owner keeps its state in
# ~/.cache/<owner>/:
#
#   profile            exists while the owner has a profile applied
#   claimed-services   every unit the applied profile wants stopped, including
#                      units that were already stopped when it was applied
#   stopped-services   units the owner stopped (or was handed) and must start
#                      again on restore
#
# On restore, an owner calls guard_release for each unit in its
# stopped-services list. When another owner is still active and claims the
# same unit, the unit stays stopped and moves to that owner's stopped-services
# list, so the last owner to restore starts it again.
#
# Function variables use a _g_ prefix: there is no POSIX `local`, and the
# callers' own variables must not be overwritten.

GUARD_OWNERS="save-battery save-data"

guard_dir() {
	printf '%s/.cache/%s' "$HOME" "$1"
}

# guard_claim OWNER UNIT... — record the units OWNER's profile wants stopped.
guard_claim() {
	_g_owner="$1"
	shift
	_g_dir=$(guard_dir "$_g_owner")
	mkdir -p "$_g_dir"
	for _g_unit in "$@"; do
		grep -qxF "$_g_unit" "$_g_dir/claimed-services" 2>/dev/null ||
			printf '%s\n' "$_g_unit" >>"$_g_dir/claimed-services"
	done
}

# guard_record OWNER UNIT — record that OWNER must start UNIT on restore.
guard_record() {
	_g_dir=$(guard_dir "$1")
	mkdir -p "$_g_dir"
	grep -qxF "$2" "$_g_dir/stopped-services" 2>/dev/null ||
		printf '%s\n' "$2" >>"$_g_dir/stopped-services"
}

# guard_release OWNER UNIT — return 0 when OWNER may start UNIT again.
# Return 1 when another active owner claims UNIT; the unit is then handed
# over to that owner.
guard_release() {
	for _g_other in $GUARD_OWNERS; do
		[ "$_g_other" = "$1" ] && continue
		_g_dir=$(guard_dir "$_g_other")
		[ -f "$_g_dir/profile" ] || continue
		grep -qxF "$2" "$_g_dir/claimed-services" 2>/dev/null || continue
		guard_record "$_g_other" "$2"
		return 1
	done
	return 0
}

# guard_forget OWNER — drop OWNER's claims (call at the end of a restore).
guard_forget() {
	rm -f "$(guard_dir "$1")/claimed-services"
}
