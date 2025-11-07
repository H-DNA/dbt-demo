{
  description = "jaffle-shop on NixOS with dbt-duckdb";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  outputs = { self, nixpkgs }:
  let
    systems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = f: builtins.listToAttrs (map (sys: { name = sys; value = f sys; }) systems);
  in {
    devShells = forAllSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        default = pkgs.mkShell {
          packages = with pkgs; [
            postgresql_17
            dbt
            (dbt.withAdapters (adapters: [ adapters.dbt-postgres ]))
            git
            uv
          ];
        };
      });
  };
}
