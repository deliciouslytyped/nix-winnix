self: super: {
  config = {
    path = builtins.unsafeDiscardStringContext (builtins.toString ../mount);
    };
  }
