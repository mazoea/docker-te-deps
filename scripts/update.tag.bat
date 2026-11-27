REM Publishes ghcr.io/mazoea/docker-te-deps/te-dep-3.12-pp32:2026-11-26-x86 and :2026-11-26-arm64 (ci.yml on the tag push).
REM Run on the merged commit. A published version is never overwritten: a new lockfile gets a new version.
git tag 2026-11-26
git push origin 2026-11-26

pause
