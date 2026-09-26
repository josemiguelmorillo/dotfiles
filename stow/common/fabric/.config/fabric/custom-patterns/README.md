# Custom Fabric patterns

Each pattern is a directory containing a `system.md` file. The directory name is
the pattern name passed to `fabric --pattern <name>`.

```
custom-patterns/
└── my_pattern/
    └── system.md
```

Fabric finds this directory through `CUSTOM_PATTERNS_DIRECTORY`, exported in
`~/.zshrc`. Patterns here are listed by `fabric --listpatterns` alongside the
upstream ones in `~/.config/fabric/patterns`, and a custom pattern wins when
both define the same name.

`fabric --updatepatterns` only refreshes the upstream directory, so nothing
here is ever overwritten.
