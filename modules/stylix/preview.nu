const module = path self

def main [
  --name: string # Name of the scheme file
  --file: path # Path to the scheme file
  --table # Preview a table of colors
  --rust # Preview Rust code
  --nix # Preview Nix code
  --shell # Preview a shell prompt
  --all # Enable all previews
  --clear # Clear the screen
  --watch # Watch for changes
] {
  let scheme = if ($file != null) {
    $file | path expand
  } else {
    $module | path join $"../($name).yaml" | path expand
  }

  if $watch {
    loop {
      main --file=$scheme --table=$table --rust=$rust --nix=$nix --shell=$shell --all=$all --clear=$clear

      for _ in (watch $scheme) {
        break
      }

      print ""
    }
  } else {  
    if $clear {
      clear
    }
  
    let palette = open $scheme | get palette

    let default = [$table $rust $shell $all] | all ($it == false)

    mut previews = []

    if ($all or $table or $default) {
      $previews = append $previews (preview table $palette)
    }

    if ($all or $rust or $default) {
      $previews = append $previews (preview rust $palette)
    }

    if ($all or $nix) {
      $previews = append $previews (preview nix $palette)
    }

    if ($all or $shell) {
      $previews = append $previews (preview shell $palette)
    }

    $previews | str join $"\n\n(paint $palette.base03 "---")\n\n" | print
  }
}

def paint [color text --background --end-of-line] {
  let text = if $end_of_line {
    $text | split row "\n" | each { |$it| $"($it)(ansi erase_line)" } | str join "\n"
  } else { $text }

  if $background {
    $"(ansi --escape {bg: $color})($text)(ansi --escape {bg: "reset"})"
  } else {
    $"(ansi --escape {fg: $color})($text)(ansi --escape {fg: "reset"})"
  }
}

def "preview table" [palette --chunk_size=4] {
  let table = $palette
  | items { |key, value| paint $value $key}
  | chunks $chunk_size
  | each { str join " " }
  | str join "\n"

  paint --background --end-of-line $palette.base00 $table
}

def "preview rust" [palette] {
  def "paint text" [text] {
    paint $palette.base05 $text
  }

  def "paint key" [name] {
    paint $palette.base0E $name
  }

  def "paint comment" [content] {
    paint $palette.base03 $"// ($content)"
  }

  def "paint func" [name] {
    paint $palette.base0D $name
  }

  def "paint var" [name] {
    paint $palette.base08 $name
  }

  def "paint type" [name] {
    paint $palette.base0A $name
  }

  def "paint num" [value] {
    paint $palette.base09 $value
  }

  def "paint str" [content] {
    paint $palette.base0B $"\"($content)\""
  }

  paint --background --end-of-line $palette.base00 $"(paint key use) (paint key tinty)(paint text ::)(paint text "{")(paint type Scheme)(paint text ,) (paint type Theme)(paint text "}")(paint text ";")

(paint comment "load and apply a color scheme")
(paint key fn) (paint func apply)(paint text "(")(paint var name)(paint text :) (paint text &)(paint type str)(paint text ")") (paint text "->") (paint type Option)(paint text <)(paint type Theme)(paint text >) (paint text "{")
    (paint key let) (paint var scheme) (paint text "=") (paint type Scheme)(paint text ::)(paint func load)(paint text "(")(paint var name)(paint text ")")(paint text ?)(paint text ";")
    (paint key let) (paint var theme) (paint text "=") (paint var scheme)(paint text .)(paint func with_base)(paint text "(")(paint num 16)(paint text ")")(paint text .)(paint func build)(paint text "(")(paint text ")")(paint text ";")
    (paint var theme)(paint text .)(paint func apply)(paint text "(")(paint text ")")(paint text ";")
    (paint func println!)(paint text "(")(paint str "applied: {}")(paint text ,) (paint var theme)(paint text .)(paint func name)(paint text "(")(paint text ")")(paint text ")")(paint text ";")
    (paint type Some)(paint text "(")(paint var theme)(paint text ")")
(paint text "}")"
}

def "preview nix" [palette] {
  def "paint text" [text] {
    paint $palette.base05 $text
  }

  def "paint key" [name] {
    paint $palette.base0E $name
  }

  def "paint attr" [name] {
    paint $palette.base0D $name
  }

  def "paint var" [name] {
    paint $palette.base08 $name
  }

  def "paint path" [path] {
    paint $palette.base0B $path
  }

  def "paint str" [content] {
    paint $palette.base0B $"\"($content)\""
  }

  def "paint comment" [content] {
    paint $palette.base03 $"# ($content)"
  }

  def "paint bool" [value] {
    paint $palette.base09 $value
  }

  paint --background --end-of-line $palette.base00 $"(paint text "{") (paint var pkgs)(paint text ,) (paint text ...) (paint text "}")(paint text :)

{
  (paint comment "My NixOS configuration")
  (paint attr imports) (paint text "=") (paint text "[")(paint path ./hardware-configuration.nix)(paint text "]")(paint text ";")

  (paint attr networking)(paint text .)(paint attr hostName) (paint text "=") (paint str "nixos")(paint text ";")
  (paint attr environment).(paint attr systemPackages) (paint text "=") (paint key with) (paint var pkgs)(paint text ";") (paint text "[")(paint var hello)(paint text "]")(paint text ";") 
  (paint attr services).(paint attr openssh).(paint attr enable) (paint text "=") (paint bool true)(paint text ";") 
(paint text "}")"
}

def "preview shell" [palette] {
  def "paint text" [text] {
    paint $palette.base05 $text
  }

  paint --background --end-of-line $palette.base00 $"(paint $palette.base0C test) (paint text on) (paint $palette.base0E "git main") (paint $palette.base08 [x!+?>]) (paint text via) (paint $palette.base0D "nix impure (nix-shell-env)")
(paint $palette.base0B >) (paint $palette.base0C echo) (paint $palette.base0B "\"Hello, world!\"")
(paint text "Hello, world!")"
}
