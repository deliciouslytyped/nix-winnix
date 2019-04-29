#TODO wrong callpackage
self: super:
  {
    lib = {
      rw-overlay = path: base: callback:  self.pkgs.callPackage ../lib/rw-overlay.nix {
        mountprefix = builtins.unsafeDiscardStringContext path; #TODO meh
        inherit base callback;
        };
      mkPrefix = wine: self.pkgs.callPackage ../lib/mkPrefix.nix {
        inherit wine;
        winetricks = self.winetricks; # see 2_packages.nix::winetricks
        };
      wineRunner = wine: game-data: prefix: path: self.pkgs.callPackage ../lib/winerunner.nix { inherit game-data wine prefix; mountprefix = path; };
      };

    #TODO this isnt really used yet and might not be necessary anyway
    toPackages = l:
      let
        isFunction = item: (builtins.typeOf item) == "lambda";
        optionalApply = case: f: item: if case then (f item) else item; #TODO better/shorter name?
        call = p: self.callPackage p {}; #TODO fix this callpackage thing
        #call = p: p { ghidra = self.ghidra; }; #TODO fix this callpackage thing
      in
        builtins.map (p: optionalApply (isFunction p) call p) l;

    combineWithPackages = p:
      with self.lib;
      let
        prefix = (mkPrefix self.wine);
      in
        rw-overlay self.path prefix (wineRunner self.wine (builtins.head p) prefix self.path); #TODO #TODO unhack: path, winerunner only takes head of packages

    withPackages = f: self.combineWithPackages (self.toPackages (f self));
    }
