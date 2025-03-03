# Go versions

Only version ``1.21.3`` is tested as of March 3rd 2025.

At the bottom of the [Go spec](https://go.dev/ref/spec#language-versions) there is a list of language changes that occur for every version.

In addition the patch notes of a version list what stdlib changes there are, although there is a backwards compatibility promise in place, this only covers the outward facing api, so the internals can be changed up and this can cause problems for go2hx which may rely on their consistency.
