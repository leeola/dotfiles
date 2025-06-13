- Format, lint and test code before considering it done.
- Be concise with documentation. Prefer documenting methods, struct fields, modules.
- Avoid obvious documentation. Little expressions of code that are self explanatory don't need documentation. Focus on only documenting complex or ambiguous code. 
- Avoid deeply nested if statements. Prefer happy path is the main path, early exits for unhappy paths when logical.
- Never include emojis into source code.

## Language specific behaviors

### Rust

- Prefer implementations and algorithms that do not allocate.
- Avoid repetitive test code, prefer DRY principles to achieve the same result. Closures and functions are your friend.
- Don't prefix test funcs with `test_` in their names.
- Favor concise assert messages over comments around test assets.
- Prefer doctest docs over comments.
