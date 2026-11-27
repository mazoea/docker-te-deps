# CI images

## te-server dependencies (`te-dep-3.12-pp32-v1.1-amd64`, `te-dep-3.12-pp32-v1.1-arm64`)

`public.ecr.aws/lambda/python:3.12` with te-server's OS packages and its hashed, pinned Python
lockfile installed, one image per architecture:

- `ghcr.io/mazoea/docker-te-deps:te-dep-3.12-pp32-v1.1-amd64`
- `ghcr.io/mazoea/docker-te-deps:te-dep-3.12-pp32-v1.1-arm64`

`assets/requirements.txt` and `assets/requirements-os.txt` are byte-for-byte copies of te-server's
`requirements.txt` and `requirements-os.txt`. The image keeps them in `/opt/te-deps/`, and te-server's
CI checks that its `requirements.txt` is the same as the one in both images.

When te-server re-locks:
1. Copy te-server's `requirements.txt` and `requirements-os.txt` to `assets/` (no edits).
2. Bump the version in `scripts/update.tag.bat`, merge, then run it on the merged commit.
   The tag push builds both images natively (`ubuntu-24.04` / `ubuntu-24.04-arm`) and publishes
   them as `<tag>-amd64` / `<tag>-arm64`.
3. Point te-server at the new tag (Dockerfiles, `ci.yml`) in its re-lock PR.

Versions: `te-dep-<python>-pp<paddle>-v<major>.<minor>`. The minor goes up for a re-lock with the
same base (package bumps); the major goes up when the base image or the install changes. A
published version is never overwritten, so te-server's base branch keeps its images until the
re-lock PR there is merged. `te-dep-3.12-pp32-lock` is the unversioned predecessor of v1.1.

Pull requests build and smoke-test both images without publishing them.
