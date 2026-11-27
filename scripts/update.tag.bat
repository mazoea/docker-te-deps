REM Publishes ghcr.io/mazoea/docker-te-deps:te-dep-3.12-pp32-v1.1-amd64 and -arm64 (ci.yml on the tag push).
REM Run on the merged commit. A published version is never overwritten: bump the version for a new lockfile.
git tag te-dep-3.12-pp32-v1.1
git push origin te-dep-3.12-pp32-v1.1

pause
