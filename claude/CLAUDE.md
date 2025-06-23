
Always:

- Format, lint and test code before considering it done.
- Prefer writing tests before implementations. Development order should be:
  1. Write types and function signatures.
  2. Write behavior tests for those functions.
  3. Write implementations for the desired behavior.
- Be concise with documentation. Prefer documenting methods, struct fields, modules.
- Document not just what a method/struct/module is, but what it's role is relative to other methods/structs/modules.
- Avoid deeply nested if statements. Prefer happy path is the main path, early exits for unhappy paths when logical.
- Never include emojis into source code.
- Never write tests which are just reimplementations of an algorithm.

## Language specific behaviors

### Rust

- Never use `mod.rs`, use the name of the module instead. Eg `foo.rs`, with submodules under `foo/bar.rs`.
- Prefer implementations and algorithms that do not allocate.
- Avoid repetitive test code, prefer DRY principles to achieve the same result. Closures and functions are your friend.
- Don't prefix test funcs with `test_` in their names.
- Favor concise assert messages over comments around test assets.
- Include ``See also: [`Foo`]`` in docs for related types, methods, modules, etc.
- When building docs, don't use `--open`. That opens the browser and you're not using the browser.
