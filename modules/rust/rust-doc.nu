# Opens the documentation for the currently active toolchain with the default browser.
#
# By default, it opens the documentation index. Use the various flags to open specific pieces of documentation.
def main [
  --path # Only print the path to the documentation
  --alloc # The Rust core allocation and collections library
  --book # The Rust Programming Language book
  --cargo # The Cargo Book
  --clippy # The Clippy Documentation
  --core # The Rust Core Library
  --edition-guide # The Rust Core Library
  --embedded-book # The Embedded Rust Book
  --error-codes # The Rust Error Codes Index
  --nomicon # The Dark Arts of Advaced and Unsafe Rust Programming
  --proc_macro # A support library for macro authors when defining new macros
  --reference # The Rust Reference
  --releases # Rust Release Notes
  --rust-by-example # A collection of runnable examples that illustrate various Rust concepts and standard libraries
  --rustc # The compiler for the Rust progarmming language
  --rustc-docs # The API documentation for the Rust compiler and other toolchain components
  --rustdoc # Documentation generator for Rust projects
  --std # Standard library API documentation
  --style-guide # Standard library API documentation
  --test # Support code for rustc's built in unit-test and micro-benchmarking framework
  --unstable-book # The Unstable Book
] {
  let print_path = $path

  let sources = [
    [text path requested span];
    ["The Rust core allocation and collections library" ["alloc"] $alloc (metadata $alloc).span]
    ["The Rust Programming Language book" ["book"] $book (metadata $book).span]
    ["The Cargo Book" ["cargo"] $cargo (metadata $cargo).span]
    ["The Clippy Documentation" ["clippy"] $clippy (metadata $clippy).span]
    ["The Rust Core Library" ["core"] $core (metadata $core).span]
    ["The Rust Edition Guide" ["edition-guide"] $edition_guide (metadata $edition_guide).span]
    ["The Embedded Rust Book" ["embedded-book"] $embedded_book (metadata $embedded_book).span]
    ["The Rust Error Codes Index" ["error-codes"] $error_codes (metadata $error_codes).span]
    ["The Dark Arts of Advaced and Unsafe Rust Programming" ["nomicon"] $nomicon (metadata $nomicon).span]
    ["A support library for macro authors when defining new macros" ["proc_macro"] $proc_macro (metadata $proc_macro).span]
    ["The Rust Reference" ["reference"] $reference (metadata $reference).span]
    ["Rust Release Notes" ["releases"] $releases (metadata $releases).span]
    ["A collection of runnable examples that illustrate various Rust concepts and standard libraries" ["rust-by-example"] $rust_by_example (metadata $rust_by_example).span]
    ["The compiler for the Rust progarmming language" ["rustc"] $rustc (metadata $rustc).span]
    ["The API documentation for the Rust compiler and other toolchain components" ["rustc-docs"] $rustc_docs (metadata $rustc_docs).span]
    ["Documentation generator for Rust projects" ["rustdoc"] $rustdoc (metadata $rustdoc).span]
    ["Standard library API documentation" ["std"] $std (metadata $std).span]
    ["Standard library API documentation" ["style-guide"] $style_guide (metadata $style_guide).span]
    ["Support code for rustc's built in unit-test and micro-benchmarking framework" ["test"] $test (metadata $test).span]
    ["The Unstable Book" ["unstable-book"] $unstable_book (metadata $unstable_book).span]
  ]

  let sources = $sources | where requested

  if ($sources | length) > 1 {
    error make {
      msg: $"Only one source can be opened at a time, but multiple were requested.",
      labels: $sources,
    }
  }

  let source = $sources | first | default { path: [] }
  let path = "{{RUST_PKG}}/share/doc/rust/html" | path join ...($source.path) | path join "index.html"

  if $print_path {
    print $path
  } else {
    xdg-open $path
  }
}
