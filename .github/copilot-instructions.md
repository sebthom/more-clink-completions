# Contributing to more-clink-completions

Follow [CONTRIBUTING.md](../CONTRIBUTING.md) and base work on `v2`. Inspect the existing Haxe completion classes, utilities, and build workflow before changing the layout.

- Put new completion sources with the other Haxe classes in `src/more_clink_completions/completions/`. Use the existing Haxe-to-Lua build. Follow the README's short command index and keep command-specific implementation notes in source.
- When invoking an external Windows tool for help or matches, select the intended native executable. Validate any dynamic arguments and document shell-specific quoting assumptions. Avoid fixed install paths and user profile changes.
- Run `haxe build.hxml` and follow the Lua build steps in CI as applicable. Verify interactive Clink behavior separately. Keep optional checks against real applications outside the repository suite unless the project has an established place for them. Use captured output or fixtures when a test needs a tool's response.
- Keep review changes focused and reply to each review point with the actual result.
