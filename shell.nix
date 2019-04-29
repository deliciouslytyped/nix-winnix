with import <nixpkgs> {};
  let
   pp = callPackage ./lib/packages.nix {};
   setPath = self: super: { path = builtins.toString ./mount; }; #TODO hack
  in
    (pp.extend setPath).withPackages (p: with p; [ p.".kkrieger" ])
#    (pp.extend setPath).withPackages (p: with p; [ p."explorer++" cs2d ])
