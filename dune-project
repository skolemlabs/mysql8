(lang dune 2.8)
(using mdx 0.1)

(name mysql8)
(version 1.2.7)

(license LGPL-2.1)
(maintainers "Zach Baylin <zach.baylin@skolem.com>")
(authors "Zach Baylin <zach.baylin@skolem.com>")

(source (github skolemlabs/mysql8))

(generate_opam_files true)

(use_standard_c_and_cxx_flags true)

(package
 (name mysql8)
 (synopsis "OCaml bindings to libmysql v8+")
 (depends
  (ocaml (>= 4.08.0))
  (dune (>= 2.8.0))
  (dune-configurator (>= 2.8.0))
  (ocamlfind :build)
  (ocamlformat :with-dev-setup)))
