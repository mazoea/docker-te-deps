# CI images

## te-server dependencies (`te-dep-3.12-pp32:<version>-x86`, `:<version>-arm64`)

`public.ecr.aws/lambda/python:3.12` with te-server's OS packages and its hashed, pinned Python
lockfile installed, one image per architecture:

- `ghcr.io/mazoea/docker-te-deps/te-dep-3.12-pp32:2026-11-26-x86`
- `ghcr.io/mazoea/docker-te-deps/te-dep-3.12-pp32:2026-11-26-arm64`

`assets/requirements.txt` and `assets/requirements-os.txt` are byte-for-byte copies of te-server's
`requirements.txt` and `requirements-os.txt`. The image keeps them in `/opt/te-deps/`, and te-server's
CI checks that its `requirements.txt` is the same as the one in both images.

When te-server re-locks:
1. Copy te-server's `requirements.txt` and `requirements-os.txt` to `assets/` (no edits).
2. Set the version in `scripts/update.tag.bat`, merge, then run it on the merged commit.
   The tag push builds both images natively (`ubuntu-24.04` / `ubuntu-24.04-arm`) and publishes
   them as `te-dep-3.12-pp32:<version>-x86` / `:<version>-arm64`.
3. Point te-server at the new tags (Dockerfiles, `ci.yml`) in its re-lock PR.

Image name: `te-dep-<python>-pp<paddle>`; a new Python or Paddle version gets a new name (and
`IMG_REPO` in `ci.yml`). Version (the git tag): the date of the first PR with the new lockfile,
`YYYY-MM-DD`; a second one on the same day gets `YYYY-MM-DD.2`. A published version is never
overwritten, so te-server's base branch keeps its images until the re-lock PR there is merged.
The first version is `2026-11-26`; before it the images were `docker-te-deps:te-dep-3.12-pp32-lock-amd64` /
`-arm64` (no version).

Pull requests build and smoke-test both images without publishing them.
