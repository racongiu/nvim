# `_archive/` — stacks de langages retirées

Rien ici n'est chargé par Neovim : ce dossier n'est ni dans le `runtimepath`
(donc `_archive/lsp/` et `_archive/after/` sont ignorés), ni dans le
`package.path` de Lua (donc `_archive/lua/` n'est pas `require`-able), et
`utils/langs.lua` ne scanne que `lua/plugins/lang/`.

C'est un dépôt de code mort, gardé intact pour être soit **réactivé tel quel**,
soit **refactoré** plus tard.

## Ce qui reste actif

`lua`, `c` (avec la norme 42 via `normc42`), `python`, `markdown`.

`bash` / `zsh` n'ont jamais eu de fiche : rien n'a été retiré pour eux.

## Ce qui a été archivé

| Langage | Fiche | Serveur(s) LSP | Autres fichiers |
|---|---|---|---|
| ansible | `lua/plugins/lang/ansible.lua` | `lsp/ansiblels.lua` | |
| css | `lua/plugins/lang/css.lua` | `lsp/cssls.lua` | dépend de `utils/markers.lua` |
| docker | `lua/plugins/lang/docker.lua` | `lsp/dockerls.lua`, `lsp/docker_compose_language_service.lua` | |
| html | `lua/plugins/lang/html.lua` | `lsp/html.lua` | dépend de `utils/markers.lua` |
| json | `lua/plugins/lang/json.lua` | `lsp/jsonls.lua` | plugin `SchemaStore.nvim` |
| toml | `lua/plugins/lang/toml.lua` | `lsp/taplo.lua` | |
| typescript | `lua/plugins/lang/typescript.lua` | `lsp/vtsls.lua` | dépend de `utils/markers.lua` |
| yaml | `lua/plugins/lang/yaml.lua` | `lsp/yamlls.lua` | `after/ftplugin/yaml.lua` |

`lua/utils/markers.lua` est archivé aussi : plus aucun fichier actif ne
l'utilisait (seuls css, html et typescript le `require`-aient).
`utils/project.lua` est resté en place, il sert à `lang/python.lua`.

L'arborescence de ce dossier est un miroir de celle de la config : pour
restaurer un fichier, il suffit de retirer le préfixe `_archive/` de son chemin.

## Réactiver un langage

1. **Remettre les fichiers en place.** Exemple pour `yaml` :

   ```sh
   cd ~/.config/nvim
   mv _archive/lua/plugins/lang/yaml.lua lua/plugins/lang/
   mv _archive/lsp/yamlls.lua lsp/
   mv _archive/after/ftplugin/yaml.lua after/ftplugin/
   ```

   Pour `css`, `html` ou `typescript`, remettre aussi la dépendance partagée :

   ```sh
   mv _archive/lua/utils/markers.lua lua/utils/
   ```

2. **Le toggle est optionnel.** `utils/langs.lua` considère qu'une entrée
   absente de `config/langs.lua` = activée. Reposer la fiche dans
   `lua/plugins/lang/` suffit donc à la rallumer. Ajouter la ligne dans
   `config/langs.lua` sert seulement à garder l'interrupteur visible :

   ```lua
   yaml = true,
   ```

3. **Réinstaller les binaires.** `mason-tool-installer` lit le champ `tools`
   de la fiche au démarrage : relancer `nvim` puis `:Mason` pour vérifier.

## Modifications faites hors de ce dossier

Trois fichiers actifs ont été touchés. À remettre selon le langage réactivé.

### `lua/config/langs.lua`

Les entrées `ansible`, `css`, `docker`, `html`, `json`, `toml`, `typescript`
et `yaml` ont été retirées de la table (voir le point 2 ci-dessus : optionnel).

### `lua/config/pack.lua` — pour `json` uniquement

Ligne retirée de `vim.pack.add({ ... })` :

```lua
{ src = "https://github.com/b0o/SchemaStore.nvim" }, -- data only, used by lsp/jsonls.lua
```

Le plugin reste installé sur disque tant qu'il n'est pas désinstallé
explicitement : `:lua vim.pack.del({ "SchemaStore.nvim" })`.
`render-markdown.nvim` a été gardé (markdown est resté actif).

### `lua/plugins/coding.lua` — parsers tree-sitter

La liste passée à `require("nvim-treesitter").install({ ... })` est réduite à
`c`, `cpp`, `lua`, `python`. Parsers retirés, à remettre selon le besoin :

```lua
"javascript", "typescript", "tsx",   -- lang/typescript
"json",                              -- lang/json
"css", "scss",                       -- lang/css
"html",                              -- lang/html
"yaml",                              -- lang/yaml, lang/ansible, lang/docker
"toml",                              -- lang/toml
"dockerfile",                        -- lang/docker
```

(`markdown` / `markdown_inline` ne sont pas dans cette liste : Neovim les
embarque, c'est ce dont `render-markdown.nvim` se sert.)

Deux alias de parsers ont aussi été supprimés, à remettre juste après le bloc
`install` :

```lua
-- no dedicated jsonc parser on the main branch: reuse the json one
vim.treesitter.language.register("json", "jsonc")            -- lang/json
-- compound yaml filetypes share the yaml parser
vim.treesitter.language.register("yaml", { "yaml.docker-compose", "yaml.ansible" })  -- lang/docker, lang/ansible
```

## Si tu refactores plutôt que de réactiver

Les fiches sont des tables de données pures consommées par
`plugins/lsp/lsp.lua`, `plugins/format.lua` et `plugins/lint.lua`. Le contrat
d'une fiche : `lsp`, `tools`, `formatters`, `linters`, `custom_formatters`,
`custom_linters`, `embedded_linters`, `enabled`, `setup`. Tant que ce contrat
ne bouge pas, ces fichiers restent réutilisables tels quels.
