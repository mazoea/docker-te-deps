REM Publishes ghcr.io/mazoea/docker-te-deps:te-dep-3.12-pp32-lock2-amd64 and -arm64 (ci.yml on the tag push).
git push origin :te-dep-3.12-pp32-lock2
git tag -d te-dep-3.12-pp32-lock2
git tag te-dep-3.12-pp32-lock2
git push origin te_base_dep_3.12_paddle_3 --tags

pause
