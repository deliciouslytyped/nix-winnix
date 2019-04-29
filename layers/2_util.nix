#TODO make stuff relying on path nicer, try to isolate path
#TODO I feel like the file has gotten bigger without getting any clearer
#TODO consider using super for some things
self: super:
  {
    lib = {
      #fully parametrized functions
      rw-overlay = {path, base, callback}: self.pkgs.callPackage ../lib/rw-overlay.nix {
        inherit base callback; mountprefix = path;
        };

      mkPrefix = wine: self.pkgs.callPackage ../lib/mkPrefix.nix {
        inherit wine;
        inherit (self) winetricks; # see 3_packages.nix::winetricks
        };

      wineRunner = {wine, prefix, path, game-data}:
        self.pkgs.callPackage ../lib/winerunner.nix {
          inherit game-data wine prefix; mountprefix = path;
          };

      #TODO move to lib or something
      #TODO using self as opposed to super causes infinite recursion for some reason
      pathMap = f: root: with builtins; map f (map (filename: "${root}/${filename}") (attrNames (readDir root)));
      pathMapAttrs = filterf: namef: valuef: root:
        let
          paths = super.pkgs.lib.mapAttrs (filename: _: "${root}/${filename}") (super.pkgs.lib.filterAttrs filterf (builtins.readDir root));
        in
          super.pkgs.lib.mapAttrs' (name: value: super.pkgs.lib.nameValuePair (namef name) (valuef value))  paths;

      #applied over "config"+(things that are at most a function of config/static stuff) (e.g. self.wine)
      withConfig = {
        rw-overlay = callback: self.lib.rw-overlay {
          path = self.config.path;
          base = self.lib.withConfig.prefix;
          inherit callback;
          };

        prefix = self.lib.mkPrefix self.wine;
        wineRunner = game-data: self.lib.wineRunner {
          wine = self.wine;
          prefix = self.lib.withConfig.prefix;
          path = self.config.path;
          inherit game-data;
          };
        };
      };

    combinePrefixWithPackages = p:
      with { inherit (self.lib.withConfig) rw-overlay wineRunner; };
        #TODO winerunner only takes head of packages / rwoverlay can only handle one layer 
        rw-overlay (wineRunner (builtins.head p) );

    withPackages = f: self.combinePrefixWithPackages (f self);
    }
